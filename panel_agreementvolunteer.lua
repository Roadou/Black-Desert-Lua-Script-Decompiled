local _panel = Panel_AgreementVolunteer
local AgreementVolunteer = {
  _ui = {
    _stc_from = nil,
    _stc_to = nil,
    _stc_payment = nil,
    _stc_bonus = nil,
    _btn_confirm = nil,
    _btn_refuse = nil,
    _chk_alwaysRefuse = nil,
    _frame = nil,
    _stc_guildIcon = nil,
    _stc_sign = nil,
    _edit_sign = nil,
    _btn_close = nil
  }
}
function AgreementVolunteer:open()
  PaGlobal_AgreementVolunteer_CheckLoadUI()
end
function AgreementVolunteer:close()
  PaGlobal_AgreementVolunteer_CheckCloseUI()
end
function AgreementVolunteer:init()
  if nil == Panel_AgreementVolunteer then
    return
  end
  self._ui._stc_from = UI.getChildControl(Panel_AgreementVolunteer, "StaticText_From")
  self._ui._stc_to = UI.getChildControl(Panel_AgreementVolunteer, "StaticText_To")
  self._ui._stc_payment = UI.getChildControl(Panel_AgreementVolunteer, "StaticText_Payment")
  self._ui._stc_bonus = UI.getChildControl(Panel_AgreementVolunteer, "StaticText_Bonus")
  self._ui._btn_confirm = UI.getChildControl(Panel_AgreementVolunteer, "Button_Confirm")
  self._ui._btn_refuse = UI.getChildControl(Panel_AgreementVolunteer, "Button_Refuse")
  self._ui._chk_alwaysRefuse = UI.getChildControl(Panel_AgreementVolunteer, "CheckButton_AlwaysRefuse")
  self._ui._frame = UI.getChildControl(Panel_AgreementVolunteer, "Frame_1")
  self._ui._stc_guildIcon = UI.getChildControl(Panel_AgreementVolunteer, "Static_GuildMark")
  self._ui._stc_sign = UI.getChildControl(Panel_AgreementVolunteer, "StaticText_Sign")
  self._ui._edit_sign = UI.getChildControl(Panel_AgreementVolunteer, "Edit_Sign")
  self._ui._btn_close = UI.getChildControl(Panel_AgreementVolunteer, "Button_Close")
  self._ui._frameContent = UI.getChildControl(self._ui._frame, "Frame_1_Content")
  self._ui._contractContent = UI.getChildControl(self._ui._frameContent, "StaticText_1")
  self._ui._contractContent:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  local optionWrapper = ToClient_getGameOptionControllerWrapper()
  if nil ~= optionWrapper then
    local isRefuseRequest = optionWrapper:getRefuseRequests()
    self._ui._chk_alwaysRefuse:SetCheck(isRefuseRequest)
    self._ui._chk_alwaysRefuse:SetShow(true)
    self._ui._chk_alwaysRefuse:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_ALWAYSREFUSE"))
  else
    self._ui._chk_alwaysRefuse:SetShow(false)
  end
  self._ui._contractContent:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENT_VOLUNTEER_CONTRACT_CONTENTS"))
  self._ui._frameContent:SetSize(self._ui._frameContent:GetSizeX(), self._ui._contractContent:GetTextSizeY())
  self._ui._frame:UpdateContentPos()
  if self._ui._contractContent:GetTextSizeY() < self._ui._frame:GetSizeY() then
    self._ui._frame:GetVScroll():SetShow(false)
  else
    self._ui._frame:GetVScroll():SetShow(true)
  end
  self._ui._edit_sign:SetPosX(self._ui._stc_sign:GetPosX() + self._ui._stc_sign:GetTextSizeX() + 5)
end
function AgreementVolunteer:registEventHandler()
  if nil == Panel_AgreementVolunteer then
    return
  end
  self._ui._btn_confirm:addInputEvent("Mouse_LUp", "FGlobal_AgreementVolunteer_Confirm()")
  self._ui._btn_refuse:addInputEvent("Mouse_LUp", "FGlobal_AgreementVolunteer_Refuse()")
  self._ui._edit_sign:addInputEvent("Mouse_LUp", "HandleClick_EditSignBox_AgreementVolunteer()")
  self._ui._btn_close:addInputEvent("Mouse_LUp", "HandleEventLUp_AgreementVolunteer_Close()")
  local optionWrapper = ToClient_getGameOptionControllerWrapper()
  if nil ~= optionWrapper then
    self._ui._chk_alwaysRefuse:addInputEvent("Mouse_LUp", "HandleClicked_AgreementVolunteer_RefuseOption(0)")
    self._ui._chk_alwaysRefuse:addInputEvent("Mouse_On", "HandleOnOut_AgreementVolunteer_RefuseTip(true)")
    self._ui._chk_alwaysRefuse:addInputEvent("Mouse_Out", "HandleOnOut_AgreementVolunteer_RefuseTip(false)")
  end
end
function AgreementVolunteer:registMessageHandler()
  registerEvent("FromClient_inviteGuildVolunteerMember", "FromClient_AgreementVolunteer_inviteGuildVolunteerMember")
end
function HandleClicked_AgreementVolunteer_RefuseOption()
  if nil == Panel_AgreementVolunteer then
    return
  end
  local self = AgreementVolunteer
  setRefuseRequests(self._ui._chk_alwaysRefuse:IsCheck())
end
function HandleOnOut_AgreementVolunteer_RefuseTip(isShow)
  local self = AgreementVolunteer
  if false == isShow or nil == isShow then
    TooltipSimple_Hide()
    return
  else
    if nil == Panel_AgreementVolunteer then
      return
    end
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_ALWAYSREFUSE")
    local desc = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_ALWAYSREFUSE_TIP_DESC")
    local control = self._ui._chk_alwaysRefuse
    TooltipSimple_Show(control, name, desc)
  end
end
function HandleClick_EditSignBox_AgreementVolunteer()
  if nil == Panel_AgreementVolunteer then
    return
  end
  local self = AgreementVolunteer
  self._ui._edit_sign:SetText("")
  SetFocusEdit(self._ui._edit_sign)
end
function FromClient_AgreementVolunteer_Open(guildNo, guildName, masterNo, masterName, payment, bonus)
  local self = AgreementVolunteer
  self:open()
  self._ui._stc_sign:SetShow(true)
  self._ui._edit_sign:SetShow(true)
  self._ui._btn_confirm:SetShow(true)
  self._ui._btn_refuse:SetShow(true)
  self._ui._chk_alwaysRefuse:SetShow(true)
  self._ui._btn_close:SetShow(false)
  local paymentValue = payment
  local bonusValue = bonus
  local employerName = masterName
  local employerGuildName = guildName
  local myName = ""
  if nil == getSelfPlayer() then
    return
  end
  myName = getSelfPlayer():getName()
  local myGuildName = ""
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil ~= myGuildInfo then
    myGuildName = "(" .. myGuildInfo:getName() .. ")"
  end
  self._ui._stc_from:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_AGREEMENT_VOLUNTEER_EMPLOYER_GUILD", "employer", employerName, "employerGuild", "(" .. employerGuildName .. ")"))
  self._ui._stc_to:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_AGREEMENT_VOLUNTEER_VOLUNTEER_PLAYER", "employee", myName, "employeeGuild", myGuildName))
  self._ui._stc_payment:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_AGREEMENT_VOLUNTEER_CONTRACT_PAYMENT_TEXT", "paymentValue", makeDotMoney(paymentValue)))
  self._ui._stc_bonus:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_AGREEMENT_VOLUNTEER_CONTRACT_BONUS_TEXT", "bonusValue", makeDotMoney(bonusValue)))
  local isSet = setGuildTextureByGuildNo(guildNo, self._ui._stc_guildIcon)
  if false == isSet then
    self._ui._stc_guildIcon:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui._stc_guildIcon, 183, 1, 188, 6)
    self._ui._stc_guildIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui._stc_guildIcon:setRenderTexture(self._ui._stc_guildIcon:getBaseTexture())
  else
    self._ui._stc_guildIcon:getBaseTexture():setUV(0, 0, 1, 1)
    self._ui._stc_guildIcon:setRenderTexture(self._ui._stc_guildIcon:getBaseTexture())
  end
end
function FGlobal_AgreementVolunteer_ListContract_Open(isSelf, index)
  local self = AgreementVolunteer
  self:open()
  self._ui._stc_sign:SetShow(false)
  self._ui._edit_sign:SetShow(false)
  self._ui._btn_confirm:SetShow(false)
  self._ui._btn_refuse:SetShow(false)
  self._ui._chk_alwaysRefuse:SetShow(false)
  self._ui._btn_close:SetShow(true)
  local volunteerName = ""
  local guildInfo = ToClient_GetMyGuildInfoWrapper()
  local guildName = ""
  local guildMasterName = ""
  local contractPayment = 0
  local successBonus = 0
  if nil == guildInfo then
    return
  end
  guildName = guildInfo:getName()
  guildMasterName = guildInfo:getGuildMasterName()
  local volunteerMember = guildInfo:getVolunteerMember(index - 1)
  contractPayment = volunteerMember:getVolunteerContractAmount(index - 1)
  successBonus = volunteerMember:getVolunteerContractBenefit(index - 1)
  if true == isSelf then
    if false == getSelfPlayer() then
      return
    end
    volunteerName = getSelfPlayer():getName()
    self._ui._stc_to:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_AGREEMENT_VOLUNTEER_VOLUNTEER_PLAYER", "employee", volunteerName, "employeeGuild", ""))
  else
    if false == volunteerMember:isOnline() or true == volunteerMember:isGhostMode() then
      volunteerName = volunteerMember:getName()
    else
      volunteerName = volunteerMember:getCharacterName()
    end
    self._ui._stc_to:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_AGREEMENT_VOLUNTEER_VOLUNTEER_PLAYER", "employee", volunteerName, "employeeGuild", ""))
  end
  self._ui._stc_from:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_AGREEMENT_VOLUNTEER_EMPLOYER_GUILD", "employer", guildMasterName, "employerGuild", "(" .. guildName .. ")"))
  self._ui._stc_payment:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_AGREEMENT_VOLUNTEER_CONTRACT_PAYMENT_TEXT", "paymentValue", makeDotMoney(contractPayment)))
  self._ui._stc_bonus:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_AGREEMENT_VOLUNTEER_CONTRACT_BONUS_TEXT", "bonusValue", makeDotMoney(successBonus)))
  local isSet = setGuildTextureByGuildNo(guildInfo:getGuildNo_s64(), self._ui._stc_guildIcon)
  if false == isSet then
    self._ui._stc_guildIcon:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui._stc_guildIcon, 183, 1, 188, 6)
    self._ui._stc_guildIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui._stc_guildIcon:setRenderTexture(self._ui._stc_guildIcon:getBaseTexture())
  else
    self._ui._stc_guildIcon:getBaseTexture():setUV(0, 0, 1, 1)
    self._ui._stc_guildIcon:setRenderTexture(self._ui._stc_guildIcon:getBaseTexture())
  end
end
function HandleEventLUp_AgreementVolunteer_Close()
  local self = AgreementVolunteer
  self:close()
end
function FGlobal_AgreementVolunteer_Close()
  local self = AgreementVolunteer
  if nil ~= Panel_AgreementVolunteer and false == self._ui._btn_close:GetShow() then
    ToClient_ResponseInviteGuildVolunteerMember(false)
  end
  self:close()
end
function FGlobal_AgreementVolunteer_Refuse()
  local self = AgreementVolunteer
  ToClient_ResponseInviteGuildVolunteerMember(false)
  self:close()
end
function FGlobal_AgreementVolunteer_Confirm()
  if nil == Panel_AgreementVolunteer then
    return
  end
  local self = AgreementVolunteer
  if nil == getSelfPlayer() then
    return
  end
  if getSelfPlayer():getName() == self._ui._edit_sign:GetText() then
    ToClient_ResponseInviteGuildVolunteerMember(true)
    self:close()
    PaGlobal_CheckVolunteerList()
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENT_VOLUNTEER_SIGN_ERROR_MESSAGE"))
  end
end
function FromClient_AgreementVolunteer_inviteGuildVolunteerMember(guildNo, guildName, masterNo, masterName, payment, bonus)
  FromClient_AgreementVolunteer_Open(guildNo, guildName, masterNo, masterName, Int64toInt32(payment), Int64toInt32(bonus))
end
function PaGlobal_AgreementVolunteer_CheckLoadUI()
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_AgreementVolunteer:SetShow(true)
    return
  end
  local rv = reqLoadUI("UI_Data/Window/Guild/Panel_AgreementVolunteer.XML", "Panel_AgreementVolunteer", Defines.UIGroup.PAGameUIGroup_Window_Progress, PAUIRenderModeBitSet({
    Defines.RenderMode.eRenderMode_Default
  }))
  if nil ~= rv then
    Panel_AgreementVolunteer = rv
    rv = nil
    PaGlobal_AgreementVolunteer_Init()
  end
  Panel_AgreementVolunteer:SetShow(true)
end
function PaGlobal_AgreementVolunteer_CheckCloseUI()
  if nil == Panel_AgreementVolunteer then
    return
  end
  if false == Panel_AgreementVolunteer:GetShow() then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_AgreementVolunteer:SetShow(false)
  else
    reqCloseUI(Panel_AgreementVolunteer)
  end
end
function FromClient_luaLoadComplete_AgreementVolunteer()
  PaGlobal_AgreementVolunteer_Init()
  AgreementVolunteer:registMessageHandler()
end
function PaGlobal_AgreementVolunteer_Init()
  AgreementVolunteer:init()
  AgreementVolunteer:registEventHandler()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_AgreementVolunteer")

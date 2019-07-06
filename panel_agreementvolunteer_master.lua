local AgreementVolunteer_Master = {
  _ui = {
    _btn_hire = nil,
    _btn_cancle = nil,
    _stc_from = nil,
    _stc_to = nil,
    _edit_payment = nil,
    _edit_bonus = nil,
    _frameBG = nil,
    _stc_guildIcon = nil
  },
  _max_payment = nil,
  _max_successPay = nil,
  _volunteerName = nil,
  _payment = nil,
  _bonus = nil
}
function AgreementVolunteer_Master:open()
  PaGlobal_AgreementVolunteerMaster_CheckLoadUI()
end
function AgreementVolunteer_Master:close()
  PaGlobal_AgreementVolunteerMaster_CheckCloseUI()
end
function AgreementVolunteer_Master:init()
  if nil == Panel_AgreementVolunteer_Master then
    return
  end
  self._ui._btn_hire = UI.getChildControl(Panel_AgreementVolunteer_Master, "Button_Hire")
  self._ui._btn_cancle = UI.getChildControl(Panel_AgreementVolunteer_Master, "Button_Cancle")
  self._ui._stc_from = UI.getChildControl(Panel_AgreementVolunteer_Master, "StaticText_From")
  self._ui._stc_to = UI.getChildControl(Panel_AgreementVolunteer_Master, "StaticText_To")
  self._ui._edit_payment = UI.getChildControl(Panel_AgreementVolunteer_Master, "Edit_Payment")
  self._ui._edit_bonus = UI.getChildControl(Panel_AgreementVolunteer_Master, "Edit_Bonus")
  self._ui._frameBG = UI.getChildControl(Panel_AgreementVolunteer_Master, "Frame_Volunteer")
  self._ui._stc_guildIcon = UI.getChildControl(Panel_AgreementVolunteer_Master, "Static_GuildMark")
  self._ui._frameContent = UI.getChildControl(self._ui._frameBG, "Frame_1_Content")
  self._ui._contractContent = UI.getChildControl(self._ui._frameContent, "StaticText_Contents")
  self._ui._contractContent:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._contractContent:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENT_VOLUNTEER_CONTRACT_CONTENTS"))
  self._ui._frameContent:SetSize(self._ui._frameContent:GetSizeX(), self._ui._contractContent:GetTextSizeY())
  self._ui._frameBG:UpdateContentPos()
  if self._ui._contractContent:GetTextSizeY() < self._ui._frameBG:GetSizeY() then
    self._ui._frameBG:GetVScroll():SetShow(false)
  else
    self._ui._frameBG:GetVScroll():SetShow(true)
  end
  self._max_payment = ToClient_getMaxVolunteerContractAmount()
  self._max_successPay = ToClient_getMaxVolunteerContractBenefit()
end
function AgreementVolunteer_Master:registEventHandler()
  if nil == Panel_AgreementVolunteer_Master then
    return
  end
  self._ui._btn_hire:addInputEvent("Mouse_LUp", "FGlobal_AgreementVolunteer_Master_Hire()")
  self._ui._btn_cancle:addInputEvent("Mouse_LUp", "FGlobal_AgreementVolunteer_Master_Close()")
  self._ui._edit_payment:addInputEvent("Mouse_LUp", "FGlobal_AgreementVolunteer_Master_Edit_Payment()")
  self._ui._edit_bonus:addInputEvent("Mouse_LUp", "FGlobal_AgreementVolunteer_Master_Edit_Bonus()")
end
function AgreementVolunteer_Master:registMessageHandler()
  registerEvent("FromClient_resultInviteGuildVolunteerMember", "FromClient_AgreementVolunteer_resultInviteGuildVolunteerMember")
end
function FGlobal_AgreementVolunteer_Master_Open(volunteerName)
  local self = AgreementVolunteer_Master
  self:open()
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    return
  end
  self._ui._edit_payment:SetEditText("0")
  self._ui._edit_bonus:SetEditText("0")
  self._payment = 0
  self._bonus = 0
  local myName = ""
  local myGuildName = ""
  if nil == getSelfPlayer() then
    return
  end
  myName = getSelfPlayer():getName()
  myGuildName = myGuildInfo:getName()
  self._ui._stc_from:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_AGREEMENT_VOLUNTEER_EMPLOYER_GUILD", "employer", myName, "employerGuild", "(" .. myGuildName .. ")"))
  self._ui._stc_to:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_AGREEMENT_VOLUNTEER_VOLUNTEER_PLAYER", "employee", volunteerName, "employeeGuild", ""))
  self._volunteerName = volunteerName
  local isSet = setGuildTextureByGuildNo(myGuildInfo:getGuildNo_s64(), self._ui._stc_guildIcon)
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
function FGlobal_AgreementVolunteer_Master_Close()
  local self = AgreementVolunteer_Master
  self:close()
end
function FGlobal_AgreementVolunteer_Master_Hire()
  if nil == Panel_AgreementVolunteer_Master then
    return
  end
  local self = AgreementVolunteer_Master
  if nil == self._volunteerName or 0 == self._payment or nil == self._payment or 0 == self._bonus or nil == self._bonus then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENT_VOLUNTEER_CONTRACT_RECHECK_PLEASE"))
  else
    ToClient_RequestInviteGuildVolunteerMember(self._volunteerName, self._payment, self._bonus)
    FGlobal_AgreementVolunteer_Master_Close()
  end
end
function FGlobal_AgreementVolunteer_Master_Edit_Payment()
  if nil == Panel_AgreementVolunteer_Master then
    return
  end
  local self = AgreementVolunteer_Master
  if nil == self._max_payment or 0 == Int64toInt32(self._max_payment) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENT_VOLUNTEER_CONTRACT_RECHECK_NOCASH"))
  else
    Panel_NumberPad_Show(true, self._max_payment, 0, FGlobal_AgreementVolunteer_Master_Payment_ValueConfirm)
  end
end
function FGlobal_AgreementVolunteer_Master_Edit_Bonus()
  if nil == Panel_AgreementVolunteer_Master then
    return
  end
  local self = AgreementVolunteer_Master
  if nil == self._max_successPay or 0 == Int64toInt32(self._max_successPay) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENT_VOLUNTEER_CONTRACT_RECHECK_NOCASH"))
  else
    Panel_NumberPad_Show(true, self._max_successPay, 0, FGlboal_AgreementVolunteer_Master_Bonus_ValueConfirm)
  end
end
function FGlobal_AgreementVolunteer_Master_Payment_ValueConfirm(value)
  if nil == Panel_AgreementVolunteer_Master then
    return
  end
  local self = AgreementVolunteer_Master
  self._payment = value
  self._ui._edit_payment:SetEditText(makeDotMoney(value))
end
function FGlboal_AgreementVolunteer_Master_Bonus_ValueConfirm(value)
  if nil == Panel_AgreementVolunteer_Master then
    return
  end
  local self = AgreementVolunteer_Master
  self._bonus = value
  self._ui._edit_bonus:SetEditText(makeDotMoney(value))
end
function FromClient_AgreementVolunteer_resultInviteGuildVolunteerMember(isAgree, guild, volunteer, payment, bonus)
  if false == isAgree then
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENT_VOLUNTEER_CONTRACT_NOTICE_REFUSE")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENT_VOLUNTEER_CONTRACT_NOTICE_TITLE"),
      content = messageBoxMemo,
      functionYes = MessageBox_Empty_function,
      functionNo = nil,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
  else
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENT_VOLUNTEER_CONTRACT_NOTICE_CONFIRM")
    local messageBoxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_AGREEMENT_VOLUNTEER_CONTRACT_NOTICE_TITLE"),
      content = messageBoxMemo,
      functionYes = MessageBox_Empty_function,
      functionNo = nil,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData)
    PaGlobal_CheckVolunteerList()
  end
end
function PaGlobal_AgreementVolunteerMaster_CheckLoadUI()
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_AgreementVolunteer_Master:SetShow(true)
    return
  end
  local rv = reqLoadUI("UI_Data/Window/Guild/Panel_AgreementVolunteer_Master.XML", "Panel_AgreementVolunteer_Master", Defines.UIGroup.PAGameUIGroup_Window_Progress, PAUIRenderModeBitSet({
    Defines.RenderMode.eRenderMode_Default
  }))
  if nil ~= rv then
    Panel_AgreementVolunteer_Master = rv
    rv = nil
    PaGlobal_AgreementVolunteerMaster_Init()
  end
  Panel_AgreementVolunteer_Master:SetShow(true)
end
function PaGlobal_AgreementVolunteerMaster_CheckCloseUI()
  if false == PaGlobal_AgreementVolunteerMaster_GetShow() then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_AgreementVolunteer_Master:SetShow(false)
  else
    reqCloseUI(Panel_AgreementVolunteer_Master)
  end
end
function PaGlobal_AgreementVolunteerMaster_GetShow()
  if nil == Panel_AgreementVolunteer_Master then
    return false
  end
  return Panel_AgreementVolunteer_Master:GetShow()
end
function FromClient_luaLoadComplete_AgreementVolunteer_Master()
  PaGlobal_AgreementVolunteerMaster_Init()
  AgreementVolunteer_Master:registMessageHandler()
end
function PaGlobal_AgreementVolunteerMaster_Init()
  AgreementVolunteer_Master:init()
  AgreementVolunteer_Master:registEventHandler()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_AgreementVolunteer_Master")

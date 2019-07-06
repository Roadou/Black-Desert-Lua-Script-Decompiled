local _panel = Panel_Console_Dialog_GuildPopup
local GuildPopup = {
  _ui = {
    stc_Create_Guild = UI.getChildControl(_panel, "Static_Create_Guild")
  },
  _selectBtnIdx = {clan = 1, guild = 2},
  _keyguide = {},
  _currentBtn = nil,
  _panelOriginSizeY = 0,
  _mainOriginSizeY = 0
}
function GuildPopup:init()
  self._ui.txt_Title = UI.getChildControl(self._ui.stc_Create_Guild, "StaticText_Title")
  self._ui.stc_Main = UI.getChildControl(self._ui.stc_Create_Guild, "Static_Main")
  self._ui.txt_SubTitle = UI.getChildControl(self._ui.stc_Main, "StaticText_Sub_Title")
  self._ui.btn_ClanMark = UI.getChildControl(self._ui.stc_Main, "RadioButton_Clan_Mark")
  self._ui.btn_GuildMark = UI.getChildControl(self._ui.stc_Main, "RadioButton_Guild_Mark")
  self._ui.txt_Tip = UI.getChildControl(self._ui.stc_Main, "StaticText_Tip")
  self._ui.txt_Tip:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_Tip:SetText(" ")
  self._ui.stc_BottomBg = UI.getChildControl(self._ui.stc_Create_Guild, "Static_BottomBg")
  self._ui.txt_Apply = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_Apply")
  self._ui.txt_Exit = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_Exit")
  self._ui.txt_SubTitle:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_SubTitle:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CREATECLAN_1"))
  self._ui.btn_ClanMark:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CREATECLAN_GUIDETITLE_CLAN"))
  self._ui.btn_GuildMark:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CREATECLAN_GUIDETITLE_GUILD"))
  self._panelOriginSizeY = _panel:GetSizeY()
  self._mainOriginSizeY = self._ui.stc_Main:GetSizeY()
  self._keyguide = {
    self._ui.txt_Apply,
    self._ui.txt_Exit
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyguide, self._ui.stc_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, nil, 10)
  self:registEventHandler()
end
function GuildPopup:open()
  self:update()
  Panel_Console_Dialog_GuildPopup:SetShow(true)
end
function GuildPopup:close()
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  Panel_Console_Dialog_GuildPopup:SetShow(false)
  ClearFocusEdit()
end
function GuildPopup:update()
  self._ui.btn_ClanMark:SetMonoTone(false)
  self._ui.btn_ClanMark:SetIgnore(false)
  self._ui.btn_ClanMark:SetAlpha(1)
  self._ui.btn_GuildMark:SetMonoTone(false)
  self._ui.btn_GuildMark:SetIgnore(false)
  self._ui.btn_GuildMark:SetAlpha(1)
  self._ui.txt_Apply:SetShow(false)
  if false == ToClient_CanMakeGuild() then
    self._ui.btn_GuildMark:SetMonoTone(true)
    self._ui.btn_GuildMark:SetIgnore(true)
    self._ui.btn_GuildMark:SetAlpha(0.6)
  end
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil ~= myGuildListInfo then
    local guildGrade = myGuildListInfo:getGuildGrade()
    local isGuildMaster = getSelfPlayer():get():isGuildMaster()
    if 0 == guildGrade then
      self._ui.btn_ClanMark:SetMonoTone(true)
      self._ui.btn_ClanMark:SetIgnore(true)
      self._ui.btn_ClanMark:SetAlpha(0.6)
      self._ui.btn_GuildMark:SetMonoTone(true)
      self._ui.btn_GuildMark:SetIgnore(true)
      self._ui.btn_GuildMark:SetAlpha(0.6)
      if true == isGuildMaster then
        self._ui.btn_GuildMark:SetMonoTone(false)
        self._ui.btn_GuildMark:SetIgnore(false)
        self._ui.btn_GuildMark:SetAlpha(1)
        self._ui.txt_Apply:SetShow(true)
      end
    elseif 1 == guildGrade then
      self._ui.btn_ClanMark:SetMonoTone(true)
      self._ui.btn_ClanMark:SetIgnore(true)
      self._ui.btn_ClanMark:SetAlpha(0.6)
      self._ui.btn_GuildMark:SetMonoTone(true)
      self._ui.btn_GuildMark:SetIgnore(true)
      self._ui.btn_GuildMark:SetAlpha(0.6)
    end
  else
    self._ui.txt_Apply:SetShow(true)
  end
  self._currentBtn = nil
  self._ui.txt_Tip:SetText("")
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyguide, self._ui.stc_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, nil, 10)
end
function GuildPopup:registEventHandler()
  self._ui.btn_ClanMark:addInputEvent("Mouse_LUp", "InputMLUp_GuildPopup_SelectBtn(" .. self._selectBtnIdx.clan .. ")")
  self._ui.btn_ClanMark:addInputEvent("Mouse_On", "InputMO_GuildPopup_SetKeyguide(" .. self._selectBtnIdx.clan .. ")")
  self._ui.btn_GuildMark:addInputEvent("Mouse_LUp", "InputMLUp_GuildPopup_SelectBtn(" .. self._selectBtnIdx.guild .. ")")
  self._ui.btn_GuildMark:addInputEvent("Mouse_On", "InputMO_GuildPopup_SetKeyguide(" .. self._selectBtnIdx.guild .. ")")
  self._ui.txt_Apply:addInputEvent("Mouse_LUp", "InputMLUp_GuildPopup_Confirm()")
end
function PaGlobalFunc_GuildPopup_Open()
  self = GuildPopup
  self:open()
end
function PaGlobalFunc_GuildPopup_Close()
  self = GuildPopup
  self:close()
end
function InputMLUp_GuildPopup_SelectBtn(btnIdx)
  self = GuildPopup
  self._currentBtn = btnIdx
  InputMLUp_GuildPopup_Confirm()
end
function InputMO_GuildPopup_SetKeyguide(btnIdx)
  self = GuildPopup
  self._ui.btn_ClanMark:SetAlpha(1)
  self._ui.btn_GuildMark:SetAlpha(1)
  if btnIdx == self._selectBtnIdx.clan then
    self._ui.btn_GuildMark:SetMonoTone(true)
    self._ui.btn_ClanMark:SetMonoTone(false)
    self._ui.btn_GuildMark:SetAlpha(0.6)
    self._ui.txt_Tip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CREATECLAN_GUIDEDESC_CLAN"))
  elseif btnIdx == self._selectBtnIdx.guild then
    self._ui.btn_GuildMark:SetMonoTone(false)
    self._ui.btn_ClanMark:SetMonoTone(true)
    self._ui.btn_ClanMark:SetAlpha(0.6)
    self._ui.txt_Tip:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CREATECLAN_GUIDEDESC_GUILD"))
  end
  local diffY = self._ui.txt_Tip:GetTextSizeY() - self._ui.txt_Tip:GetSizeY()
  self._ui.stc_Main:SetSize(self._ui.stc_Main:GetSizeX(), self._mainOriginSizeY + diffY)
  self._ui.stc_Create_Guild:SetSize(self._ui.stc_Create_Guild:GetSizeX(), self._panelOriginSizeY + diffY)
  _panel:SetSize(_panel:GetSizeX(), self._panelOriginSizeY + diffY)
  _panel:ComputePos()
  self._ui.stc_BottomBg:ComputePos()
end
function InputMLUp_GuildPopup_Confirm()
  self = GuildPopup
  if self._currentBtn == self._selectBtnIdx.clan then
    PaGlobalFunc_GuildCreate_Open(0)
  elseif self._currentBtn == self._selectBtnIdx.guild then
    local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
    if nil ~= myGuildListInfo then
      local myGuildGrade = myGuildListInfo:getGuildGrade()
      local isGuildMaster = getSelfPlayer():get():isGuildMaster()
      if 1 == myGuildGrade then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_POPUP_CURRENT_ACK"))
        return
      end
      if true == isGuildMaster and 0 == myGuildGrade then
        ToClient_RequestRaisingGuildGrade(1, 100000)
      elseif false == isGuildMaster then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_POPUP_ONLYGUILDMASTER_ACK"))
        return
      end
    else
      if 1 > getSelfPlayer():get():getLevel() then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_POPUP_NOLEVEL_ACK"))
        return
      end
      PaGlobalFunc_GuildCreate_Open(1)
    end
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_POPUP_CLANORGUILD_SELECT_ACK"))
  end
  self:close()
end
function FromClient_luaLoadComplete_GuildPopup_Init()
  self = GuildPopup
  self:init()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_GuildPopup_Init")

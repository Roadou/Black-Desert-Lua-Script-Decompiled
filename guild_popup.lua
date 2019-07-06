local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local IM = CppEnums.EProcessorInputMode
local ePanelType = {
  createGuild = 0,
  createClan = 1,
  clanToGuild = 2
}
local CreateClan = {
  selectedClan = nil,
  selectedGuild = nil,
  create = nil,
  createConsole = nil,
  guideMainBaseBG = nil,
  guideMainBG = nil,
  help = nil,
  close = nil
}
local ClanToGuild = {
  convert = nil,
  help = nil,
  close = nil
}
local GuildCreateManager = {
  _createGuildBG = nil,
  _buttonApply = nil,
  _buttonCancel = nil,
  _editGuildNameInput = nil,
  _txt_NameDesc = nil,
  _staticCreateServantNameBG = nil
}
function GuildCreateManager:initialize()
  if nil == Panel_CreateGuild then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_CreateGuild:SetShow(false)
  end
  self._createGuildBG = UI.getChildControl(Panel_CreateGuild, "Static_BG")
  self._buttonApply = UI.getChildControl(Panel_CreateGuild, "Button_Confirm")
  self._buttonCancel = UI.getChildControl(Panel_CreateGuild, "Button_Cancel")
  self._editGuildNameInput = UI.getChildControl(Panel_CreateGuild, "Edit_GuildName")
  self._txt_NameDesc = UI.getChildControl(Panel_CreateGuild, "StaticText_NameDesc")
  self._staticCreateServantNameBG = UI.getChildControl(Panel_CreateGuild, "Static_NamingPolicyBG")
  self._staticCreateServantNameTitle = UI.getChildControl(self._staticCreateServantNameBG, "StaticText_NamingPolicyTitle")
  self._staticCreateServantName = UI.getChildControl(self._staticCreateServantNameBG, "StaticText_NamingPolicy")
  self.createNamePolicyTitle = UI.getChildControl(self._staticCreateServantNameBG, "StaticText_NamingPolicyTitle")
  self.createNamePolicyDesc = UI.getChildControl(self._staticCreateServantNameBG, "StaticText_NamingPolicy")
  if ToClient_IsDevelopment() or isGameTypeEnglish() or isGameTypeTaiwan() or isGameTypeTR() or isGameTypeTH() or isGameTypeID() then
    GuildCreateManager.createNamePolicyDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
    GuildCreateManager._staticCreateServantNameBG:SetShow(true)
  else
    GuildCreateManager._staticCreateServantNameBG:SetShow(false)
  end
  if isGameTypeEnglish() or isGameTypeTaiwan() then
    GuildCreateManager.createNamePolicyDesc:SetText(PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_EN"))
  elseif isGameTypeTR() then
    GuildCreateManager.createNamePolicyDesc:SetText(PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_TR"))
  elseif isGameTypeTH() then
    GuildCreateManager.createNamePolicyDesc:SetText(PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_TH"))
  elseif isGameTypeID() then
    GuildCreateManager.createNamePolicyDesc:SetText(PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_ID"))
  else
    GuildCreateManager.createNamePolicyDesc:SetText(PAGetString(Defines.StringSheet_GAME, "COMMON_CHARACTERCREATEPOLICY_EN"))
  end
end
function GuildCreateManager:registEventHandler()
  if nil == Panel_CreateGuild then
    return
  end
  GuildCreateManager._buttonApply:addInputEvent("Mouse_LUp", "handleClicked_GuildCreateApply()")
  GuildCreateManager._buttonCancel:addInputEvent("Mouse_LUp", "handleClicked_GuildCreateCancel()")
  GuildCreateManager._editGuildNameInput:RegistReturnKeyEvent("handleClicked_GuildCreateApply()")
end
function CreateClan:initialize()
  if nil == Panel_CreateClan then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_CreateClan:SetShow(false, false)
  end
  Panel_CreateClan:setGlassBackground(true)
  self.selectedClan = UI.getChildControl(Panel_CreateClan, "RadioButton_Clan")
  self.selectedGuild = UI.getChildControl(Panel_CreateClan, "RadioButton_Guild")
  self.create = UI.getChildControl(Panel_CreateClan, "Button_Confirm")
  self.createConsole = UI.getChildControl(Panel_CreateClan, "StaticText_Create_ConsoleUI")
  self.guideMainBaseBG = UI.getChildControl(Panel_CreateClan, "Static_TopBG")
  self.guideMainBG = UI.getChildControl(Panel_CreateClan, "StaticText_SelectedTypeDescBG")
  self.help = UI.getChildControl(Panel_CreateClan, "Button_Question")
  self.close = UI.getChildControl(Panel_CreateClan, "Button_Win_Close")
  self.createConsole:SetShow(false)
  self.guideMainBG:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.guideMainBG:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CREATECLAN_GUIDEDESC_CLAN"))
  self.guideMainBG:ComputePos()
  if _ContentsGroup_isConsolePadControl then
    self.selectedGuild:addInputEvent("Mouse_On", "selectclaned2()")
    self.guideMainBG:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CREATECLAN_GUIDEDESC_GUILD"))
    self.guideMainBG:ComputePos()
    self.createConsole:SetShow(true)
  end
  CreateClan.createDescBG = UI.getChildControl(CreateClan.guideMainBaseBG, "MultilineText_CreateClanDesc")
  CreateClan.selectedClan:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CREATECLAN_GUIDETITLE_CLAN"))
  CreateClan.selectedGuild:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CREATECLAN_GUIDETITLE_GUILD"))
  CreateClan.guideMainBG:ComputePos()
  FromClient_CreateGuild_onScreenResize()
  PaGlobal_SeasonTexture_SetPanel(Panel_CreateClan)
end
function ClanToGuild:initialize()
  if nil == Panel_ClanToGuild then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_ClanToGuild:SetShow(false, false)
  end
  Panel_ClanToGuild:setGlassBackground(true)
  ClanToGuild.convert = UI.getChildControl(Panel_ClanToGuild, "Button_Convert")
  ClanToGuild.help = UI.getChildControl(Panel_ClanToGuild, "Button_Question")
  ClanToGuild.close = UI.getChildControl(Panel_ClanToGuild, "Button_Win_Close")
end
function FGlobal_CehckedGuildEditUI(uiEdit)
  if nil == Panel_CreateGuild then
    return
  end
  if nil == uiEdit then
    return false
  end
  return uiEdit:GetKey() == GuildCreateManager._editGuildNameInput:GetKey()
end
function handleClickedShowGuildCreateComment()
  if nil == Panel_CreateGuild then
    return
  end
  local luaGuildTextGuildCreateMsg = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILD_CREATE_MSG")
  if GuildCreateManager._buttonCreateGuild:IsChecked() then
    GuildCreateManager._textCommentTitle:SetText(GuildCreateManager._titleGuild)
    GuildCreateManager._textComment:SetTextMode(UI_TM.eTextMode_AutoWrap)
    GuildCreateManager._textComment:SetText(GuildCreateManager._commentGuild)
    GuildCreateManager._textBottomText:SetText(luaGuildTextGuildCreateMsg)
  end
end
function Guild_PopupCreate(guildGrade)
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  local playerLevel = getSelfPlayer():get():getLevel()
  if nil ~= myGuildListInfo then
    local myGuildGrade = myGuildListInfo:getGuildGrade()
    local isGuildMaster = getSelfPlayer():get():isGuildMaster()
    if 0 == guildGrade then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_POPUP_ALREADYCLAN_ACK"))
      return
    elseif 1 == guildGrade then
      if 0 ~= myGuildGrade then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_POPUP_CURRENT_ACK"))
        return
      end
      if not isGuildMaster then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_POPUP_ONLYGUILDMASTER_ACK"))
        return
      end
      if isGuildMaster and 0 == myGuildGrade then
        local myGuildName = myGuildListInfo:getName()
        ToClient_RequestRaisingGuildGrade(1, 100000)
      end
    end
  elseif 0 == guildGrade then
    GuildCreateManager:showInputGuildName()
  elseif 1 == guildGrade then
    if playerLevel >= 1 then
      GuildCreateManager:showInputGuildName()
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_POPUP_NOLEVEL_ACK"))
      return
    end
  end
end
function GuildCreateManager:showInputGuildName()
  PaGlobal_GuildPopup_CheckLoadUI(ePanelType.createGuild)
  GuildCreateManager._editGuildNameInput:SetEditText("", true)
  GuildCreateManager._editGuildNameInput:SetMaxInput(getGameServiceTypeGuildNameLength())
  if false == _ContentsGroup_isConsolePadControl then
    SetFocusEdit(GuildCreateManager._editGuildNameInput)
  end
  GuildCreateManager._editGuildNameInput:SetEnable(true)
  GuildCreateManager._editGuildNameInput:SetMonoTone(false)
  GuildCreateManager._txt_NameDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  local txt_NameDesc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_POPUP_1")
  if isGameTypeKorea() or isGameTypeTaiwan() or isGameTypeTH() or isGameTypeRussia() or isGameTypeID() or isGameTypeTR() then
    txt_NameDesc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_POPUP_1") .. [[


<PAColor0xFFF26A6A>]] .. PAGetString(Defines.StringSheet_GAME, "LUA_MAKENAME_WARNING") .. "<PAOldColor>"
  else
    txt_NameDesc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_POPUP_1")
  end
  GuildCreateManager._txt_NameDesc:SetText(txt_NameDesc)
  GuildCreateManager._createGuildBG:SetSize(GuildCreateManager._createGuildBG:GetSizeX(), GuildCreateManager._txt_NameDesc:GetTextSizeY() + GuildCreateManager._editGuildNameInput:GetSizeY() + 40)
  Panel_CreateGuild:SetSize(Panel_CreateGuild:GetSizeX(), GuildCreateManager._txt_NameDesc:GetTextSizeY() + GuildCreateManager._editGuildNameInput:GetSizeY() + 140)
  GuildCreateManager._buttonApply:SetSpanSize(GuildCreateManager._buttonApply:GetSpanSize().x, 10)
  GuildCreateManager._buttonCancel:SetSpanSize(GuildCreateManager._buttonCancel:GetSpanSize().x, 10)
  GuildCreateManager._buttonApply:SetText(PAGetString(Defines.StringSheet_RESOURCE, "EXCHANGE_NUMBER_BTN_APPLY"))
  GuildCreateManager._buttonCancel:SetText(PAGetString(Defines.StringSheet_RESOURCE, "EXCHANGE_NUMBER_BTN_CANCEL"))
  if _ContentsGroup_isConsolePadControl then
    GuildCreateManager._buttonApply:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_APPLY_WITHOUT_KEY"))
    GuildCreateManager._buttonCancel:SetText(PAGetString(Defines.StringSheet_RESOURCE, "MESSAGEBOX_BTN_CANCEL_WITHOUT_KEY"))
  end
  GuildCreateManager._staticCreateServantNameBG:ComputePos()
end
function handleClicked_GuildCreateApply()
  if nil == Panel_CreateGuild then
    return
  end
  if GuildCreateManager._editGuildNameInput:GetEditText() == "" then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_POPUP_ENTER_GUILDNAME"))
    ClearFocusEdit()
    return
  end
  local self = CreateClan
  local isRaisingGuildGrade = false
  local guildGrade = 0
  local guildName = GuildCreateManager._editGuildNameInput:GetEditText()
  local businessFunds = 100000
  if self.selectedClan:IsCheck() then
    guildGrade = 0
  elseif self.selectedGuild:IsCheck() then
    guildGrade = 1
    local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
    if nil ~= myGuildListInfo then
      local myGuildGrade = myGuildListInfo:getGuildGrade()
      if 0 ~= myGuildGrade then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_POPUP_NOGUILD_NOUPGRADE_ACK"))
        ClearFocusEdit()
        return
      end
      isRaisingGuildGrade = true
    end
  end
  if false == isRaisingGuildGrade then
    ToClient_RequestCreateGuild(guildName, guildGrade, businessFunds)
  else
    ToClient_RequestRaisingGuildGrade(guildGrade, businessFunds)
  end
  PaGlobal_GuildPopup_CheckCloseUI(ePanelType.createGuild)
  ClearFocusEdit()
  CreateClan_Close()
end
function handleClicked_GuildCreateCancel()
  CreateClan_Close()
end
function FGlobal_GuildCreateManagerPopup()
  CreateClan_Open()
end
function CreateClan_PressCreate()
  if nil == Panel_CreateClan then
    return
  end
  local self = CreateClan
  if self.selectedClan:IsCheck() then
    Guild_PopupCreate(0)
  elseif self.selectedGuild:IsCheck() then
    if getSelfPlayer():get():getLevel() < 1 then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_POPUP_NOLEVEL_ACK"))
      return
    end
    if false == _ContentsGroup_RenewUI_Guild then
      Guild_PopupCreate(1)
    else
      PaGlobalFunc_GuildCreate_Open(1)
    end
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_POPUP_CLANORGUILD_SELECT_ACK"))
  end
end
function CreateClan_SelectGroupType()
  if nil == Panel_CreateClan then
    return
  end
  local self = CreateClan
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  local title, desc
  if self.selectedClan:IsCheck() then
    title = PAGetString(Defines.StringSheet_GAME, "LUA_CREATECLAN_GUIDETITLE_CLAN")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CREATECLAN_GUIDEDESC_CLAN")
  elseif self.selectedGuild:IsCheck() then
    title = PAGetString(Defines.StringSheet_GAME, "LUA_CREATECLAN_GUIDETITLE_GUILD")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CREATECLAN_GUIDEDESC_GUILD")
  end
  self.guideMainBG:SetText(desc)
  self.guideMainBaseBG:SetSize(self.guideMainBaseBG:GetSizeX(), self.createDescBG:GetTextSizeY() + 100)
  self.guideMainBG:SetSize(self.guideMainBG:GetSizeX(), self.guideMainBG:GetTextSizeY() + 10)
  Panel_CreateClan:SetSize(Panel_CreateClan:GetSizeX(), self.guideMainBaseBG:GetSizeY() + self.guideMainBG:GetTextSizeY() + self.selectedClan:GetSizeY() + 150)
  self.guideMainBG:ComputePos()
  self.create:ComputePos()
end
function CreateClan_Open()
  PaGlobal_GuildPopup_CheckLoadUI(ePanelType.createClan)
  local self = CreateClan
  self.selectedClan:SetCheck(true)
  self.selectedGuild:SetCheck(false)
  self.create:SetMonoTone(false)
  self.selectedClan:SetMonoTone(false)
  self.selectedGuild:SetMonoTone(false)
  self.create:SetEnable(true)
  self.selectedClan:SetEnable(true)
  self.selectedGuild:SetEnable(true)
  if false == ToClient_CanMakeGuild() then
    CreateClan.selectedGuild:SetEnable(false)
    CreateClan.selectedGuild:SetMonoTone(true)
  end
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil ~= myGuildListInfo then
    local guildGrade = myGuildListInfo:getGuildGrade()
    local isGuildMaster = getSelfPlayer():get():isGuildMaster()
    if 0 ~= guildGrade then
      self.selectedClan:SetMonoTone(true)
      self.selectedClan:SetEnable(false)
      self.selectedGuild:SetMonoTone(true)
      self.selectedGuild:SetEnable(false)
      self.create:SetMonoTone(true)
      self.create:SetEnable(false)
    elseif isGuildMaster then
      self.selectedClan:SetCheck(false)
      self.selectedClan:SetMonoTone(true)
      self.selectedClan:SetEnable(false)
      self.selectedGuild:SetCheck(true)
      self.selectedGuild:SetMonoTone(false)
      self.selectedGuild:SetEnable(true)
    else
      self.selectedClan:SetCheck(true)
      self.selectedClan:SetMonoTone(false)
      self.selectedClan:SetEnable(true)
      self.selectedGuild:SetCheck(false)
      self.selectedGuild:SetMonoTone(false)
      self.selectedGuild:SetEnable(true)
    end
  end
  if true == _ContentsGroup_RenewUI then
    self.selectedClan:SetCheck(false)
    self.selectedClan:SetMonoTone(true)
    self.selectedClan:SetEnable(false)
    self.selectedGuild:SetCheck(true)
    self.selectedGuild:SetMonoTone(false)
    self.selectedGuild:SetEnable(true)
  end
  local title = ""
  local desc = ""
  if self.selectedClan:IsCheck() then
    title = PAGetString(Defines.StringSheet_GAME, "LUA_CREATECLAN_GUIDETITLE_CLAN")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CREATECLAN_GUIDEDESC_CLAN")
  else
    title = PAGetString(Defines.StringSheet_GAME, "LUA_CREATECLAN_GUIDETITLE_GUILD")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_CREATECLAN_GUIDEDESC_GUILD")
  end
  self.guideMainBG:SetText(desc)
  self.guideMainBaseBG:SetSize(self.guideMainBaseBG:GetSizeX(), self.createDescBG:GetTextSizeY() + 100)
  self.guideMainBG:SetSize(self.guideMainBG:GetSizeX(), self.guideMainBG:GetTextSizeY() + 10)
  Panel_CreateClan:SetSize(Panel_CreateClan:GetSizeX(), self.guideMainBaseBG:GetSizeY() + self.guideMainBG:GetTextSizeY() + self.selectedClan:GetSizeY() + 150)
  self.guideMainBG:ComputePos()
  self.create:ComputePos()
  if _ContentsGroup_isConsolePadControl then
    selectclaned2()
    self.create:ComputePos()
  end
end
function CreateClan_Close()
  PaGlobal_GuildPopup_CheckCloseUI(ePanelType.createGuild)
  PaGlobal_GuildPopup_CheckCloseUI(ePanelType.createClan)
  ClearFocusEdit()
end
function CreateClan:registEventHandler()
  if nil == Panel_CreateClan then
    return
  end
  if false == _ContentsGroup_RenewUI then
    self.selectedClan:addInputEvent("Mouse_LUp", "CreateClan_SelectGroupType()")
  end
  self.selectedGuild:addInputEvent("Mouse_LUp", "CreateClan_SelectGroupType()")
  self.create:addInputEvent("Mouse_LUp", "CreateClan_PressCreate()")
  self.close:addInputEvent("Mouse_LUp", "CreateClan_Close()")
  self.help:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelClan\" )")
  self.help:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelClan\", \"true\")")
  self.help:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelClan\", \"false\")")
  if _ContentsGroup_isConsolePadControl then
    self.selectedGuild:addInputEvent("Mouse_LUp", "CreateClan_PressCreate()")
    self.guideMainBG:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_CREATECLAN_GUIDEDESC_GUILD"))
    self.guideMainBG:ComputePos()
  end
end
function selectclaned()
  if nil == Panel_CreateClan then
    return
  end
  local self = CreateClan
  self.selectedClan:SetCheck(true)
  self.selectedGuild:SetCheck(false)
  CreateClan_SelectGroupType()
end
function selectclaned2()
  if nil == Panel_CreateClan then
    return
  end
  local self = CreateClan
  self.selectedGuild:SetCheck(true)
  self.selectedClan:SetCheck(false)
  CreateClan_SelectGroupType()
end
function CreateClan:registMessageHandler()
  registerEvent("onScreenResize", "FromClient_CreateGuild_onScreenResize")
end
function GuildTotClan_Convert()
end
function HandleClicked_GuildTotClanClose()
  PaGlobal_GuildPopup_CheckCloseUI(ePanelType.clanToGuild, false)
end
function FGlobal_GuildTotClanOpen()
  PaGlobal_GuildPopup_CheckLoadUI(ePanelType.clanToGuild, true)
end
function FGlobal_GuildTotClanClose()
  PaGlobal_GuildPopup_CheckCloseUI(ePanelType.clanToGuild, false)
end
function ClanToGuild:registEventHandler()
  if nil == Panel_ClanToGuild then
    return
  end
  self.convert:addInputEvent("Mouse_LUp", "GuildTotClan_Convert()")
  self.help:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelClan\" )")
  self.help:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelClan\", \"true\")")
  self.help:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelClan\", \"false\")")
  self.close:addInputEvent("Mouse_LUp", "HandleClicked_GuildTotClanClose()")
end
function ClanToGuild:registMessageHandler()
end
function Guild_CreateGuild()
  local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildListInfo then
    return
  end
  local myGuildGrade = myGuildListInfo:getGuildGrade()
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  if isGuildMaster and 0 == myGuildGrade then
    local strTemp1 = PAGetString(Defines.StringSheet_GAME, "LUA_CREATE_GUILD_MESSAGEBOX_TITLE")
    local strTemp2 = PAGetString(Defines.StringSheet_GAME, "LUA_CREATE_GUILD_MESSAGEBOX_MESSAGE")
    local messageboxData = {
      title = strTemp1,
      content = strTemp2,
      functionYes = Guild_CreateGuild_ConfirmFromMessageBox,
      functionCancel = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  elseif not isGuildMaster then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_POPUP_ALREADY_JOIN_CLAN_OR_GUILD"))
    return
  elseif 1 == myGuildGrade then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_POPUP_NOMORE_UPGRADE"))
    return
  end
end
function Guild_CreateGuild_ConfirmFromMessageBox()
  local guildGrade = 1
  local businessFunds = 300000
  ToClient_RequestRaisingGuildGrade(guildGrade, businessFunds)
  PaGlobal_GuildPopup_CheckCloseUI(ePanelType.createGuild)
  CreateClan_Close()
end
function FromClient_CreateGuild_onScreenResize()
  if nil == Panel_CreateClan then
    return
  end
  local createClanPosY
  local dialogSizeY = 0
  if false == _ContentsGroup_NewUI_Dialog_All then
    dialogSizeY = Panel_Npc_Dialog:GetSizeY()
  else
    dialogSizeY = Panel_Npc_Dialog_All:GetSizeY()
  end
  if true == _ContentsGroup_RenewUI_Dailog then
    createClanPosY = (getScreenSizeY() - PaGlobalFunc_MainDialog_Bottom_GetSizeY()) / 2 - Panel_CreateClan:GetSizeY() / 2
  else
    createClanPosY = (getScreenSizeY() - dialogSizeY) / 2 - Panel_CreateClan:GetSizeY() / 2
  end
  if createClanPosY < -10 then
    createClanPosY = 0
  end
  Panel_CreateClan:SetPosY(createClanPosY)
end
function PaGlobal_GuildPopup_CheckLoadUI(_panelType, isAni)
  if false == _ContentsGroup_PanelReload_Develop then
    if ePanelType.createGuild == _panelType then
      Panel_CreateGuild:SetShow(true, isAni)
    elseif ePanelType.createClan == _panelType then
      Panel_CreateClan:SetShow(true, isAni)
    elseif ePanelType.clanToGuild == _panelType then
      Panel_ClanToGuild:SetShow(true, isAni)
    end
    return
  end
  local rv
  if ePanelType.createGuild == _panelType then
    rv = reqLoadUI("UI_Data/Window/Guild/Panel_Guild_Create.XML", "Panel_CreateGuild", Defines.UIGroup.PAGameUIGroup_Window_Progress, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_Dialog
    }))
  elseif ePanelType.createClan == _panelType then
    rv = reqLoadUI("UI_Data/Window/Guild/Panel_CreateClan.XML", "Panel_CreateClan", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_Dialog
    }))
  elseif ePanelType.clanToGuild == _panelType then
    rv = reqLoadUI("UI_Data/Window/Guild/Panel_ClanToGuild.XML", "Panel_ClanToGuild", Defines.UIGroup.PAGameUIGroup_Windows, PAUIRenderModeBitSet({
      Defines.RenderMode.eRenderMode_Default
    }))
  end
  if nil ~= rv then
    if ePanelType.createGuild == _panelType then
      Panel_CreateGuild = rv
      PaGlobal_GuildPopup_CreateGuildInit()
    elseif ePanelType.createClan == _panelType then
      Panel_CreateClan = rv
      PaGlobal_GuildPopup_CreateClanInit()
    elseif ePanelType.clanToGuild == _panelType then
      Panel_ClanToGuild = rv
      PaGlobal_GuildPopup_ClanToGuildInit()
    end
    rv = nil
  end
  if ePanelType.createGuild == _panelType then
    Panel_CreateGuild:SetShow(true, isAni)
  elseif ePanelType.createClan == _panelType then
    Panel_CreateClan:SetShow(true, isAni)
  elseif ePanelType.clanToGuild == _panelType then
    Panel_ClanToGuild:SetShow(true, isAni)
  end
end
function PaGlobal_GuildPopup_CheckCloseUI(_panelType, isAni)
  if false == PaGlobal_GuildPopup_GetShow(_panelType) then
    return
  end
  if ePanelType.createGuild == _panelType then
    if false == _ContentsGroup_PanelReload_Develop then
      Panel_CreateGuild:SetShow(false, isAni)
    else
      reqCloseUI(Panel_CreateGuild)
    end
  elseif ePanelType.createClan == _panelType then
    if false == _ContentsGroup_PanelReload_Develop then
      Panel_CreateClan:SetShow(false, isAni)
    else
      reqCloseUI(Panel_CreateClan)
    end
  elseif ePanelType.clanToGuild == _panelType then
    if false == _ContentsGroup_PanelReload_Develop then
      Panel_ClanToGuild:SetShow(false, isAni)
    else
      reqCloseUI(Panel_ClanToGuild)
    end
  end
end
function PaGlobal_GuildPopup_GetShow(_panelType)
  if ePanelType.createGuild == _panelType then
    if nil == Panel_CreateGuild then
      return false
    end
    return Panel_CreateGuild:GetShow()
  elseif ePanelType.createClan == _panelType then
    if nil == Panel_CreateClan then
      return false
    end
    return Panel_CreateClan:GetShow()
  elseif ePanelType.clanToGuild == _panelType then
    if nil == Panel_ClanToGuild then
      return false
    end
    return Panel_ClanToGuild:GetShow()
  end
  return false
end
function FromClient_GuildPopup_Init()
  PaGlobal_GuildPopup_CreateGuildInit()
  PaGlobal_GuildPopup_CreateClanInit()
  PaGlobal_GuildPopup_ClanToGuildInit()
  CreateClan:registMessageHandler()
  ClanToGuild:registMessageHandler()
end
function PaGlobal_GuildPopup_CreateGuildInit()
  GuildCreateManager:initialize()
  GuildCreateManager:registEventHandler()
end
function PaGlobal_GuildPopup_CreateClanInit()
  CreateClan:initialize()
  CreateClan:registEventHandler()
end
function PaGlobal_GuildPopup_ClanToGuildInit()
  ClanToGuild:initialize()
  ClanToGuild:registEventHandler()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_GuildPopup_Init")

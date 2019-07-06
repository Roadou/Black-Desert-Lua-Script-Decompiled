local _panel = Panel_Window_Guild_VoiceSet
_panel:ignorePadSnapMoveToOtherPanel()
local GuildVoiceSet = {
  _ui = {
    txt_Title = UI.getChildControl(_panel, "StaticText_Title"),
    stc_CenterBg = UI.getChildControl(_panel, "Static_CenterBg"),
    stc_bottomBg = UI.getChildControl(_panel, "Static_BottomBg"),
    txt_keyGuideB = nil,
    txt_keyGuideA = nil,
    txt_keyGuideY = nil
  },
  _btnType = {mic = 0, listen = 1},
  _btnFlag = {},
  _currentMember = nil,
  _startBtnGapY = 0
}
function GuildVoiceSet:init()
  self._ui.txt_MicTitle = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_MicTitle")
  self._ui.txt_HearingTitle = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_HearingTitle")
  self._ui.check_Mic = UI.getChildControl(self._ui.stc_CenterBg, "CheckButton_Mic")
  self._ui.check_Hearing = UI.getChildControl(self._ui.stc_CenterBg, "CheckButton_Hearing")
  self._startBtnGapY = self._ui.txt_MicTitle:GetPosY()
  self._ui.txt_MicTitle:SetText(PAGetString(Defines.StringSheet_GAME, "VOICECHAT_MIC_PERMISSION_TITLE"))
  self._ui.txt_HearingTitle:SetText(PAGetString(Defines.StringSheet_GAME, "VOICECHAT_MUTE_USER_TITLE"))
  self._ui.txt_keyGuideB = UI.getChildControl(self._ui.stc_bottomBg, "StaticText_B_ConsoleUI")
  self._ui.txt_keyGuideA = UI.getChildControl(self._ui.stc_bottomBg, "StaticText_A_ConsoleUI")
  self._ui.txt_keyGuideY = UI.getChildControl(self._ui.stc_bottomBg, "StaticText_Y_ConsoleUI")
  local tempBtnGroup = {
    self._ui.txt_keyGuideA,
    self._ui.txt_keyGuideY,
    self._ui.txt_keyGuideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(tempBtnGroup, self._ui.stc_bottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  PaGlobal_registerPanelOnBlackBackground(_panel)
  self:registEventHandler()
end
function GuildVoiceSet:open()
  local memberIdx = PaGlobalFunc_GuildMemberFunction_GetMemberIndex()
  local guildInfo = ToClient_GetMyGuildInfoWrapper()
  local guildMemberInfo = guildInfo:getMember(memberIdx)
  self._currentMember = guildMemberInfo
  if nil == self._currentMember then
    _PA_ASSERT(false, "GuildVoiceSet \236\157\152 _currentMember \234\176\128 nil \236\158\133\235\139\136\235\139\164!!")
    return
  end
  self:update()
  _panel:SetShow(true)
end
function GuildVoiceSet:update()
  self._ui.txt_MicTitle:SetShow(false)
  self._ui.txt_HearingTitle:SetShow(false)
  self._ui.check_Mic:SetShow(false)
  self._ui.check_Hearing:SetShow(false)
  local isSaying = self._currentMember:isVoicePermissionHas()
  local memberGrade = self._currentMember:getGrade()
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  local btnGapY = self._startBtnGapY
  local isUnMuteMember = false
  if 0 < self._currentMember:getVoiceVolume() then
    isUnMuteMember = true
  else
    isUnMuteMember = false
  end
  self._btnFlag[self._btnType.mic] = isSaying
  self._btnFlag[self._btnType.listen] = isUnMuteMember
  if isGuildMaster or isGuildSubMaster and 0 ~= memberGrade then
    self._ui.txt_MicTitle:SetShow(true)
    self._ui.check_Mic:SetShow(true)
    btnGapY = btnGapY + 100
  end
  if false == self._currentMember:isSelf() then
    self._ui.txt_HearingTitle:SetShow(true)
    self._ui.check_Hearing:SetShow(true)
    btnGapY = btnGapY + 100
  end
  self._ui.check_Mic:SetCheck(isSaying)
  self._ui.check_Hearing:SetCheck(isUnMuteMember)
  PaGlobalFunc_GuildVoiceSet_SetCheckText()
end
function GuildVoiceSet:close()
  _panel:SetShow(false)
end
function GuildVoiceSet:registEventHandler()
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_GuildVoiceSet_Confirm()")
  self._ui.check_Mic:registerPadEvent(__eConsoleUIPadEvent_Up_A, "InputMLUp_GuildVoiceSet_SetCheckToggle(" .. 0 .. ")")
  self._ui.check_Hearing:registerPadEvent(__eConsoleUIPadEvent_Up_A, "InputMLUp_GuildVoiceSet_SetCheckToggle(" .. 1 .. ")")
end
function PaGlobalFunc_GuildVoiceSet_Open()
  local self = GuildVoiceSet
  self:open()
end
function PaGlobalFunc_GuildVoiceSet_Close()
  local self = GuildVoiceSet
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  self:close()
end
function PaGlobalFunc_GuildVoiceSet_Confirm()
  local self = GuildVoiceSet
  local memberIdx = PaGlobalFunc_GuildMemberFunction_GetMemberIndex()
  local guildInfo = ToClient_GetMyGuildInfoWrapper()
  local guildMemberInfo = guildInfo:getMember(memberIdx)
  local targetMemberUserNo = guildMemberInfo:getUserNo()
  local targetMemberGrade = guildMemberInfo:getGrade()
  local targetMemberListen = guildMemberInfo:isVoiceChatListen()
  local myGuildInfo = guildInfo:getMemberByUserNo(getSelfPlayer():get():getUserNo())
  local myGuildGrade = guildMemberInfo:getGrade()
  local isSaying = self._btnFlag[self._btnType.mic]
  local isHearing = self._btnFlag[self._btnType.listen]
  local guildListIdx = PaGlobalFunc_GuildMemberFunction_GetMemberSortIndex()
  local isForce = false
  if targetMemberGrade > myGuildGrade then
    isForce = true
    ToClient_VoiceChatChangeState(CppEnums.VoiceChatType.eVoiceChatType_Guild, targetMemberUserNo, isSaying, targetMemberListen, isForce)
  end
  if true == isHearing then
    ToClient_VoiceChatChangeVolume(CppEnums.VoiceChatType.eVoiceChatType_Guild, targetMemberUserNo, 100)
  else
    ToClient_VoiceChatChangeVolume(CppEnums.VoiceChatType.eVoiceChatType_Guild, targetMemberUserNo, 0)
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  self:close()
end
function PaGlobalFunc_GuildVoiceSet_Init()
  local self = GuildVoiceSet
  self:init()
end
function InputMLUp_GuildVoiceSet_SetCheckToggle(btnType)
  local self = GuildVoiceSet
  if nil == self._btnFlag[btnType] then
    return
  end
  self._btnFlag[btnType] = not self._btnFlag[btnType]
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  PaGlobalFunc_GuildVoiceSet_SetCheckText()
end
function PaGlobalFunc_GuildVoiceSet_SetCheckText()
  local self = GuildVoiceSet
  if true == self._btnFlag[self._btnType.mic] then
    self._ui.check_Mic:SetText(PAGetString(Defines.StringSheet_GAME, "VOICECHAT_MIC_PERMISSION_ALLOW"))
  else
    self._ui.check_Mic:SetText(PAGetString(Defines.StringSheet_GAME, "VOICECHAT_MIC_PERMISSION_BLOCK"))
  end
  if true == self._btnFlag[self._btnType.listen] then
    self._ui.check_Hearing:SetText(PAGetString(Defines.StringSheet_GAME, "VOICECHAT_LISTEN_UNMUTE"))
  else
    self._ui.check_Hearing:SetText(PAGetString(Defines.StringSheet_GAME, "VOICECHAT_LISTEN_MUTE"))
  end
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_GuildVoiceSet_Init")

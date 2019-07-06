PaGlobal_GuildBattle_SelectAttend = {
  _ui = {
    _btn_WinClose = nil,
    _staticText_Title = nil,
    _static_TopBg = nil,
    _static_Bg = nil,
    _static_BottomBg = nil
  },
  _canSelectAttend = false
}
local EnableControl = function(target, isEnable)
  if true == isEnable then
    target:SetEnable(true)
    target:SetMonoTone(false)
    target:SetIgnore(false)
  else
    target:SetEnable(false)
    target:SetMonoTone(true)
    target:SetIgnore(true)
  end
end
local EnableText = function(targetText, isEnable)
  if true == isEnable then
    targetText:SetFontAlpha(1)
  else
    targetText:SetFontAlpha(0.65)
  end
end
function CreateListContent_GuildBattle_AttendMember(content, index)
  if nil == Panel_GuildBattle_SelectMember then
    return
  end
  local memberIndex = Int64toInt32(index)
  local userNo = ToClient_GuildBattle_GetUserNoFromEntryList(memberIndex)
  local memberInfo
  if ToClient_isPersonalBattle() then
    if false == ToClient_GuildBattle_AmIMasterForThisBattle() then
      userNo = ToClient_GuildBattle_GetUserNoFromJoinedList(memberIndex)
    end
    memberInfo = Toclient_getPersonalBattleMemberInfo(userNo)
  else
    local myGuildListInfo = ToClient_GetMyGuildInfoWrapper()
    if nil == myGuildListInfo then
      return
    end
    memberInfo = myGuildListInfo:getMemberByUserNo(userNo)
  end
  if nil == memberInfo then
    return
  end
  local checkBtn_AsAttend = UI.getChildControl(content, "CheckButton_ItemSort")
  local static_ClassIcon = UI.getChildControl(content, "Static_ClassIcon")
  local staticText_Level = UI.getChildControl(content, "StaticText_Level")
  local staticText_Name = UI.getChildControl(content, "StaticText_CharacterName")
  local staticText_State = UI.getChildControl(content, "StaticText_State")
  local staticPartyLeaderIcon = UI.getChildControl(content, "Static_PartyLeaderIcon")
  local hideCheckBox = ToClient_GuildBattle_GetMaxAttendCount() > 1
  local isEnableText = true
  if true == PaGlobal_GuildBattle_SelectAttend._canSelectAttend then
    if true == ToClient_GuildBattle_IsMemberInDeadList(userNo) then
      staticText_State:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_PLAYERSTATE_DEAD"))
      checkBtn_AsAttend:SetShow(false)
      EnableControl(staticText_Name, false)
      EnableControl(staticText_Level, false)
      isEnableText = false
    else
      if true == ToClient_GuildBattle_IsMemberInAttendList(userNo) then
        EnableControl(checkBtn_AsAttend, true)
        checkBtn_AsAttend:SetShow(true)
        checkBtn_AsAttend:SetCheck(true)
        checkBtn_AsAttend:addInputEvent("Mouse_LUp", "PaGlobal_GuildBattle_SelectAttend:ToggleAttendMember(" .. memberIndex .. ")")
      elseif true == hideCheckBox and true == ToClient_GuildBattle_IsAttendMemberComplete() then
        checkBtn_AsAttend:SetShow(false)
      else
        EnableControl(checkBtn_AsAttend, true)
        checkBtn_AsAttend:SetShow(true)
        checkBtn_AsAttend:SetCheck(false)
        checkBtn_AsAttend:addInputEvent("Mouse_LUp", "PaGlobal_GuildBattle_SelectAttend:ToggleAttendMember(" .. memberIndex .. ")")
      end
      staticText_State:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_PLAYERSTATE_CANFIGHT"))
    end
  elseif true == ToClient_GuildBattle_IsMemberInAttendList(userNo) then
    EnableControl(checkBtn_AsAttend, false)
    checkBtn_AsAttend:SetShow(true)
    checkBtn_AsAttend:SetCheck(true)
    staticText_State:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_PLAYERSTATE_FIGHTING"))
  elseif true == ToClient_GuildBattle_IsMemberInDeadList(userNo) then
    staticText_State:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_PLAYERSTATE_DEAD"))
    checkBtn_AsAttend:SetShow(false)
    EnableControl(staticText_Name, false)
    EnableControl(staticText_Level, false)
    isEnableText = false
  else
    staticText_State:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_PLAYERSTATE_WAITING"))
    checkBtn_AsAttend:SetShow(false)
    EnableControl(staticText_Name, false)
    EnableControl(staticText_Level, false)
    isEnableText = false
  end
  local classSymbomInfo = CppEnums.ClassType_Symbol[memberInfo:getClassType()]
  static_ClassIcon:ChangeTextureInfoName(classSymbomInfo[1])
  local x1, y1, x2, y2 = setTextureUV_Func(static_ClassIcon, classSymbomInfo[2], classSymbomInfo[3], classSymbomInfo[4], classSymbomInfo[5])
  static_ClassIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  static_ClassIcon:setRenderTexture(static_ClassIcon:getBaseTexture())
  staticText_Level:SetText(tostring(memberInfo:getLevel()))
  EnableText(staticText_Level, isEnableText)
  staticText_Name:SetText(memberInfo:getCharacterName())
  EnableText(staticText_Name, isEnableText)
  if true == ToClient_GuildBattle_IsWaitingAttendSelectResult() or true == ToClient_GuildBattle_IsAttendMemberConfirmed() then
    EnableControl(checkBtn_AsAttend, false)
  end
  staticPartyLeaderIcon:SetShow(false)
  if false == ToClient_GuildBattle_AmIMasterForThisBattle() then
    checkBtn_AsAttend:SetShow(false)
    if 0 == memberIndex then
      staticPartyLeaderIcon:SetShow(true)
    end
  end
end
function PaGlobal_GuildBattle_SelectAttend:Initialize()
  if nil == Panel_GuildBattle_SelectMember then
    return
  end
  local ui = self._ui
  ui._btn_WinClose = UI.getChildControl(Panel_GuildBattle_SelectMember, "Button_Win_Close")
  ui._staticText_Title = UI.getChildControl(Panel_GuildBattle_SelectMember, "StaticText_Title")
  ui._static_TopBg = UI.getChildControl(Panel_GuildBattle_SelectMember, "Static_TopBg")
  ui._static_Bg = UI.getChildControl(Panel_GuildBattle_SelectMember, "Static_Bg")
  ui._static_BottomBg = UI.getChildControl(Panel_GuildBattle_SelectMember, "Static_BottomBg")
  ui._staticText_LeftTime = UI.getChildControl(ui._static_TopBg, "StaticText_LeftTime")
  ui._btn_Reload = UI.getChildControl(ui._static_TopBg, "Button_Reload")
  ui._staticText_Line = UI.getChildControl(ui._static_Bg, "StaticText_Line")
  ui._staticText_CheckTitle = UI.getChildControl(ui._static_Bg, "StaticText_CheckTitle")
  ui._staticText_ClassTitle = UI.getChildControl(ui._static_Bg, "StaticText_ClassTitle")
  ui._staticText_LevelTitle = UI.getChildControl(ui._static_Bg, "StaticText_LevelTitle")
  ui._staticText_NameTitle = UI.getChildControl(ui._static_Bg, "StaticText_NameTitle")
  ui._staticText_StateTitle = UI.getChildControl(ui._static_Bg, "StaticText_StateTitle")
  ui._list_GuildMembers = UI.getChildControl(ui._static_Bg, "List2_Member")
  ui._btn_ConfirmAttend = UI.getChildControl(ui._static_BottomBg, "Button_Adjust")
  ui._staticText_AttendCount = UI.getChildControl(ui._static_BottomBg, "StaticText_AttendCount")
end
function PaGlobal_GuildBattle_SelectAttend:registEventHandler()
  if nil == Panel_GuildBattle_SelectMember then
    return
  end
  self._ui._btn_ConfirmAttend:addInputEvent("Mouse_LUp", "PaGlobal_GuildBattle_SelectAttend:ConfirmAttendMember()")
  self._ui._btn_Reload:addInputEvent("Mouse_LUp", "PaGlobal_GuildBattle_SelectAttend:UpdateMemberInfo()")
  self._ui._list_GuildMembers:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "CreateListContent_GuildBattle_AttendMember")
  self._ui._list_GuildMembers:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function PaGlobal_GuildBattle_SelectAttend:registMessageHandler()
  registerEvent("FromClient_selectAttendResult", "FromClient_GuildBattle_SelectAttendResult")
end
function PaGlobal_GuildBattle_SelectAttend:Show(isShow)
  if true == isShow then
    PaGlobal_GuildBattleSelectAttend_CheckLoadUI()
    self:UpdateMemberInfo()
    self:UpdateRemainTime()
    if false == ToClient_GuildBattle_IsAttendMemberComplete() then
      self._canSelectAttend = true
    else
      self._canSelectAttend = false
    end
    if true == ToClient_isPersonalBattle() then
      self._ui._btn_Reload:SetShow(false)
    end
  else
    PaGlobal_GuildBattleSelectAttend_CheckCloseUI()
  end
end
function PaGlobal_GuildBattle_SelectAttend:IsShow()
  if nil == Panel_GuildBattle_SelectMember then
    return false
  end
  return Panel_GuildBattle_SelectMember:GetShow()
end
function PaGlobal_GuildBattle_SelectAttend:UpdateMemberInfo()
  if nil == Panel_GuildBattle_SelectMember then
    return
  end
  local ui = self._ui
  local entryCount = 0
  if true == ToClient_isPersonalBattle() then
    entryCount = ToClient_getPersonalBattleMemberCount()
  else
    entryCount = ToClient_GuildBattle_GetEntryCount()
  end
  local memberListElementManager = ui._list_GuildMembers:getElementManager()
  memberListElementManager:clearKey()
  for i = 1, entryCount do
    memberListElementManager:pushKey(i - 1)
  end
  self:UpdateConfirmButton()
  self:UpdateMemberCountText()
end
function PaGlobal_GuildBattle_SelectAttend:UpdateRemainTime()
  if nil == Panel_GuildBattle_SelectMember then
    return
  end
  local remainTime = ToClient_GuildBattle_GetRemainTime()
  if remainTime < 0 then
    remainTime = 0
  end
  local min = math.floor(remainTime / 60)
  local sec = math.floor(remainTime % 60)
  if min > 0 then
    self._ui._staticText_LeftTime:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_TIMELIMIT_MMSS", "min", tostring(min), "sec", tostring(sec)))
  else
    self._ui._staticText_LeftTime:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_TIMELIMIT_SS", "sec", tostring(sec)))
  end
end
function PaGlobal_GuildBattle_SelectAttend:ToggleAttendMember(index)
  if nil == Panel_GuildBattle_SelectMember then
    return
  end
  if 1 == ToClient_GuildBattle_GetMaxAttendCount() then
    ToClient_GuildBattle_ToggleAttendMember(index)
    self:UpdateMemberInfo()
  else
    local wasAttendComplete = ToClient_GuildBattle_IsAttendMemberComplete()
    ToClient_GuildBattle_ToggleAttendMember(index)
    if wasAttendComplete ~= ToClient_GuildBattle_IsAttendMemberComplete() then
      self:UpdateMemberInfo()
    end
  end
  self:UpdateConfirmButton()
  self:UpdateMemberCountText()
end
function PaGlobal_GuildBattle_SelectAttend:UpdateMemberCountText()
  if nil == Panel_GuildBattle_SelectMember then
    return
  end
  local attendCount = ToClient_GuildBattle_GetAttendCount()
  local maxAttendCount = ToClient_GuildBattle_GetMaxAttendCount()
  self._ui._staticText_AttendCount:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_ATTEND_COUNT", "attendCount", tostring(attendCount), "maxAttendCount", tostring(maxAttendCount)))
end
function PaGlobal_GuildBattle_SelectAttend:UpdateConfirmButton()
  if nil == Panel_GuildBattle_SelectMember then
    return
  end
  if true == ToClient_GuildBattle_IsAttendMemberConfirmed() then
    EnableControl(self._ui._btn_ConfirmAttend, false)
  elseif true == ToClient_GuildBattle_IsAttendMemberComplete() and true == self._canSelectAttend then
    if true == ToClient_GuildBattle_IsWaitingAttendSelectResult() then
      EnableControl(self._ui._btn_ConfirmAttend, false)
    else
      EnableControl(self._ui._btn_ConfirmAttend, true)
    end
  else
    EnableControl(self._ui._btn_ConfirmAttend, false)
  end
  if false == ToClient_GuildBattle_AmIMasterForThisBattle() then
    self._ui._btn_ConfirmAttend:SetShow(false)
    self._ui._staticText_AttendCount:SetShow(false)
    self._ui._staticText_CheckTitle:SetShow(false)
  else
    self._ui._btn_ConfirmAttend:SetShow(true)
    self._ui._staticText_AttendCount:SetShow(true)
    self._ui._staticText_CheckTitle:SetShow(true)
  end
end
function PaGlobal_GuildBattle_SelectAttend:ConfirmAttendMember()
  ToClient_GuildBattle_ConfirmAttendMember()
  self:UpdateMemberInfo()
end
function PaGlobal_GuildBattleSelectAttend_CheckLoadUI()
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_GuildBattle_SelectMember:SetShow(true)
    return
  end
  local rv = reqLoadUI("UI_Data/Window/Guild/Panel_GuildBattle_SelectMember.XML", "Panel_GuildBattle_SelectMember", Defines.UIGroup.PAGameUIGroup_Widget, PAUIRenderModeBitSet({
    Defines.RenderMode.eRenderMode_Default
  }))
  if nil ~= rv then
    Panel_GuildBattle_SelectMember = rv
    rv = nil
    PaGlobal_GuildBattleSelectAttend_Init()
  end
  Panel_GuildBattle_SelectMember:SetShow(true)
end
function PaGlobal_GuildBattleSelectAttend_CheckCloseUI()
  if false == PaGlobal_AgreementGuildMaster_GetShow() then
    return
  end
  if false == _ContentsGroup_PanelReload_Develop then
    Panel_GuildBattle_SelectMember:SetShow(false)
  else
    reqCloseUI(Panel_GuildBattle_SelectMember)
  end
end
function FromClient_luaLoadComplete_GuildBattle_SelectAttend()
  PaGlobal_GuildBattleSelectAttend_Init()
  PaGlobal_GuildBattle_SelectAttend:registMessageHandler()
end
function PaGlobal_GuildBattleSelectAttend_Init()
  PaGlobal_GuildBattle_SelectAttend:Initialize()
  PaGlobal_GuildBattle_SelectAttend:registEventHandler()
end
function FromClient_GuildBattle_SelectAttendResult(isSuccess)
  if true == isSuccess then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_SETATTENDFINISHED"))
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_SETATTENDFAILED"))
  end
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_GuildBattle_SelectAttend")

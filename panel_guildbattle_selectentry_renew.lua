PaGlobal_GuildBattle_SelectEntry = {
  _ui = {
    _btn_WinClose = UI.getChildControl(Panel_GuildBattle_EntryList, "Button_Win_Close"),
    _staticText_Title = UI.getChildControl(Panel_GuildBattle_EntryList, "StaticText_Title"),
    _static_TopBg = UI.getChildControl(Panel_GuildBattle_EntryList, "Static_TopBg"),
    _static_Bg = UI.getChildControl(Panel_GuildBattle_EntryList, "Static_Bg"),
    _static_BottomBg = UI.getChildControl(Panel_GuildBattle_EntryList, "Static_BottomBg")
  }
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
function CreateListContent_GuildBattle_EntryMember(content, index)
  if Int64toInt32(index) < 0 then
    return
  end
  local memberIndex = Int64toInt32(index)
  local userNo = ToClient_GuildBattle_GetUserNoFromJoinedList(memberIndex)
  _PA_LOG("\236\161\176\236\158\172\236\155\144", tostring(userNo))
  local memberInfo
  if ToClient_isPersonalBattle() then
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
  local checkBtn_AsEntry = UI.getChildControl(content, "CheckButton_ItemSort")
  local static_ClassIcon = UI.getChildControl(content, "Static_ClassIcon")
  local staticText_Level = UI.getChildControl(content, "StaticText_Level")
  local staticText_Name = UI.getChildControl(content, "StaticText_CharacterName")
  local staticText_State = UI.getChildControl(content, "StaticText_State")
  local hideCheckBox = ToClient_GuildBattle_GetMaxEntryCount() > 1
  local joinedCount = ToClient_GuildBattle_GetMyGuildMemberJoinedCount()
  local maxEntryCount = ToClient_GuildBattle_GetMaxEntryCount()
  local shouldSelectAll = joinedCount <= maxEntryCount
  local classSymbomInfo = CppEnums.ClassType_Symbol[memberInfo:getClassType()]
  static_ClassIcon:ChangeTextureInfoName(classSymbomInfo[1])
  local x1, y1, x2, y2 = setTextureUV_Func(static_ClassIcon, classSymbomInfo[2], classSymbomInfo[3], classSymbomInfo[4], classSymbomInfo[5])
  static_ClassIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  static_ClassIcon:setRenderTexture(static_ClassIcon:getBaseTexture())
  staticText_Level:SetText(tostring(memberInfo:getLevel()))
  staticText_Name:SetText(memberInfo:getCharacterName())
  if true == shouldSelectAll then
    checkBtn_AsEntry:SetCheck(true)
  elseif true == ToClient_GuildBattle_IsMemberInEntryList(userNo) then
    checkBtn_AsEntry:SetShow(true)
    checkBtn_AsEntry:SetCheck(true)
    checkBtn_AsEntry:addInputEvent("Mouse_LUp", "PaGlobal_GuildBattle_SelectEntry:ToggleEntryMember(" .. memberIndex .. ")")
  elseif true == hideCheckBox and true == ToClient_GuildBattle_IsEntryMemberComplete() then
    checkBtn_AsEntry:SetShow(false)
  else
    checkBtn_AsEntry:SetShow(true)
    checkBtn_AsEntry:SetCheck(false)
    checkBtn_AsEntry:addInputEvent("Mouse_LUp", "PaGlobal_GuildBattle_SelectEntry:ToggleEntryMember(" .. memberIndex .. ")")
  end
  if true == shouldSelectAll then
    EnableControl(checkBtn_AsEntry, false)
    staticText_State:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_PLAYERSTATE_ALLFIGHT"))
  else
    staticText_State:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_PLAYERSTATE_CANFIGHT"))
  end
  if true == ToClient_GuildBattle_IsWaitingEntrySelectResult() or true == ToClient_GuildBattle_IsEntryMemberConfirmed() then
    EnableControl(checkBtn_AsEntry, false)
  end
end
function PaGlobal_GuildBattle_SelectEntry:Initialize()
  local ui = self._ui
  ui._staticText_LeftTime = UI.getChildControl(ui._static_TopBg, "StaticText_LeftTime")
  ui._btn_Reload = UI.getChildControl(ui._static_TopBg, "Button_Reload")
  ui._staticText_Line = UI.getChildControl(ui._static_Bg, "StaticText_Line")
  ui._staticText_CheckTitle = UI.getChildControl(ui._static_Bg, "StaticText_CheckTitle")
  ui._staticText_ClassTitle = UI.getChildControl(ui._static_Bg, "StaticText_ClassTitle")
  ui._staticText_LevelTitle = UI.getChildControl(ui._static_Bg, "StaticText_LevelTitle")
  ui._staticText_NameTitle = UI.getChildControl(ui._static_Bg, "StaticText_NameTitle")
  ui._staticText_StateTitle = UI.getChildControl(ui._static_Bg, "StaticText_StateTitle")
  ui._list_GuildMembers = UI.getChildControl(ui._static_Bg, "List2_Member")
  ui._staticText_MemberCount = UI.getChildControl(ui._static_BottomBg, "StaticText_CurrentMemberCount")
  ui._staticText_EntryCount = UI.getChildControl(ui._static_BottomBg, "StaticText_EntryCount")
  ui._btn_ConfirmEntry = UI.getChildControl(ui._static_BottomBg, "Button_Confirm")
  ui._btn_Reload:addInputEvent("Mouse_LUp", "PaGlobal_GuildBattle_SelectEntry:UpdateMemberInfo()")
  ui._btn_ConfirmEntry:addInputEvent("Mouse_LUp", "PaGlobal_GuildBattle_SelectEntry:ConfirmEntryMember()")
  ui._list_GuildMembers:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "CreateListContent_GuildBattle_EntryMember")
  ui._list_GuildMembers:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function PaGlobal_GuildBattle_SelectEntry:ConfirmEntryMember()
  ToClient_GuildBattle_ConfirmEntryMember()
  self:UpdateMemberInfo()
end
function PaGlobal_GuildBattle_SelectEntry:Show(isShow)
  Panel_GuildBattle_EntryList:SetShow(isShow)
  if true == isShow then
    self:UpdateMemberInfo()
    self:UpdateRemainTime()
  end
end
function PaGlobal_GuildBattle_SelectEntry:IsShow()
  return Panel_GuildBattle_EntryList:GetShow()
end
function PaGlobal_GuildBattle_SelectEntry:UpdateMemberInfo()
  local memberCountJoined = ToClient_GuildBattle_GetMyGuildMemberJoinedCount()
  local shouldSelectAll = memberCountJoined <= ToClient_GuildBattle_GetMaxEntryCount()
  local memberListElementManager = self._ui._list_GuildMembers:getElementManager()
  if true == shouldSelectAll then
    for i = 1, memberCountJoined do
      ToClient_GuildBattle_SetJoinedMemberAsEntry(i - 1)
    end
  end
  memberListElementManager:clearKey()
  if true == ToClient_isPersonalBattle() and false == ToClient_GuildBattle_AmIMasterForThisBattle() then
    memberCountJoined = ToClient_getPersonalBattleMemberCount()
  end
  for i = 1, memberCountJoined do
    memberListElementManager:pushKey(i - 1)
  end
  self:UpdateControlButton()
  self:UpdateMemberCountText()
end
function PaGlobal_GuildBattle_SelectEntry:UpdateRemainTime()
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
function PaGlobal_GuildBattle_SelectEntry:UpdateControlButton()
  if true == ToClient_GuildBattle_IsEntryMemberConfirmed() then
    EnableControl(self._ui._btn_ConfirmEntry, false)
  elseif true == ToClient_GuildBattle_IsEntryMemberComplete() then
    EnableControl(self._ui._btn_ConfirmEntry, true)
  elseif true == ToClient_GuildBattle_IsWaitingEntrySelectResult() then
    EnableControl(self._ui._btn_ConfirmEntry, false)
  elseif ToClient_GuildBattle_GetMaxEntryCount() >= ToClient_GuildBattle_GetMyGuildMemberJoinedCount() and ToClient_GuildBattle_GetMyGuildMemberJoinedCount() == ToClient_GuildBattle_GetEntryCount() then
    EnableControl(self._ui._btn_ConfirmEntry, true)
  else
    EnableControl(self._ui._btn_ConfirmEntry, false)
  end
  if false == ToClient_GuildBattle_AmIMasterForThisBattle() then
    self._ui._btn_ConfirmEntry:SetShow(false)
  else
    self._ui._btn_ConfirmEntry:SetShow(true)
  end
end
function PaGlobal_GuildBattle_SelectEntry:ToggleEntryMember(index)
  if 1 == ToClient_GuildBattle_GetMaxEntryCount() then
    ToClient_GuildBattle_ToggleEntryMember(index)
    self:UpdateMemberInfo()
  else
    local wasEntryComplete = ToClient_GuildBattle_IsEntryMemberComplete()
    ToClient_GuildBattle_ToggleEntryMember(index)
    if wasEntryComplete ~= ToClient_GuildBattle_IsEntryMemberComplete() then
      self:UpdateMemberInfo()
    else
      self:UpdateControlButton()
      self:UpdateMemberCountText()
    end
  end
end
function PaGlobal_GuildBattle_SelectEntry:UpdateMemberCountText()
  local joinedCount = ToClient_GuildBattle_GetMyGuildMemberJoinedCount()
  local entryCount = ToClient_GuildBattle_GetEntryCount()
  local maxEntryCount = ToClient_GuildBattle_GetMaxEntryCount()
  self._ui._staticText_MemberCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_JOINEDMEMBER_COUNT", "count", tostring(joinedCount)))
  self._ui._staticText_EntryCount:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_ENTRY_COUNT", "entryCount", tostring(entryCount), "maxEntryCount", tostring(maxEntryCount)))
end
function FromClient_luaLoadComplete_GuildBattle_SelectEntry()
  PaGlobal_GuildBattle_SelectEntry:Initialize()
end
function FromClient_GuildBattle_SelectEntryResult(isSuccess)
  if true == isSuccess then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_SETENTRYFINISHED"))
  else
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDBATTLE_SETENTRYFAILED"))
  end
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_GuildBattle_SelectEntry")
registerEvent("FromClient_selectEntryResult", "FromClient_GuildBattle_SelectEntryResult")

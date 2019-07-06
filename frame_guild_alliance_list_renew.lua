local UI_color = Defines.Color
Panel_Guild_Alliance_List:SetShow(false)
PaGlobal_GuildAllianceList = {
  _ui_main = {},
  _ui_info = {},
  _defaultFrameBG_AllianceList = nil
}
local alliance_ListUI = {}
function PaGlobal_GuildAllianceList:initialize()
  self._ui_main = {
    _basic_GuildAllianceInfo = UI.getChildControl(Panel_Guild_Alliance_List, "Static_AllianceInfo_BG"),
    _todayBoard = UI.getChildControl(Panel_Guild_Alliance_List, "StaticText_TodayBd"),
    _static_GuildAllianceMember = UI.getChildControl(Panel_Guild_Alliance_List, "Static_List_BG"),
    _guildAllianceMember_list2 = UI.getChildControl(Panel_Guild_Alliance_List, "List2_GuildList"),
    _guildAllianceMember_Title = UI.getChildControl(Panel_Guild_Alliance_List, "StaticText_JoinGuild_Title")
  }
  self._ui_main._guildAllianceMember_Title:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  self._ui_main._guildAllianceMember_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TAB_ALLIANCELISTITLE"))
  if self._ui_main._guildAllianceMember_Title:IsLimitText() then
    self._ui_main._guildAllianceMember_Title:SetIgnore(false)
    self._ui_main._guildAllianceMember_Title:addInputEvent("Mouse_On", "PaGlobalFunc_AllianceListTitle_TooltipLimitedText(true)")
    self._ui_main._guildAllianceMember_Title:addInputEvent("Mouse_Out", "PaGlobalFunc_AllianceListTitle_TooltipLimitedText(false)")
  else
    self._ui_main._guildAllianceMember_Title:SetIgnore(true)
  end
  local listMember = self._ui_main._guildAllianceMember_list2
  listMember:changeAnimationSpeed(10)
  listMember:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "FGlobal_GuildAllianceMember_ListUpdate")
  listMember:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  local memberListBg = UI.getChildControl(Panel_Guild_Alliance_List, "Static_List_BG")
  local static_Level = UI.getChildControl(memberListBg, "StaticText_Level")
  local static_Class = UI.getChildControl(memberListBg, "StaticText_Class")
  local static_Name = UI.getChildControl(memberListBg, "StaticText_CharName")
  local static_Guild = UI.getChildControl(memberListBg, "StaticText_GuildName")
  static_Level:addInputEvent("Mouse_LUp", "HandleClicked_AllianceListSort( " .. 1 .. " )")
  static_Class:addInputEvent("Mouse_LUp", "HandleClicked_AllianceListSort( " .. 2 .. " )")
  static_Name:addInputEvent("Mouse_LUp", "HandleClicked_AllianceListSort( " .. 3 .. " )")
  static_Guild:addInputEvent("Mouse_LUp", "HandleClicked_AllianceListSort( " .. 4 .. " )")
  local basicInfo = self._ui_main._basic_GuildAllianceInfo
  local iconBg = UI.getChildControl(basicInfo, "Static_AllyIcon_BG")
  self._ui_info = {
    _allianceMark = UI.getChildControl(basicInfo, "Static_Ally_Icon"),
    _allianceName = UI.getChildControl(basicInfo, "StaticText_R_GuildAlliacneName"),
    _memberCount = UI.getChildControl(basicInfo, "StaticText_MemberCountValue"),
    _occupyingAreaTitle = UI.getChildControl(basicInfo, "StaticText_Area"),
    _occupyingArea = UI.getChildControl(basicInfo, "StaticText_AreaName"),
    _guild_list2 = UI.getChildControl(basicInfo, "List2_AllianceList"),
    _buttonShowAll = UI.getChildControl(memberListBg, "Button_ShowAll")
  }
  self._ui_info._occupyingArea:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  local listGuild = self._ui_info._guild_list2
  listGuild:changeAnimationSpeed(10)
  listGuild:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "FGlobal_GuildAllianceGuild_ListUpdate")
  listGuild:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui_info._buttonShowAll:addInputEvent("Mouse_LUp", "HandleClicked_GuildAllianceList_ShowAll()")
  self._ui_info._Web = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_WEBCONTROL, self._ui_main._todayBoard, "WebControl_Alliance_WebLink")
  self._ui_info._Web:SetShow(true)
  self._ui_info._Web:SetSize(423, 216)
  self._ui_info._Web:ResetUrl()
end
function PaGlobal_GuildAllianceList:Update()
  local myAllianceWrapper = ToClient_GetMyGuildAllianceWrapper()
  if nil == myAllianceWrapper then
    return
  end
  local isSet = setGuildTextureByAllianceNo(myAllianceWrapper:guildAllianceNo_s64(), self._ui_info._allianceMark)
  if false == isSet then
    self._ui_info._allianceMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui_info._allianceMark, 183, 1, 188, 6)
    self._ui_info._allianceMark:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui_info._allianceMark:setRenderTexture(self._ui_info._allianceMark:getBaseTexture())
  else
    self._ui_info._allianceMark:getBaseTexture():setUV(0, 0, 1, 1)
    self._ui_info._allianceMark:setRenderTexture(self._ui_info._allianceMark:getBaseTexture())
  end
  self._ui_info._allianceName:SetText(myAllianceWrapper:getRepresentativeName())
  self._ui_info._memberCount:SetPosX(self._ui_info._allianceName:GetPosX() + self._ui_info._allianceName:GetSizeX() + 20)
  self._ui_info._memberCount:SetPosY(self._ui_info._allianceName:GetPosY() + self._ui_info._allianceName:GetSizeY() / 2)
  local memberCount = tostring(myAllianceWrapper:getUserCount()) .. " / 100"
  self._ui_info._memberCount:SetText(memberCount)
  local myGuildAllianceCache = ToClient_GetMyGuildAlliancChairGuild()
  self._ui_info._occupyingArea:SetText("-")
  self._ui_info._occupyingArea:addInputEvent("Mouse_On", "")
  self._ui_info._occupyingArea:addInputEvent("Mouse_Out", "")
  local guildArea1 = ""
  local territoryKey = ""
  local territoryWarName = ""
  if 0 < myGuildAllianceCache:getTerritoryCount() then
    for idx = 0, myGuildAllianceCache:getTerritoryCount() - 1 do
      territoryKey = myGuildAllianceCache:getTerritoryKeyAt(idx)
      if territoryKey >= 0 then
        local territoryInfoWrapper = getTerritoryInfoWrapperByIndex(territoryKey)
        if nil ~= territoryInfoWrapper then
          guildArea1 = territoryInfoWrapper:getTerritoryName()
          local territoryComma = ", "
          if "" == territoryWarName then
            territoryComma = ""
          end
          territoryWarName = territoryWarName .. territoryComma .. guildArea1
        end
        self._ui_info._occupyingArea:SetText(territoryWarName)
      end
    end
  end
  local guildArea2 = ""
  local regionKey = ""
  local siegeWarName = ""
  if 0 < myGuildAllianceCache:getSiegeCount() then
    for idx = 0, myGuildAllianceCache:getSiegeCount() - 1 do
      regionKey = myGuildAllianceCache:getSiegeKeyAt(idx)
      if regionKey > 0 then
        local regionInfoWrapper = getRegionInfoWrapper(regionKey)
        if nil ~= regionInfoWrapper then
          guildArea2 = regionInfoWrapper:getAreaName()
          local siegeComma = ", "
          if "" == siegeWarName then
            siegeComma = ""
          end
          siegeWarName = siegeWarName .. siegeComma .. guildArea2
        end
        self._ui_info._occupyingArea:SetText(siegeWarName)
      end
    end
    self._ui_info._occupyingArea:addInputEvent("Mouse_On", "PaGlobal_GuildAllianceList_HandleClicked_TerritoryNameOnEvent( true )")
    self._ui_info._occupyingArea:addInputEvent("Mouse_Out", "PaGlobal_GuildAllianceList_HandleClicked_TerritoryNameOnEvent( false )")
  end
  self._ui_info._occupyingAreaTitle:SetText(self._ui_info._occupyingAreaTitle:GetText())
  self._ui_info._occupyingArea:SetPosX(self._ui_info._occupyingAreaTitle:GetPosX() + self._ui_info._occupyingAreaTitle:GetTextSizeX() + 10)
  local guildCount = myAllianceWrapper:getMemberCount()
  self._ui_info._guild_list2:getElementManager():clearKey()
  for index = 0, guildCount - 1 do
    self._ui_info._guild_list2:getElementManager():pushKey(toInt64(0, index))
  end
end
function PaGlobal_GuildAllianceList_HandleClicked_TerritoryNameOnEvent(isShow)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local self = PaGlobal_GuildAllianceList
  local myGuildAllianceCache = ToClient_GetMyGuildAlliancChairGuild()
  local guildArea2 = ""
  local regionKey = ""
  local siegeWarName = ""
  for idx = 0, myGuildAllianceCache:getSiegeCount() - 1 do
    regionKey = myGuildAllianceCache:getSiegeKeyAt(idx)
    if regionKey > 0 then
      local regionInfoWrapper = getRegionInfoWrapper(regionKey)
      if nil ~= regionInfoWrapper then
        guildArea2 = regionInfoWrapper:getAreaName()
        local siegeComma = ", "
        if "" == siegeWarName then
          siegeComma = ""
        end
        siegeWarName = siegeWarName .. siegeComma .. guildArea2
      end
    end
  end
  local uiControl = self._ui_info._occupyingArea
  local name = siegeWarName
  TooltipSimple_Show(uiControl, name)
end
function FGlobal_GuildAllianceGuild_ListUpdate(contents, index)
  local allianceWrapper = ToClient_GetMyGuildAllianceWrapper()
  if nil == allianceWrapper then
    return
  end
  local guildWrapper = allianceWrapper:getMemberGuild(Int64toInt32(index))
  if nil == guildWrapper then
    return
  end
  local guildInfo = {
    radio_IsLeader = UI.getChildControl(contents, "RadioButton_LeaderCheck"),
    static_GuildName = UI.getChildControl(contents, "StaticText_GuildNameTemplete"),
    static_MemberCount = UI.getChildControl(contents, "StaticText_Guild_MemNum"),
    btn_ShowMember = UI.getChildControl(contents, "Button_Confirm")
  }
  local isAllianceChairman = guildWrapper:isAllianceChair()
  guildInfo.radio_IsLeader:SetCheck(isAllianceChairman)
  guildInfo.radio_IsLeader:SetShow(isAllianceChairman)
  if isAllianceChairman then
    guildInfo.static_GuildName:SetFontColor(4294294074)
    guildInfo.static_MemberCount:SetFontColor(4294294074)
  else
    guildInfo.static_GuildName:SetFontColor(Defines.Color.C_FFEFEFEF)
    guildInfo.static_MemberCount:SetFontColor(Defines.Color.C_FFEFEFEF)
  end
  guildInfo.static_GuildName:SetText(guildWrapper:getName())
  local memberCount = tostring(guildWrapper:getMemberCount())
  guildInfo.static_MemberCount:SetText(memberCount)
  guildInfo.btn_ShowMember:addInputEvent("Mouse_LUp", "HandleClicked_GuildAllianceList_Show(" .. tostring(index) .. ")")
end
function PaGlobal_GuildAllianceList:WebCommentLoad()
  local myGuildWrapper = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildWrapper then
    return
  end
  local myGuildNo_s64 = myGuildWrapper:getGuildNo_s64()
  local myAllianceWrapper = ToClient_GetMyGuildAllianceWrapper()
  if nil == myAllianceWrapper then
    return
  end
  local leaderGuildIndex = 0
  local guildCount = myAllianceWrapper:getMemberCount()
  for index = 0, guildCount - 1 do
    local guildWrapper = myAllianceWrapper:getMemberGuild(index)
    if guildWrapper:isAllianceChair() then
      leaderGuildIndex = index
      break
    end
  end
  local guildWrapper = myAllianceWrapper:getMemberGuild(leaderGuildIndex)
  local guildNo_s64 = guildWrapper:getGuildNo_s64()
  local myUserNo = getSelfPlayer():get():getUserNo()
  local cryptKey = getSelfPlayer():get():getWebAuthenticKeyCryptString()
  local temporaryWrapper = getTemporaryInformationWrapper()
  local worldNo = temporaryWrapper:getSelectedWorldServerNo()
  guildCommentsWebUrl = PaGlobal_URL_Check(worldNo)
  local isGuildMaster = getSelfPlayer():get():isGuildMaster()
  local isGuildSubMaster = getSelfPlayer():get():isGuildSubMaster()
  local isAdmin = 0
  if myGuildNo_s64 == guildNo_s64 and (isGuildMaster or isGuildSubMaster) then
    isAdmin = 1
  end
  self._ui_info._Web:ResetUrl()
  if nil ~= guildCommentsWebUrl then
    FGlobal_SetCandidate()
    local url = guildCommentsWebUrl .. "/guild?guildNo=" .. tostring(myGuildNo_s64) .. "&userNo=" .. tostring(myUserNo) .. "&certKey=" .. tostring(cryptKey) .. "&isMaster=" .. tostring(isAdmin) .. "&chairGuildNo=" .. tostring(guildNo_s64)
    _PA_LOG("\236\160\149\237\131\156\234\179\164", "\236\151\172\234\184\180 \236\151\176\235\167\185 \235\166\172\236\138\164\237\138\184 url : " .. tostring(url))
    self._ui_info._Web:SetUrl(423, 216, url, false, true)
    self._ui_info._Web:SetIME(true)
  end
  self._ui_main._todayBoard:SetText("")
end
function FGlobal_GuildAllianceList_Open(isShow)
  local self = PaGlobal_GuildAllianceList
  if isShow == true then
    self:Update()
    HandleClicked_GuildAllianceList_ShowAll()
    self._defaultFrameBG_AllianceList:SetShow(true)
    PaGlobal_GuildAllianceList:WebCommentLoad()
  else
    self._defaultFrameBG_AllianceList:SetShow(false)
    FGlobal_ClearCandidate()
    self._ui_info._Web:ResetUrl()
  end
end
function FGlobal_GuildAllianceMember_ListUpdate(contents, key)
  local info = PaGlobal_GuildAllianceList
  local index32 = Int64toInt32(key)
  local memberInfo_ui = {
    static_GradeIcon = UI.getChildControl(contents, "Static_GradeIcon"),
    static_Level = UI.getChildControl(contents, "StaticText_Level"),
    static_Class = UI.getChildControl(contents, "StaticText_Class"),
    static_Name = UI.getChildControl(contents, "StaticText_CharName"),
    static_Guild = UI.getChildControl(contents, "StaticText_GuildName")
  }
  alliance_ListUI[index32] = memberInfo_ui
  local allianceWrapper = ToClient_GetMyGuildAllianceWrapper()
  if nil == allianceWrapper then
    return
  end
  local member = allianceWrapper:getMemberByUserNo(key)
  if nil == member then
    return
  end
  local memberInfo = {
    _guild = member:getGuildName(),
    _grade = member:getGrade(),
    _level = member:getLevel(),
    _class = member:getClassType(),
    _name = member:getName(),
    _characterName = member:getCharacterName(),
    _isOnline = member:isOnline(),
    _isGhostMode = member:isGhostMode(),
    _isVacation = member:isVacation()
  }
  local class = "-"
  local level = "-"
  local characterName = "-"
  local name = memberInfo._name
  if true == memberInfo._isOnline and false == memberInfo._isGhostMode then
    class = CppEnums.ClassType2String[memberInfo._class]
    level = tostring(memberInfo._level)
  end
  local gradeType = memberInfo._grade
  local gradeValue = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMEMBER")
  if __eGuildMemberGradeMaster == gradeType then
    memberInfo_ui.static_GradeIcon:ChangeTextureInfoName("new_ui_common_forlua/window/guild/guild_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(memberInfo_ui.static_GradeIcon, 424, 159, 467, 185)
    memberInfo_ui.static_GradeIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    memberInfo_ui.static_GradeIcon:setRenderTexture(memberInfo_ui.static_GradeIcon:getBaseTexture())
    gradeValue = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMASTER")
  elseif __eGuildMemberGradeSubMaster == gradeType then
    memberInfo_ui.static_GradeIcon:ChangeTextureInfoName("new_ui_common_forlua/window/guild/guild_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(memberInfo_ui.static_GradeIcon, 468, 159, 511, 185)
    memberInfo_ui.static_GradeIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    memberInfo_ui.static_GradeIcon:setRenderTexture(memberInfo_ui.static_GradeIcon:getBaseTexture())
    gradeValue = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDSUBMASTER")
  elseif __eGuildMemberGradeNormal == gradeType then
    memberInfo_ui.static_GradeIcon:ChangeTextureInfoName("new_ui_common_forlua/window/guild/guild_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(memberInfo_ui.static_GradeIcon, 468, 219, 511, 245)
    memberInfo_ui.static_GradeIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    memberInfo_ui.static_GradeIcon:setRenderTexture(memberInfo_ui.static_GradeIcon:getBaseTexture())
    gradeValue = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMEMBER")
  elseif __eGuildMemberGradeSupplyOfficer == gradeType then
    memberInfo_ui.static_GradeIcon:ChangeTextureInfoName("new_ui_common_forlua/window/guild/guild_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(memberInfo_ui.static_GradeIcon, 424, 219, 467, 245)
    memberInfo_ui.static_GradeIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    memberInfo_ui.static_GradeIcon:setRenderTexture(memberInfo_ui.static_GradeIcon:getBaseTexture())
    gradeValue = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_SUPPLYOFFICER")
  elseif __eGuildMemberGradeJunior == gradeType then
    memberInfo_ui.static_GradeIcon:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_ETC_Guild01.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(memberInfo_ui.static_GradeIcon, 1, 1, 44, 27)
    memberInfo_ui.static_GradeIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    memberInfo_ui.static_GradeIcon:setRenderTexture(memberInfo_ui.static_GradeIcon:getBaseTexture())
    gradeValue = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_NEWBIE")
  else
    memberInfo_ui.static_GradeIcon:ChangeTextureInfoName("new_ui_common_forlua/window/guild/guild_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(memberInfo_ui.static_GradeIcon, 468, 219, 511, 245)
    memberInfo_ui.static_GradeIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    memberInfo_ui.static_GradeIcon:setRenderTexture(memberInfo_ui.static_GradeIcon:getBaseTexture())
    gradeValue = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMEMBER")
  end
  memberInfo_ui.static_GradeIcon:addInputEvent("Mouse_On", "HandleOnOut_GradeTooltip_AllianceList(true," .. index32 .. "," .. gradeType .. "," .. tostring(memberInfo._isVacation) .. ")")
  memberInfo_ui.static_GradeIcon:addInputEvent("Mouse_Out", "HandleOnOut_GradeTooltip_AllianceList(false," .. index32 .. "," .. gradeType .. "," .. tostring(memberInfo._isVacation) .. ")")
  memberInfo_ui.static_Level:SetText(level)
  memberInfo_ui.static_Class:SetText(class)
  memberInfo_ui.static_Name:SetText(name)
  memberInfo_ui.static_Guild:SetText(memberInfo._guild)
  if true == memberInfo._isVacation then
    memberInfo_ui.static_GradeIcon:SetMonoTone(true)
    memberInfo_ui.static_Level:SetFontColor(UI_color.C_FF515151)
    memberInfo_ui.static_Class:SetFontColor(UI_color.C_FF515151)
    memberInfo_ui.static_Name:SetFontColor(UI_color.C_FF515151)
    memberInfo_ui.static_Guild:SetFontColor(UI_color.C_FF515151)
  else
    memberInfo_ui.static_GradeIcon:SetMonoTone(false)
    memberInfo_ui.static_Level:SetFontColor(UI_color.C_FFC4BEBE)
    memberInfo_ui.static_Class:SetFontColor(UI_color.C_FFC4BEBE)
    memberInfo_ui.static_Name:SetFontColor(UI_color.C_FFC4BEBE)
    memberInfo_ui.static_Guild:SetFontColor(UI_color.C_FFC4BEBE)
  end
end
function HandleOnOut_GradeTooltip_AllianceList(isShow, index, gradeType, isVacation)
  local name, desc, control
  control = alliance_ListUI[index].static_GradeIcon
  if __eGuildMemberGradeMaster == gradeType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMASTER")
  elseif __eGuildMemberGradeSubMaster == gradeType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDSUBMASTER")
  elseif __eGuildMemberGradeNormal == gradeType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDMEMBER")
  elseif __eGuildMemberGradeSupplyOfficer == gradeType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_SUPPLYOFFICER")
  elseif __eGuildMemberGradeJunior == gradeType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_NEWBIE")
  end
  if true == isVacation then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_PANEL_GUILD_LIST_GRADE_ICON_VACATION_TOOLTIP")
  end
  if true == isShow then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function HandleClicked_GuildAllianceList_ShowAll()
  local info = PaGlobal_GuildAllianceList
  local allianceWrapper = ToClient_GetMyGuildAllianceWrapper()
  if nil == allianceWrapper then
    return
  end
  info._ui_main._guildAllianceMember_list2:getElementManager():clearKey()
  for guildIndex = 0, allianceWrapper:getMemberCount() - 1 do
    local guildWrapper = allianceWrapper:getMemberGuild(Int64toInt32(guildIndex))
    if nil ~= guildWrapper then
      local memberCount = guildWrapper:getMemberCount()
      for index = 0, memberCount - 1 do
        local member = guildWrapper:getMember(Int64toInt32(index))
        if nil == member then
          return
        end
        info._ui_main._guildAllianceMember_list2:getElementManager():pushKey(member:getUserNo())
        info._ui_main._guildAllianceMember_list2:requestUpdateByKey(member:getUserNo())
      end
    end
  end
end
function HandleClicked_GuildAllianceList_Show(index)
  local info = PaGlobal_GuildAllianceList
  local allianceWrapper = ToClient_GetMyGuildAllianceWrapper()
  if nil == allianceWrapper then
    return
  end
  local guildWrapper = allianceWrapper:getMemberGuild(Int64toInt32(index))
  if nil == guildWrapper then
    return
  end
  local memberCount = guildWrapper:getMemberCount()
  info._ui_main._guildAllianceMember_list2:getElementManager():clearKey()
  for index2 = 0, memberCount - 1 do
    local member = guildWrapper:getMember(Int64toInt32(index2))
    if nil == member then
      return
    end
    info._ui_main._guildAllianceMember_list2:getElementManager():pushKey(member:getUserNo())
    info._ui_main._guildAllianceMember_list2:requestUpdateByKey(member:getUserNo())
  end
end
function HandleClicked_AllianceListSort(sortType)
end
function PaGlobalFunc_AllianceList_Update()
  HandleClicked_GuildAllianceList_ShowAll()
end
function FromClient_luaLoadComplete_Panel_Guild_Alliance_List()
  local self = PaGlobal_GuildAllianceList
  self:initialize()
  self._defaultFrameBG_AllianceList = UI.getChildControl(Panel_Window_Guild, "Static_Frame_AllianceList_BG")
  self._defaultFrameBG_AllianceList:MoveChilds(self._defaultFrameBG_AllianceList:GetID(), Panel_Guild_Alliance_List)
  deletePanel(Panel_Guild_Alliance_List:GetID())
end
function PaGlobalFunc_AllianceListTitle_TooltipLimitedText(isShow)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  TooltipSimple_Show(PaGlobal_GuildAllianceList._ui_main._guildAllianceMember_Title, "", PaGlobal_GuildAllianceList._ui_main._guildAllianceMember_Title:GetText())
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_Panel_Guild_Alliance_List")

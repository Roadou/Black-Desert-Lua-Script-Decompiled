Panel_Window_GuildWarInfo:SetShow(false)
PAGlobal_GuildWarInfo = {
  _isSiegeBeing = false,
  _selectedTerritoryKey = 0,
  _defenceGuildInfo = nil,
  _offenceGuildInfo_2 = {},
  _offenceGuildInfo_3 = {},
  _offenceGuildInfo_4 = {},
  _offenceGuildList = nil,
  _defenceGuildNo = 0,
  _offenceGuildNoList = {},
  _defenceGuildIndex = 999,
  _guildWarInfo_renew_UpdateTimer = 0,
  _initComplete = false
}
local ui_main = {
  btn_Close = UI.getChildControl(Panel_Window_GuildWarInfo, "Button_Close"),
  tab_Bg = UI.getChildControl(Panel_Window_GuildWarInfo, "Static_TabBg"),
  leftGuild_Bg = UI.getChildControl(Panel_Window_GuildWarInfo, "Static_LeftGuild"),
  notOccupying = UI.getChildControl(Panel_Window_GuildWarInfo, "Static_NoOccupantBg"),
  finish_Bg = UI.getChildControl(Panel_Window_GuildWarInfo, "Static_FinishBg"),
  rightGuild_Bg_2 = UI.getChildControl(Panel_Window_GuildWarInfo, "Static_RightGuildx2_Bg"),
  rightGuild_Bg_3 = UI.getChildControl(Panel_Window_GuildWarInfo, "Static_RightGuildx3_Bg"),
  rightGuild_Bg_4 = UI.getChildControl(Panel_Window_GuildWarInfo, "Static_RightGuildx4_Bg"),
  rightGuild_Bg_list = UI.getChildControl(Panel_Window_GuildWarInfo, "List2_RightGuild5OverList"),
  btn_refresh = UI.getChildControl(Panel_Window_GuildWarInfo, "Button_Reload"),
  btn_small = UI.getChildControl(Panel_Window_GuildWarInfo, "Button_Small")
}
local ui_tab = {
  selected_territory_Name = UI.getChildControl(ui_main.tab_Bg, "StaticText_SelectedTerritoryName"),
  btn_refresh = UI.getChildControl(ui_main.tab_Bg, "Button_Reload"),
  btn_territory = {
    [0] = UI.getChildControl(ui_main.tab_Bg, "RadioButton_Territory_0"),
    [1] = UI.getChildControl(ui_main.tab_Bg, "RadioButton_Territory_1"),
    [2] = UI.getChildControl(ui_main.tab_Bg, "RadioButton_Territory_2"),
    [3] = UI.getChildControl(ui_main.tab_Bg, "RadioButton_Territory_3"),
    [4] = UI.getChildControl(ui_main.tab_Bg, "RadioButton_Territory_4")
  }
}
local ui_finishSiege_info = {
  text_Territory_Desc = UI.getChildControl(ui_main.finish_Bg, "StaticText_FinishText"),
  text_Guild_Desc = UI.getChildControl(ui_main.finish_Bg, "StaticText_ResulfText")
}
function PAGlobal_GuildWarInfo:InitDefaultUI()
  self:InitDefenceGuild()
  self:InitOffenceGuild()
  ui_main.btn_small:SetShow(true)
  self._initComplete = true
end
function PAGlobal_GuildWarInfo:InitDefenceGuild()
  ui_main.leftGuild_Bg:SetShow(false)
  ui_main.notOccupying:SetShow(false)
  local ui_defenceGuild_progress_Bg = UI.getChildControl(ui_main.leftGuild_Bg, "Static_ProgressBg")
  self._defenceGuildInfo = {
    ui_bg = ui_main.leftGuild_Bg,
    static_GuildIcon = UI.getChildControl(ui_main.leftGuild_Bg, "Static_GuildIcon"),
    static_GuildName = UI.getChildControl(ui_main.leftGuild_Bg, "StaticText_OccupyGuildName"),
    static_MasterName = UI.getChildControl(ui_main.leftGuild_Bg, "StaticText_MasterName"),
    progress_Castle = UI.getChildControl(ui_defenceGuild_progress_Bg, "Progress2_1"),
    text_CastleHp = UI.getChildControl(ui_main.leftGuild_Bg, "StaticText_Percent"),
    text_Building = UI.getChildControl(ui_main.leftGuild_Bg, "StaticText_DestroyValue"),
    text_Vehicle = UI.getChildControl(ui_main.leftGuild_Bg, "StaticText_ObjectDeathvalue"),
    text_Member = UI.getChildControl(ui_main.leftGuild_Bg, "StaticText_KillValue"),
    text_Die = UI.getChildControl(ui_main.leftGuild_Bg, "StaticText_DeathValue"),
    btn_TopMember = UI.getChildControl(ui_main.leftGuild_Bg, "Button_Record"),
    title = {}
  }
  self._defenceGuildInfo.title[0] = UI.getChildControl(ui_main.leftGuild_Bg, "StaticText_Castle")
  self._defenceGuildInfo.title[1] = UI.getChildControl(ui_main.leftGuild_Bg, "StaticText_DestroyTitle")
  self._defenceGuildInfo.title[2] = UI.getChildControl(ui_main.leftGuild_Bg, "StaticText_KillTitle")
  self._defenceGuildInfo.title[3] = UI.getChildControl(ui_main.leftGuild_Bg, "StaticText_ObjectDeathTitle")
  self._defenceGuildInfo.title[4] = UI.getChildControl(ui_main.leftGuild_Bg, "StaticText_DeathTitle")
  self._defenceGuildInfo.btn_TopMember:addInputEvent("Mouse_LUp", "HandleClicked_GuildWarInfo_renew_TopMember(0)")
  local noOccupyDesc = UI.getChildControl(ui_main.notOccupying, "StaticText_NoOccupantInfo_Desc")
  noOccupyDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  noOccupyDesc:SetText(noOccupyDesc:GetText())
  for tIndex = 0, 4 do
    self._defenceGuildInfo.title[tIndex]:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
    self._defenceGuildInfo.title[tIndex]:SetText(self._defenceGuildInfo.title[tIndex]:GetText())
    self._defenceGuildInfo.title[tIndex]:addInputEvent("Mouse_On", "PAGlobal_GuildWarInfo_TitleTooltipShow(" .. 0 .. "," .. tIndex .. ")")
    self._defenceGuildInfo.title[tIndex]:addInputEvent("Mouse_Out", "PAGlobal_GuildWarInfo_TitleTooltipHide()")
  end
end
function PAGlobal_GuildWarInfo:InitOffenceGuild()
  ui_main.rightGuild_Bg_2:SetShow(false)
  ui_main.rightGuild_Bg_3:SetShow(false)
  ui_main.rightGuild_Bg_4:SetShow(false)
  ui_main.rightGuild_Bg_list:SetShow(false)
  for index = 0, 1 do
    local ui_guild_bg = UI.getChildControl(ui_main.rightGuild_Bg_2, "Static_Guild2_" .. tostring(index + 1) .. "_Bg")
    local ui_offenceGuild_progress_Bg = UI.getChildControl(ui_guild_bg, "Static_ProgressBg")
    self._offenceGuildInfo_2[index] = {
      ui_bg = ui_guild_bg,
      static_GuildIcon = UI.getChildControl(ui_guild_bg, "Static_GuildIcon"),
      static_GuildName = UI.getChildControl(ui_guild_bg, "StaticText_GuildName"),
      static_MasterName = UI.getChildControl(ui_guild_bg, "StaticText_Name"),
      progress_Castle = UI.getChildControl(ui_offenceGuild_progress_Bg, "Progress2_1"),
      text_CastleHp = UI.getChildControl(ui_guild_bg, "StaticText_Percent"),
      text_Building = UI.getChildControl(ui_guild_bg, "StaticText_DestroyValue"),
      text_Vehicle = UI.getChildControl(ui_guild_bg, "StaticText_ObjectDeathvalue"),
      text_Member = UI.getChildControl(ui_guild_bg, "StaticText_KillValue"),
      text_Die = UI.getChildControl(ui_guild_bg, "StaticText_DeathValue"),
      btn_TopMember = UI.getChildControl(ui_guild_bg, "Button_Record"),
      title = {}
    }
    self._offenceGuildInfo_2[index].title[0] = UI.getChildControl(ui_guild_bg, "StaticText_Castle")
    self._offenceGuildInfo_2[index].title[1] = UI.getChildControl(ui_guild_bg, "StaticText_DestroyTitle")
    self._offenceGuildInfo_2[index].title[2] = UI.getChildControl(ui_guild_bg, "StaticText_KillTitle")
    self._offenceGuildInfo_2[index].title[3] = UI.getChildControl(ui_guild_bg, "StaticText_ObjectDeathTitle")
    self._offenceGuildInfo_2[index].title[4] = UI.getChildControl(ui_guild_bg, "StaticText_DeathTitle")
    ui_guild_bg:SetShow(false)
    self._offenceGuildInfo_2[index].btn_TopMember:addInputEvent("Mouse_LUp", "HandleClicked_GuildWarInfo_renew_TopMember(" .. tostring(index + 1) .. ")")
    for tIndex = 0, 4 do
      self._offenceGuildInfo_2[index].title[tIndex]:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
      self._offenceGuildInfo_2[index].title[tIndex]:SetText(self._offenceGuildInfo_2[index].title[tIndex]:GetText())
      self._offenceGuildInfo_2[index].title[tIndex]:addInputEvent("Mouse_On", "PAGlobal_GuildWarInfo_TitleTooltipShow(" .. 1 .. "," .. tIndex .. "," .. index .. ")")
      self._offenceGuildInfo_2[index].title[tIndex]:addInputEvent("Mouse_Out", "PAGlobal_GuildWarInfo_TitleTooltipHide()")
    end
  end
  for index = 0, 2 do
    local ui_guild_bg = UI.getChildControl(ui_main.rightGuild_Bg_3, "Static_Guild3_" .. tostring(index + 1) .. "_Bg")
    local ui_offenceGuild_progress_Bg = UI.getChildControl(ui_guild_bg, "Static_ProgressBg")
    self._offenceGuildInfo_3[index] = {
      ui_bg = ui_guild_bg,
      static_GuildIcon = UI.getChildControl(ui_guild_bg, "Static_GuildIcon"),
      static_GuildName = UI.getChildControl(ui_guild_bg, "StaticText_GuildName"),
      static_MasterName = UI.getChildControl(ui_guild_bg, "StaticText_Name"),
      progress_Castle = UI.getChildControl(ui_offenceGuild_progress_Bg, "Progress2_1"),
      text_CastleHp = UI.getChildControl(ui_guild_bg, "StaticText_Percent"),
      text_Building = UI.getChildControl(ui_guild_bg, "StaticText_DestroyValue"),
      text_Vehicle = UI.getChildControl(ui_guild_bg, "StaticText_ObjectDeathvalue"),
      text_Member = UI.getChildControl(ui_guild_bg, "StaticText_KillValue"),
      text_Die = UI.getChildControl(ui_guild_bg, "StaticText_DeathValue"),
      btn_TopMember = UI.getChildControl(ui_guild_bg, "Button_Record"),
      title = {}
    }
    self._offenceGuildInfo_3[index].title[0] = UI.getChildControl(ui_guild_bg, "Static_CatsleIcon")
    self._offenceGuildInfo_3[index].title[1] = UI.getChildControl(ui_guild_bg, "StaticText_DestroyIcon")
    self._offenceGuildInfo_3[index].title[2] = UI.getChildControl(ui_guild_bg, "Static_KillIcon")
    self._offenceGuildInfo_3[index].title[3] = UI.getChildControl(ui_guild_bg, "Static_ObjectDeathIcon")
    self._offenceGuildInfo_3[index].title[4] = UI.getChildControl(ui_guild_bg, "Static_DeathIcon")
    ui_guild_bg:SetShow(false)
    self._offenceGuildInfo_3[index].btn_TopMember:addInputEvent("Mouse_LUp", "HandleClicked_GuildWarInfo_renew_TopMember(" .. tostring(index + 1) .. ")")
    for tIndex = 0, 4 do
      self._offenceGuildInfo_3[index].title[tIndex]:addInputEvent("Mouse_On", "PAGlobal_GuildWarInfo_TitleTooltipShow(" .. 2 .. "," .. tIndex .. "," .. index .. ")")
      self._offenceGuildInfo_3[index].title[tIndex]:addInputEvent("Mouse_Out", "PAGlobal_GuildWarInfo_TitleTooltipHide()")
    end
  end
  for index = 0, 3 do
    local ui_guild_bg = UI.getChildControl(ui_main.rightGuild_Bg_4, "Static_Guild4_" .. tostring(index + 1) .. "_Bg")
    local ui_offenceGuild_progress_Bg = UI.getChildControl(ui_guild_bg, "Static_ProgressBg")
    self._offenceGuildInfo_4[index] = {
      ui_bg = ui_guild_bg,
      static_GuildIcon = UI.getChildControl(ui_guild_bg, "Static_GuildIcon"),
      static_GuildName = UI.getChildControl(ui_guild_bg, "StaticText_GuildName"),
      static_MasterName = UI.getChildControl(ui_guild_bg, "StaticText_Name"),
      progress_Castle = UI.getChildControl(ui_offenceGuild_progress_Bg, "Progress2_1"),
      text_CastleHp = UI.getChildControl(ui_guild_bg, "StaticText_Percent"),
      text_Building = UI.getChildControl(ui_guild_bg, "StaticText_DestroyValue"),
      text_Vehicle = UI.getChildControl(ui_guild_bg, "StaticText_ObjectDeathvalue"),
      text_Member = UI.getChildControl(ui_guild_bg, "StaticText_KillValue"),
      text_Die = UI.getChildControl(ui_guild_bg, "StaticText_DeathValue"),
      btn_TopMember = UI.getChildControl(ui_guild_bg, "Button_Record"),
      title = {}
    }
    self._offenceGuildInfo_4[index].title[0] = UI.getChildControl(ui_guild_bg, "Static_CatsleIcon")
    self._offenceGuildInfo_4[index].title[1] = UI.getChildControl(ui_guild_bg, "StaticText_DestroyIcon")
    self._offenceGuildInfo_4[index].title[2] = UI.getChildControl(ui_guild_bg, "Static_KillIcon")
    self._offenceGuildInfo_4[index].title[3] = UI.getChildControl(ui_guild_bg, "Static_ObjectDeathIcon")
    self._offenceGuildInfo_4[index].title[4] = UI.getChildControl(ui_guild_bg, "Static_DeathIcon")
    ui_guild_bg:SetShow(false)
    self._offenceGuildInfo_4[index].btn_TopMember:addInputEvent("Mouse_LUp", "HandleClicked_GuildWarInfo_renew_TopMember(" .. tostring(index + 1) .. ")")
    for tIndex = 0, 4 do
      self._offenceGuildInfo_4[index].title[tIndex]:addInputEvent("Mouse_On", "PAGlobal_GuildWarInfo_TitleTooltipShow(" .. 3 .. "," .. tIndex .. "," .. index .. ")")
      self._offenceGuildInfo_4[index].title[tIndex]:addInputEvent("Mouse_Out", "PAGlobal_GuildWarInfo_TitleTooltipHide()")
    end
  end
  ui_main.rightGuild_Bg_list:changeAnimationSpeed(10)
  ui_main.rightGuild_Bg_list:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "FGlobal_GuildWarInfo_ListUpdate")
  ui_main.rightGuild_Bg_list:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._offenceGuildList = ui_main.rightGuild_Bg_list
end
function FGlobal_GuildWarInfo_ListUpdate(contents, index)
  local info = PAGlobal_GuildWarInfo
  local index32 = Int64toInt32(index)
  local guildWrapper = ToClient_SiegeGuildAt(info._selectedTerritoryKey, index32)
  local siegeBuildingInfo = ToClient_SiegeGuildBuildingInfoAt(info._selectedTerritoryKey, index32)
  if nil == guildWrapper or nil == siegeBuildingInfo then
    return
  end
  local rightGuildIndex = index32
  if index32 > info._defenceGuildIndex then
    rightGuildIndex = rightGuildIndex - 1
  end
  FGlobal_GuildWarInfo_List_Content_Update(contents, guildWrapper, siegeBuildingInfo, rightGuildIndex)
end
function FGlobal_GuildWarInfo_List_Content_Update(contents, guildWrapper, buildingInfo, rightGuildIndex)
  local guildInfo = {
    static_GuildIcon = UI.getChildControl(contents, "Static_GuildIcon"),
    static_GuildName = UI.getChildControl(contents, "StaticText_GuildName"),
    static_MasterName = UI.getChildControl(contents, "StaticText_Name"),
    text_CastleHp = UI.getChildControl(contents, "StaticText_Percent"),
    text_Building = UI.getChildControl(contents, "StaticText_DestroyValue"),
    text_Vehicle = UI.getChildControl(contents, "StaticText_ObjectDeathvalue"),
    text_Member = UI.getChildControl(contents, "StaticText_KillValue"),
    text_Die = UI.getChildControl(contents, "StaticText_DeathValue"),
    btn_TopMember = UI.getChildControl(contents, "Button_Record"),
    title = {}
  }
  guildInfo.title[0] = UI.getChildControl(contents, "Static_CatsleIcon")
  guildInfo.title[1] = UI.getChildControl(contents, "StaticText_DestroyIcon")
  guildInfo.title[2] = UI.getChildControl(contents, "Static_KillIcon")
  guildInfo.title[3] = UI.getChildControl(contents, "Static_ObjectDeathIcon")
  guildInfo.title[4] = UI.getChildControl(contents, "Static_DeathIcon")
  for index = 0, 4 do
    guildInfo.title[index]:addInputEvent("Mouse_On", "PAGlobal_GuildWarInfo_ListTitleTooltipShow(" .. index .. ")")
    guildInfo.title[index]:addInputEvent("Mouse_Out", "PAGlobal_GuildWarInfo_ListTitleTooltipHide()")
  end
  guildInfo.btn_TopMember:addInputEvent("Mouse_LUp", "HandleClicked_GuildWarInfo_renew_TopMember(" .. tostring(rightGuildIndex + 1) .. ")")
  local guildAllianceName = guildWrapper:getAllianceName()
  if "" == guildAllianceName then
    guildInfo.static_GuildName:SetText(guildWrapper:getName())
  else
    guildInfo.static_GuildName:SetText(guildAllianceName)
  end
  guildInfo.static_MasterName:SetText(guildWrapper:getGuildMasterName())
  local isSet = false
  if true == guildWrapper:isAllianceGuild() then
    isSet = setGuildTextureByAllianceNo(guildWrapper:guildAllianceNo_s64(), guildInfo.static_GuildIcon)
  else
    isSet = setGuildTextureByGuildNo(guildWrapper:getGuildNo_s64(), guildInfo.static_GuildIcon)
  end
  if false == isSet then
    guildInfo.static_GuildIcon:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(guildInfo.static_GuildIcon, 183, 1, 188, 6)
    guildInfo.static_GuildIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    guildInfo.static_GuildIcon:setRenderTexture(guildInfo.static_GuildIcon:getBaseTexture())
  else
    guildInfo.static_GuildIcon:getBaseTexture():setUV(0, 0, 1, 1)
    guildInfo.static_GuildIcon:setRenderTexture(guildInfo.static_GuildIcon:getBaseTexture())
  end
  guildInfo.text_Building:SetText(tostring(guildWrapper:getTotalSiegeCount(0)))
  guildInfo.text_Vehicle:SetText(tostring(guildWrapper:getTotalSiegeCount(3)))
  guildInfo.text_Member:SetText(tostring(guildWrapper:getTotalSiegeCount(1)))
  guildInfo.text_Die:SetText(tostring(guildWrapper:getTotalSiegeCount(2)))
  local hpPercent = string.format("%.0f", buildingInfo:getRemainHp() / 10000)
  guildInfo.text_CastleHp:SetText(tostring(hpPercent) .. "%")
  contents:SetShow(true)
  function PAGlobal_GuildWarInfo_ListTitleTooltipShow(index)
    local uiControl, name
    if 0 == index then
      name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDWARINFO_ENDURANCETITLE")
    elseif 1 == index then
      name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDWARINFO_OBJECTKILLCOUNTTITLE")
    elseif 2 == index then
      name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDWARINFO_PLAYERKILLCOUNTTITLE")
    elseif 3 == index then
      name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDWARINFO_SERVANTKILLCOUNTTITLE")
    elseif 4 == index then
      name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDWARINFO_DEATHCOUNTTITLE")
    end
    uiControl = guildInfo.title[index]
    TooltipSimple_Show(uiControl, name)
  end
  function PAGlobal_GuildWarInfo_ListTitleTooltipHide()
    TooltipSimple_Hide()
  end
end
function FGlobal_GuildWarInfo_renew_Open()
  if false == Panel_Window_GuildWarInfo:GetShow() and true == ToClient_IsGrowStepOpen(__eGrowStep_guildWarInfo) then
    PAGlobal_GuildWarInfo:UpdateBasicInfo()
    ToClient_RequestSiegeScore(PAGlobal_GuildWarInfo._selectedTerritoryKey)
    if true == PaGlobal_GuildWarInfoSmall_GetShow() then
      PaGlobal_GuildWarInfoSmall_Close()
    end
    Panel_Window_GuildWarInfo:SetShow(true)
  end
end
function FGlobal_GuildWarInfo_renew_ChangeOpen(comboSelectIdx)
  if nil ~= comboSelectIdx then
    PAGlobal_GuildWarInfo._selectedTerritoryKey = comboSelectIdx
  end
  FGlobal_GuildWarInfo_renew_Open()
end
function PAGlobal_GuildWarInfo:UpdateBasicInfo()
  if false == self._initComplete then
    return
  end
  self._isSiegeBeing = isSiegeBeing(self._selectedTerritoryKey)
  local siegeWrapper = ToClient_GetSiegeWrapper(self._selectedTerritoryKey)
  if nil == siegeWrapper then
    return
  end
  if nil ~= ui_tab.btn_territory[self._selectedTerritoryKey] then
    ui_tab.btn_territory[self._selectedTerritoryKey]:SetCheck(true)
  end
  ui_tab.selected_territory_Name:SetText(siegeWrapper:getTerritoryName())
  ui_main.leftGuild_Bg:SetShow(false)
  ui_main.notOccupying:SetShow(false)
  ui_main.rightGuild_Bg_2:SetShow(false)
  ui_main.rightGuild_Bg_3:SetShow(false)
  ui_main.rightGuild_Bg_4:SetShow(false)
  ui_main.rightGuild_Bg_list:SetShow(false)
  ui_main.finish_Bg:SetShow(false)
  for showIndex = 0, 1 do
    self._offenceGuildInfo_2[showIndex].ui_bg:SetShow(false)
  end
  for showIndex = 0, 2 do
    self._offenceGuildInfo_3[showIndex].ui_bg:SetShow(false)
  end
  for showIndex = 0, 3 do
    self._offenceGuildInfo_4[showIndex].ui_bg:SetShow(false)
  end
  if false == self._isSiegeBeing then
    if true == siegeWrapper:doOccupantExist() then
      ui_finishSiege_info.text_Territory_Desc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREE_END", "selectTerritoy", siegeWrapper:getTerritoryName()))
      local guildWrapper = ToClient_GetGuildWrapperByGuildNo(siegeWrapper:getGuildNo())
      local allianceName = ""
      if nil ~= guildWrapper then
        allianceName = guildWrapper:getAllianceName()
      end
      if "" == allianceName then
        ui_finishSiege_info.text_Guild_Desc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREEDESC_END", "getName", siegeWrapper:getGuildName()))
      else
        ui_finishSiege_info.text_Guild_Desc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_ALLIANCE_WARINFOCONTENTS_SETFREEDESC_END", "getName", siegeWrapper:getGuildName()))
      end
    else
      ui_finishSiege_info.text_Territory_Desc:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREE", "selectTerritoy", siegeWrapper:getTerritoryName()))
      ui_finishSiege_info.text_Guild_Desc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREEDESC"))
    end
    ui_main.finish_Bg:SetShow(true)
  else
    local guildCount = ToClient_SiegeGuildCount(self._selectedTerritoryKey)
    self:UpdateGuildScoreMain(siegeWrapper, guildCount)
    if siegeWrapper:doOccupantExist() then
      ui_main.leftGuild_Bg:SetShow(true)
      guildCount = guildCount - 1
    else
      ui_main.notOccupying:SetShow(true)
    end
    if guildCount <= 2 then
      ui_main.rightGuild_Bg_2:SetShow(true)
    elseif guildCount == 3 then
      ui_main.rightGuild_Bg_3:SetShow(true)
    elseif guildCount == 4 then
      ui_main.rightGuild_Bg_4:SetShow(true)
    else
      ui_main.rightGuild_Bg_list:SetShow(true)
    end
  end
end
function PAGlobal_GuildWarInfo:UpdateGuildScoreMain(siegeWrapper, guildCount)
  local rightGuildCount = guildCount
  if siegeWrapper:doOccupantExist() then
    rightGuildCount = rightGuildCount - 1
  end
  local isDefenceGuild = false
  local rightGuildIndex = 0
  self._offenceGuildList:getElementManager():clearKey()
  self._defenceGuildIndex = 999
  for index = 0, guildCount - 1 do
    local guildWrapper = ToClient_SiegeGuildAt(self._selectedTerritoryKey, index)
    local siegeBuildingInfo = ToClient_SiegeGuildBuildingInfoAt(self._selectedTerritoryKey, index)
    if nil == guildWrapper or nil == siegeBuildingInfo then
      return
    end
    if guildWrapper:getGuildNo_s64() == siegeWrapper:getGuildNo() then
      isDefenceGuild = true
      self._defenceGuildNo = guildWrapper:getGuildNo_s64()
      self._defenceGuildIndex = index
    else
      isDefenceGuild = false
      rightGuildIndex = index
      if index > self._defenceGuildIndex then
        rightGuildIndex = rightGuildIndex - 1
      end
      self._offenceGuildNoList[rightGuildIndex] = guildWrapper:getGuildNo_s64()
    end
    if rightGuildCount >= 5 and false == isDefenceGuild then
      self._offenceGuildList:getElementManager():pushKey(toInt64(0, index))
    else
      self:UpdateGuildScoreDetail(isDefenceGuild, rightGuildIndex, rightGuildCount, guildWrapper, siegeBuildingInfo)
    end
  end
end
function PAGlobal_GuildWarInfo:UpdateGuildScoreDetail(isDefence, rightGuildIndex, rightGuildCount, guildWrapper, buildingInfo)
  local guildInfo
  if true == isDefence then
    guildInfo = self._defenceGuildInfo
  elseif rightGuildCount <= 2 then
    guildInfo = self._offenceGuildInfo_2[rightGuildIndex]
  elseif rightGuildCount == 3 then
    guildInfo = self._offenceGuildInfo_3[rightGuildIndex]
  elseif rightGuildCount == 4 then
    guildInfo = self._offenceGuildInfo_4[rightGuildIndex]
  end
  if nil == guildInfo then
    return
  end
  local guildAllianceName = guildWrapper:getAllianceName()
  if "" == guildAllianceName then
    guildInfo.static_GuildName:SetText(guildWrapper:getName())
  else
    guildInfo.static_GuildName:SetText(guildAllianceName)
  end
  if true == isDefence then
    local _posX = 171 - (guildInfo.static_GuildName:GetSizeX() + guildInfo.static_GuildName:GetTextSizeX()) / 2
    guildInfo.static_GuildName:SetPosX(_posX)
  end
  guildInfo.static_MasterName:SetText(guildWrapper:getGuildMasterName())
  local isSet = false
  if true == guildWrapper:isAllianceGuild() then
    isSet = setGuildTextureByAllianceNo(guildWrapper:guildAllianceNo_s64(), guildInfo.static_GuildIcon)
  else
    isSet = setGuildTextureByGuildNo(guildWrapper:getGuildNo_s64(), guildInfo.static_GuildIcon)
  end
  if false == isSet then
    guildInfo.static_GuildIcon:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(guildInfo.static_GuildIcon, 183, 1, 188, 6)
    guildInfo.static_GuildIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    guildInfo.static_GuildIcon:setRenderTexture(guildInfo.static_GuildIcon:getBaseTexture())
  else
    guildInfo.static_GuildIcon:getBaseTexture():setUV(0, 0, 1, 1)
    guildInfo.static_GuildIcon:setRenderTexture(guildInfo.static_GuildIcon:getBaseTexture())
  end
  guildInfo.text_Building:SetText(tostring(guildWrapper:getTotalSiegeCount(0)))
  guildInfo.text_Vehicle:SetText(tostring(guildWrapper:getTotalSiegeCount(3)))
  guildInfo.text_Member:SetText(tostring(guildWrapper:getTotalSiegeCount(1)))
  guildInfo.text_Die:SetText(tostring(guildWrapper:getTotalSiegeCount(2)))
  local hpPercent = buildingInfo:getRemainHp() / 10000
  guildInfo.progress_Castle:SetProgressRate(hpPercent / 100 * 100)
  guildInfo.text_CastleHp:SetText(tostring(hpPercent) .. "%")
  guildInfo.ui_bg:SetShow(true)
end
function regist_GuildWarInfo_renew_ClickedEvent()
  ui_main.btn_Close:addInputEvent("Mouse_LUp", "HandleClicked_GuildWarInfo_renew_Close()")
  ui_main.btn_small:addInputEvent("Mouse_LUp", "HandleEventLUp_GuildWarInfo_renew_SmallWindowOpen()")
  ui_main.btn_small:addInputEvent("Mouse_On", "HandleEventOn_GuildWarInfo_renew_SmallWindow_TooltipShow( true )")
  ui_main.btn_small:addInputEvent("Mouse_Out", "HandleEventOn_GuildWarInfo_renew_SmallWindow_TooltipShow( false )")
  ui_tab.btn_refresh:addInputEvent("Mouse_LUp", "HandleClicked_GuildWarInfo_renew_Refresh()")
  ui_main.btn_refresh:addInputEvent("Mouse_On", "HandleEventOn_GuildWarInfo_renew_Refresh_TooltipShow( true )")
  ui_main.btn_refresh:addInputEvent("Mouse_Out", "HandleEventOn_GuildWarInfo_renew_Refresh_TooltipShow( false )")
  ui_main.btn_refresh:addInputEvent("Mouse_LUp", "HandleClicked_GuildWarInfo_renew_Refresh()")
  for index = 0, 4 do
    ui_tab.btn_territory[index]:addInputEvent("Mouse_LUp", "HandleClicked_GuildWarInfo_renew_Territory(" .. index .. ")")
  end
end
function HandleClicked_GuildWarInfo_renew_Close()
  FGlobal_GuildWarInfo_renew_Close()
end
function HandleEventLUp_GuildWarInfo_renew_SmallWindowOpen()
  local self = PAGlobal_GuildWarInfo
  FGlobal_GuildWarInfo_renew_Close()
  PaGlobal_GuildWarInfoSmall_Open(self._selectedTerritoryKey)
end
function HandleEventOn_GuildWarInfo_renew_SmallWindow_TooltipShow(isShow)
  if false == isShow then
    TooltipSimple_Hide()
    return
  else
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_BIG_TO_SMALL_TOOLTIP_NAME")
    local desc = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_BIG_TO_SMALL_TOOLTIP_DESC")
    local uiControl = ui_main.btn_small
    TooltipSimple_Show(uiControl, name, desc)
  end
end
function HandleEventOn_GuildWarInfo_renew_Refresh_TooltipShow(isShow)
  if false == isShow then
    TooltipSimple_Hide()
    return
  else
    local name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDWARINFO_RELOADBUTTON")
    local uiControl = ui_tab.btn_refresh
    TooltipSimple_Show(uiControl, name)
  end
end
function FGlobal_GuildWarInfo_renew_Close()
  Panel_Window_GuildWarInfo:SetShow(false)
  FGlobal_GuildWarScore_renew_Close()
  TooltipSimple_Hide()
end
function HandleClicked_GuildWarInfo_renew_Territory(territoryKey)
  local self = PAGlobal_GuildWarInfo
  self._selectedTerritoryKey = territoryKey
  self:UpdateBasicInfo()
end
function HandleClicked_GuildWarInfo_renew_TopMember(index)
  HandleClicked_GuildWarInfo_renew_Refresh()
  if 0 == index then
    FGlobal_GuildWarScore_renew_Open(PAGlobal_GuildWarInfo._defenceGuildNo)
  else
    FGlobal_GuildWarScore_renew_Open(PAGlobal_GuildWarInfo._offenceGuildNoList[index - 1])
  end
end
function HandleClicked_GuildWarInfo_renew_Refresh()
  local self = PAGlobal_GuildWarInfo
  if 5 < self._guildWarInfo_renew_UpdateTimer then
    ToClient_RequestSiegeScore(PAGlobal_GuildWarInfo._selectedTerritoryKey)
    self._guildWarInfo_renew_UpdateTimer = 0
  end
end
function FromClient_GuildWarInfoUpdate_renew()
  PAGlobal_GuildWarInfo:UpdateBasicInfo()
  FGlobal_GuildWarScore_renew_Update()
end
function GuildWarInfo_renew_UpdatePerFrame(deltaTime)
  local self = PAGlobal_GuildWarInfo
  self._guildWarInfo_renew_UpdateTimer = self._guildWarInfo_renew_UpdateTimer + deltaTime
  if self._guildWarInfo_renew_UpdateTimer > 30 then
    ToClient_RequestSiegeScore(PAGlobal_GuildWarInfo._selectedTerritoryKey)
    self._guildWarInfo_renew_UpdateTimer = 0
  end
end
function PAGlobal_GuildWarInfo_TitleTooltipShow(uiIndex, tIndex, index)
  local self = PAGlobal_GuildWarInfo
  local uiControl, name
  if 0 == uiIndex then
    uiControl = self._defenceGuildInfo.title[tIndex]
  elseif 1 == uiIndex then
    uiControl = self._offenceGuildInfo_2[index].title[tIndex]
  elseif 2 == uiIndex then
    uiControl = self._offenceGuildInfo_3[index].title[tIndex]
  elseif 3 == uiIndex then
    uiControl = self._offenceGuildInfo_4[index].title[tIndex]
  end
  if 0 == tIndex then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDWARINFO_ENDURANCETITLE")
  elseif 1 == tIndex then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDWARINFO_OBJECTKILLCOUNTTITLE")
  elseif 2 == tIndex then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDWARINFO_PLAYERKILLCOUNTTITLE")
  elseif 3 == tIndex then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDWARINFO_SERVANTKILLCOUNTTITLE")
  elseif 4 == tIndex then
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GUILDWARINFO_DEATHCOUNTTITLE")
  end
  TooltipSimple_Show(uiControl, name)
end
function PAGlobal_GuildWarInfo_TitleTooltipHide()
  TooltipSimple_Hide()
end
registerEvent("Event_SiegeScoreUpdateData", "FromClient_GuildWarInfoUpdate_renew")
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_PAGlobal_GuildWarInfo_renew")
function FromClient_luaLoadComplete_PAGlobal_GuildWarInfo_renew()
  Panel_Window_GuildWarInfo:RegisterUpdateFunc("GuildWarInfo_renew_UpdatePerFrame")
  regist_GuildWarInfo_renew_ClickedEvent()
  PAGlobal_GuildWarInfo:InitDefaultUI()
end

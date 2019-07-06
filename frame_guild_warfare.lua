local UI_TM = CppEnums.TextMode
local UI_color = Defines.Color
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local _constGuildListMaxCount = 150
local _startMemberIndex = 0
GuildWarfareInfoPage = {
  _ui = {
    _frameDefaultBG_Warfare = nil,
    _frame_Warfare = nil,
    _content_Warfare = nil,
    _iconHelper = nil,
    _staticText_CommandCenter = nil,
    _staticText_Tower = nil,
    _staticText_CastleGate = nil,
    _staticText_Help = nil,
    _staticText_Summons = nil,
    _staticText_Installation = nil,
    _staticText_Master = nil,
    _staticText_Commander = nil,
    _staticText_Member = nil,
    _staticText_Death = nil,
    _staticText_KillBySiege = nil,
    _staticText_CharName = nil,
    _txt_Title = nil
  },
  _scrollBar,
  _list = {},
  _initComplete = false,
  ui_Icons = {
    [0] = nil,
    [1] = nil,
    [2] = nil,
    [3] = nil,
    [4] = nil,
    [5] = nil,
    [6] = nil,
    [7] = nil,
    [8] = nil,
    [9] = nil,
    [10] = nil,
    [11] = nil
  }
}
local _selectSortType = 11
local _listSort = {
  command = false,
  tower = false,
  castlegate = false,
  help = false,
  summons = false,
  installation = false,
  master = false,
  commander = false,
  member = false,
  death = false,
  name = false,
  killBySiege = false
}
local tempGuildWarfareList = {}
function Panel_Guild_Warfare_Icon_ToolTip_Func()
end
function Panel_Guild_Warfare_Icon_ToolTip_Show(iconNo, isOn)
  local mouse_posX = getMousePosX()
  local mouse_posY = getMousePosY()
  local panel_posX = GuildWarfareInfoPage._ui._frameDefaultBG_Warfare:GetParentPosX()
  local panel_posY = GuildWarfareInfoPage._ui._frameDefaultBG_Warfare:GetParentPosY()
  local _iconHelper = GuildWarfareInfoPage._ui._iconHelper
  _iconHelper:SetPosX(mouse_posX - panel_posX)
  _iconHelper:SetPosY(mouse_posY - panel_posY + 15)
  if isOn == true then
    if iconNo == 0 then
      _iconHelper:SetShow(true)
      _iconHelper:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TXT_WARFARE_HELP_COMMAND"))
    elseif iconNo == 1 then
      _iconHelper:SetShow(true)
      _iconHelper:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TXT_WARFARE_HELP_TOWER"))
    elseif iconNo == 2 then
      _iconHelper:SetShow(true)
      _iconHelper:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TXT_WARFARE_HELP_DOOR"))
    elseif iconNo == 3 then
      _iconHelper:SetShow(true)
      _iconHelper:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TXT_WARFARE_HELP_HELPER"))
    elseif iconNo == 4 then
      _iconHelper:SetShow(true)
      _iconHelper:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TXT_WARFARE_HELP_SUMMON"))
    elseif iconNo == 5 then
      _iconHelper:SetShow(true)
      _iconHelper:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TXT_WARFARE_HELP_OBJECT"))
    elseif iconNo == 6 then
      _iconHelper:SetShow(true)
      _iconHelper:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TXT_WARFARE_HELP_MASTER"))
    elseif iconNo == 7 then
      _iconHelper:SetShow(true)
      _iconHelper:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TXT_WARFARE_HELP_COMMANDER"))
    elseif iconNo == 8 then
      _iconHelper:SetShow(true)
      _iconHelper:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TXT_WARFARE_HELP_MEMBER"))
    elseif iconNo == 9 then
      _iconHelper:SetShow(true)
      _iconHelper:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TXT_WARFARE_HELP_DEATH"))
    elseif iconNo == 10 then
      _iconHelper:SetShow(false)
    elseif iconNo == 11 then
      _iconHelper:SetShow(true)
      _iconHelper:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_WARFARE_RIDEMACHINE_KILL"))
    end
  else
    _iconHelper:SetShow(false)
  end
end
local frameSizeY = 0
local contentSizeY = 0
function GuildWarfareInfoPage:initialize()
  if nil == Panel_Window_Guild then
    return
  end
  local constStartY = 5
  self._ui._frameDefaultBG_Warfare = UI.getChildControl(Panel_Window_Guild, "Static_Frame_WarfareBG")
  self._ui._iconHelper = UI.getChildControl(Panel_Guild_Warfare, "StaticText_IconHelper")
  self._ui._staticText_CommandCenter = UI.getChildControl(Panel_Guild_Warfare, "StaticText_S_CommandCenter")
  self._ui._staticText_Tower = UI.getChildControl(Panel_Guild_Warfare, "StaticText_S_Tower")
  self._ui._staticText_CastleGate = UI.getChildControl(Panel_Guild_Warfare, "StaticText_S_CastleGate")
  self._ui._staticText_Help = UI.getChildControl(Panel_Guild_Warfare, "StaticText_S_Help")
  self._ui._staticText_Summons = UI.getChildControl(Panel_Guild_Warfare, "StaticText_S_Summons")
  self._ui._staticText_Installation = UI.getChildControl(Panel_Guild_Warfare, "StaticText_S_Installation")
  self._ui._staticText_Master = UI.getChildControl(Panel_Guild_Warfare, "StaticText_S_Master")
  self._ui._staticText_Commander = UI.getChildControl(Panel_Guild_Warfare, "StaticText_S_Commander")
  self._ui._staticText_Member = UI.getChildControl(Panel_Guild_Warfare, "StaticText_S_Member")
  self._ui._staticText_Death = UI.getChildControl(Panel_Guild_Warfare, "StaticText_S_Death")
  self._ui._staticText_KillBySiege = UI.getChildControl(Panel_Guild_Warfare, "StaticText_S_KillBySiege")
  self._ui._staticText_CharName = UI.getChildControl(Panel_Guild_Warfare, "StaticText_S_CharName")
  self._ui._txt_Title = UI.getChildControl(Panel_Guild_Warfare, "StaticText_Title")
  self._ui._frame_Warfare = UI.getChildControl(Panel_Guild_Warfare, "Frame_GuildWarfare")
  self._ui._content_Warfare = UI.getChildControl(self._ui._frame_Warfare, "Frame_1_Content")
  contentSizeY = self._ui._content_Warfare:GetSizeY()
  local copyCharName = UI.getChildControl(self._ui._content_Warfare, "StaticText_C_CharName")
  local copyTower = UI.getChildControl(self._ui._content_Warfare, "StaticText_C_Tower")
  local copyCommandCenter = UI.getChildControl(self._ui._content_Warfare, "StaticText_C_CommandCenter")
  local copyCastleGate = UI.getChildControl(self._ui._content_Warfare, "StaticText_C_CastleGate")
  local copyHelp = UI.getChildControl(self._ui._content_Warfare, "StaticText_C_Help")
  local copySummons = UI.getChildControl(self._ui._content_Warfare, "StaticText_C_Summons")
  local copyInstallation = UI.getChildControl(self._ui._content_Warfare, "StaticText_C_Installation")
  local copyMaster = UI.getChildControl(self._ui._content_Warfare, "StaticText_C_Master")
  local copyCommander = UI.getChildControl(self._ui._content_Warfare, "StaticText_C_Commander")
  local copyMember = UI.getChildControl(self._ui._content_Warfare, "StaticText_C_Member")
  local copyDeath = UI.getChildControl(self._ui._content_Warfare, "StaticText_C_Death")
  local copyKillBySiege = UI.getChildControl(self._ui._content_Warfare, "StaticText_C_KillBySiege")
  self._scrollBar = UI.getChildControl(self._ui._frame_Warfare, "VerticalScroll")
  UIScroll.InputEvent(self._scrollBar, "GuildWarfareMouseScrollEvent")
  self._ui._content_Warfare:addInputEvent("Mouse_UpScroll", "GuildWarfareMouseScrollEvent( true )")
  self._ui._content_Warfare:addInputEvent("Mouse_DownScroll", "GuildWarfareMouseScrollEvent( false )")
  function createWarfareInfo(pIndex)
    local rtGuildWarfareInfo = {}
    rtGuildWarfareInfo._txtCharName = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self._ui._content_Warfare, "StaticText_C_CharName_" .. pIndex)
    rtGuildWarfareInfo._txtTower = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self._ui._content_Warfare, "StaticText_C_Tower_" .. pIndex)
    rtGuildWarfareInfo._txtCommandCenter = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self._ui._content_Warfare, "StaticText_C_CommandCenter_" .. pIndex)
    rtGuildWarfareInfo._txtCastleGate = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self._ui._content_Warfare, "StaticText_C_CastleGate_" .. pIndex)
    rtGuildWarfareInfo._txtHelp = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self._ui._content_Warfare, "StaticText_C_Help_" .. pIndex)
    rtGuildWarfareInfo._txtSummons = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self._ui._content_Warfare, "StaticText_C_Summons_" .. pIndex)
    rtGuildWarfareInfo._txtInstallation = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self._ui._content_Warfare, "StaticText_C_Installation_" .. pIndex)
    rtGuildWarfareInfo._txtMaster = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self._ui._content_Warfare, "StaticText_C_Master_" .. pIndex)
    rtGuildWarfareInfo._txtCommander = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self._ui._content_Warfare, "StaticText_C_Commander_" .. pIndex)
    rtGuildWarfareInfo._txtMember = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self._ui._content_Warfare, "StaticText_C_Member_" .. pIndex)
    rtGuildWarfareInfo._txtDeath = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self._ui._content_Warfare, "StaticText_C_Death_" .. pIndex)
    rtGuildWarfareInfo._txtKillBySiege = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self._ui._content_Warfare, "StaticText_C_KillBySiege_" .. pIndex)
    CopyBaseProperty(copyCharName, rtGuildWarfareInfo._txtCharName)
    CopyBaseProperty(copyTower, rtGuildWarfareInfo._txtTower)
    CopyBaseProperty(copyCommandCenter, rtGuildWarfareInfo._txtCommandCenter)
    CopyBaseProperty(copyCastleGate, rtGuildWarfareInfo._txtCastleGate)
    CopyBaseProperty(copyHelp, rtGuildWarfareInfo._txtHelp)
    CopyBaseProperty(copySummons, rtGuildWarfareInfo._txtSummons)
    CopyBaseProperty(copyInstallation, rtGuildWarfareInfo._txtInstallation)
    CopyBaseProperty(copyMaster, rtGuildWarfareInfo._txtMaster)
    CopyBaseProperty(copyCommander, rtGuildWarfareInfo._txtCommander)
    CopyBaseProperty(copyMember, rtGuildWarfareInfo._txtMember)
    CopyBaseProperty(copyDeath, rtGuildWarfareInfo._txtDeath)
    CopyBaseProperty(copyKillBySiege, rtGuildWarfareInfo._txtKillBySiege)
    rtGuildWarfareInfo._txtCharName:SetPosY(constStartY + pIndex * 25)
    rtGuildWarfareInfo._txtTower:SetPosY(constStartY + pIndex * 25)
    rtGuildWarfareInfo._txtCommandCenter:SetPosY(constStartY + pIndex * 25)
    rtGuildWarfareInfo._txtCastleGate:SetPosY(constStartY + pIndex * 25)
    rtGuildWarfareInfo._txtHelp:SetPosY(constStartY + pIndex * 25)
    rtGuildWarfareInfo._txtSummons:SetPosY(constStartY + pIndex * 25)
    rtGuildWarfareInfo._txtInstallation:SetPosY(constStartY + pIndex * 25)
    rtGuildWarfareInfo._txtMaster:SetPosY(constStartY + pIndex * 25)
    rtGuildWarfareInfo._txtCommander:SetPosY(constStartY + pIndex * 25)
    rtGuildWarfareInfo._txtMember:SetPosY(constStartY + pIndex * 25)
    rtGuildWarfareInfo._txtDeath:SetPosY(constStartY + pIndex * 25)
    rtGuildWarfareInfo._txtKillBySiege:SetPosY(constStartY + pIndex * 25)
    rtGuildWarfareInfo._txtCharName:SetIgnore(false)
    rtGuildWarfareInfo._txtTower:SetIgnore(false)
    rtGuildWarfareInfo._txtCommandCenter:SetIgnore(false)
    rtGuildWarfareInfo._txtCastleGate:SetIgnore(false)
    rtGuildWarfareInfo._txtHelp:SetIgnore(false)
    rtGuildWarfareInfo._txtSummons:SetIgnore(false)
    rtGuildWarfareInfo._txtInstallation:SetIgnore(false)
    rtGuildWarfareInfo._txtMaster:SetIgnore(false)
    rtGuildWarfareInfo._txtCommander:SetIgnore(false)
    rtGuildWarfareInfo._txtMember:SetIgnore(false)
    rtGuildWarfareInfo._txtDeath:SetIgnore(false)
    rtGuildWarfareInfo._txtKillBySiege:SetIgnore(false)
    rtGuildWarfareInfo._txtCharName:addInputEvent("Mouse_UpScroll", "GuildWarfareMouseScrollEvent(true)")
    rtGuildWarfareInfo._txtTower:addInputEvent("Mouse_UpScroll", "GuildWarfareMouseScrollEvent(true)")
    rtGuildWarfareInfo._txtCommandCenter:addInputEvent("Mouse_UpScroll", "GuildWarfareMouseScrollEvent(true)")
    rtGuildWarfareInfo._txtCastleGate:addInputEvent("Mouse_UpScroll", "GuildWarfareMouseScrollEvent(true)")
    rtGuildWarfareInfo._txtHelp:addInputEvent("Mouse_UpScroll", "GuildWarfareMouseScrollEvent(true)")
    rtGuildWarfareInfo._txtSummons:addInputEvent("Mouse_UpScroll", "GuildWarfareMouseScrollEvent(true)")
    rtGuildWarfareInfo._txtInstallation:addInputEvent("Mouse_UpScroll", "GuildWarfareMouseScrollEvent(true)")
    rtGuildWarfareInfo._txtMaster:addInputEvent("Mouse_UpScroll", "GuildWarfareMouseScrollEvent(true)")
    rtGuildWarfareInfo._txtCommander:addInputEvent("Mouse_UpScroll", "GuildWarfareMouseScrollEvent(true)")
    rtGuildWarfareInfo._txtMember:addInputEvent("Mouse_UpScroll", "GuildWarfareMouseScrollEvent(true)")
    rtGuildWarfareInfo._txtDeath:addInputEvent("Mouse_UpScroll", "GuildWarfareMouseScrollEvent(true)")
    rtGuildWarfareInfo._txtKillBySiege:addInputEvent("Mouse_UpScroll", "GuildWarfareMouseScrollEvent(true)")
    rtGuildWarfareInfo._txtCharName:addInputEvent("Mouse_DownScroll", "GuildWarfareMouseScrollEvent(false)")
    rtGuildWarfareInfo._txtTower:addInputEvent("Mouse_DownScroll", "GuildWarfareMouseScrollEvent(false)")
    rtGuildWarfareInfo._txtCommandCenter:addInputEvent("Mouse_DownScroll", "GuildWarfareMouseScrollEvent(false)")
    rtGuildWarfareInfo._txtCastleGate:addInputEvent("Mouse_DownScroll", "GuildWarfareMouseScrollEvent(false)")
    rtGuildWarfareInfo._txtHelp:addInputEvent("Mouse_DownScroll", "GuildWarfareMouseScrollEvent(false)")
    rtGuildWarfareInfo._txtSummons:addInputEvent("Mouse_DownScroll", "GuildWarfareMouseScrollEvent(false)")
    rtGuildWarfareInfo._txtInstallation:addInputEvent("Mouse_DownScroll", "GuildWarfareMouseScrollEvent(false)")
    rtGuildWarfareInfo._txtMaster:addInputEvent("Mouse_DownScroll", "GuildWarfareMouseScrollEvent(false)")
    rtGuildWarfareInfo._txtCommander:addInputEvent("Mouse_DownScroll", "GuildWarfareMouseScrollEvent(false)")
    rtGuildWarfareInfo._txtMember:addInputEvent("Mouse_DownScroll", "GuildWarfareMouseScrollEvent(false)")
    rtGuildWarfareInfo._txtDeath:addInputEvent("Mouse_DownScroll", "GuildWarfareMouseScrollEvent(false)")
    rtGuildWarfareInfo._txtKillBySiege:addInputEvent("Mouse_DownScroll", "GuildWarfareMouseScrollEvent(false)")
    function rtGuildWarfareInfo:SetShow(isShow)
      rtGuildWarfareInfo._txtCharName:SetShow(isShow)
      rtGuildWarfareInfo._txtTower:SetShow(isShow)
      rtGuildWarfareInfo._txtCommandCenter:SetShow(isShow)
      rtGuildWarfareInfo._txtCastleGate:SetShow(isShow)
      rtGuildWarfareInfo._txtHelp:SetShow(isShow)
      rtGuildWarfareInfo._txtSummons:SetShow(isShow)
      rtGuildWarfareInfo._txtInstallation:SetShow(isShow)
      rtGuildWarfareInfo._txtMaster:SetShow(isShow)
      rtGuildWarfareInfo._txtCommander:SetShow(isShow)
      rtGuildWarfareInfo._txtMember:SetShow(isShow)
      rtGuildWarfareInfo._txtDeath:SetShow(isShow)
      rtGuildWarfareInfo._txtKillBySiege:SetShow(isShow)
      if _ContentsGroup_NewSiegeRule then
        rtGuildWarfareInfo._txtHelp:SetShow(false)
        rtGuildWarfareInfo._txtMaster:SetShow(false)
        rtGuildWarfareInfo._txtCommander:SetShow(false)
      end
    end
    return rtGuildWarfareInfo
  end
  for index = 0, _constGuildListMaxCount - 1 do
    self._list[index] = createWarfareInfo(index)
  end
  UI.deleteControl(copyCharName)
  UI.deleteControl(copyTower)
  UI.deleteControl(copyCommandCenter)
  UI.deleteControl(copyCastleGate)
  UI.deleteControl(copyHelp)
  UI.deleteControl(copySummons)
  UI.deleteControl(copyInstallation)
  UI.deleteControl(copyMaster)
  UI.deleteControl(copyCommander)
  UI.deleteControl(copyMember)
  UI.deleteControl(copyDeath)
  UI.deleteControl(copyKillBySiege)
  copyCharName, copyTower, copyCommandCenter, copyCastleGate, copyHelp, copySummons, copyInstallation, copyMaster, copyCommander, copyMember, copyDeath, copyKillBySiege = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
  frameSizeY = self._ui._frame_Warfare:GetSizeY()
  self._ui._frame_Warfare:UpdateContentScroll()
  self._ui._frame_Warfare:UpdateContentPos()
  self.area_WarfareTitle = UI.getChildControl(Panel_Guild_Warfare, "Static_Warfare_BG")
  self.ui_Icons = {
    [0] = UI.getChildControl(self.area_WarfareTitle, "Static_M_CommandCenter"),
    [1] = UI.getChildControl(self.area_WarfareTitle, "Static_M_Tower"),
    [2] = UI.getChildControl(self.area_WarfareTitle, "Static_M_CastleGate"),
    [3] = UI.getChildControl(self.area_WarfareTitle, "Static_M_Help"),
    [4] = UI.getChildControl(self.area_WarfareTitle, "Static_M_Summons"),
    [5] = UI.getChildControl(self.area_WarfareTitle, "Static_M_Installation"),
    [6] = UI.getChildControl(self.area_WarfareTitle, "Static_M_Master"),
    [7] = UI.getChildControl(self.area_WarfareTitle, "Static_M_Commander"),
    [8] = UI.getChildControl(self.area_WarfareTitle, "Static_M_Member"),
    [9] = UI.getChildControl(self.area_WarfareTitle, "Static_M_Death"),
    [10] = UI.getChildControl(self.area_WarfareTitle, "StaticText_M_CharName"),
    [11] = UI.getChildControl(self.area_WarfareTitle, "Static_M_KillBySiege")
  }
  self.ui_Icons[10]:SetText(self.ui_Icons[10]:GetText())
  self.ui_Icons[10]:SetSize(self.ui_Icons[10]:GetTextSizeX(), self.ui_Icons[10]:GetSizeY())
  self.ui_Icons[10]:SetPosX(165 - self.ui_Icons[10]:GetTextSizeX() / 2)
  for iconidx = 0, 11 do
    self.ui_Icons[iconidx]:addInputEvent("Mouse_LUp", "HandleClicked_GuildWarfareListSort( " .. iconidx .. ")")
    self.ui_Icons[iconidx]:addInputEvent("Mouse_On", "Panel_Guild_Warfare_Icon_ToolTip_Show(" .. iconidx .. ", true)")
    self.ui_Icons[iconidx]:addInputEvent("Mouse_Out", "Panel_Guild_Warfare_Icon_ToolTip_Show(" .. iconidx .. ", false)")
  end
  self._ui._frameDefaultBG_Warfare:MoveChilds(self._ui._frameDefaultBG_Warfare:GetID(), Panel_Guild_Warfare)
  self._ui._txt_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILD_TEXT_GUILDWARFAREINFO"))
  self._initComplete = true
end
function GuildWarfareMouseScrollEvent(isUpScroll)
  local guildWrapper = ToClient_GetMyGuildInfoWrapper()
  if nil == guildWrapper then
    return
  end
  local memberCount = guildWrapper:getMemberCount()
  local volunteerCount = guildWrapper:getVolunteerMemberCount()
  UIScroll.ScrollEvent(GuildWarfareInfoPage._scrollBar, isUpScroll, memberCount + volunteerCount, memberCount + volunteerCount, 0, 1)
  GuildWarfareInfoPage:UpdateData()
end
function GuildWarfareInfoPage:TitleLineReset()
  if nil == Panel_Window_Guild then
    return
  end
  self._ui._staticText_CommandCenter:SetShow(false)
  self._ui._staticText_Tower:SetShow(false)
  self._ui._staticText_CastleGate:SetShow(false)
  self._ui._staticText_Help:SetShow(false)
  self._ui._staticText_Summons:SetShow(false)
  self._ui._staticText_Installation:SetShow(false)
  self._ui._staticText_Master:SetShow(false)
  self._ui._staticText_Commander:SetShow(false)
  self._ui._staticText_Member:SetShow(false)
  self._ui._staticText_Death:SetShow(false)
  self._ui._staticText_KillBySiege:SetShow(false)
  self._ui._staticText_CharName:SetShow(false)
end
function GuildWarfareInfoPage:SetGuildList()
  local myGuildWarfareListInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildWarfareListInfo then
    return
  end
  local memberCount = myGuildWarfareListInfo:getMemberCount()
  local volunteerCount = myGuildWarfareListInfo:getVolunteerMemberCount()
  for index = 1, memberCount do
    local myGuildMemberInfo = myGuildWarfareListInfo:getMember(index - 1)
    if nil ~= myGuildMemberInfo then
      tempGuildWarfareList[index] = {
        idx = index - 1,
        command = myGuildMemberInfo:commandPostCount(),
        tower = myGuildMemberInfo:towerCount(),
        castlegate = myGuildMemberInfo:gateCount(),
        help = myGuildMemberInfo:assistCount(),
        summons = myGuildMemberInfo:summonedCount(),
        installation = myGuildMemberInfo:obstacleCount(),
        master = myGuildMemberInfo:guildMasterCount(),
        commander = myGuildMemberInfo:squadLeaderCount(),
        member = myGuildMemberInfo:squadMemberCount(),
        death = myGuildMemberInfo:deathCount(),
        name = myGuildMemberInfo:getName(),
        killBySiege = myGuildMemberInfo:killBySiegeWeaponCount(),
        isVolunteer = false
      }
      if _ContentsGroup_NewSiegeRule then
        local killCount = myGuildMemberInfo:guildMasterCount() + myGuildMemberInfo:squadLeaderCount() + myGuildMemberInfo:squadMemberCount()
        tempGuildWarfareList[index].member = killCount
      end
    end
  end
  for index = 1, volunteerCount do
    local myGuildVolunteerMemberInfo = myGuildWarfareListInfo:getVolunteerMember(index - 1)
    if nil ~= myGuildVolunteerMemberInfo then
      tempGuildWarfareList[memberCount + index] = {
        idx = index - 1,
        command = myGuildVolunteerMemberInfo:commandPostCount(),
        tower = myGuildVolunteerMemberInfo:towerCount(),
        castlegate = myGuildVolunteerMemberInfo:gateCount(),
        help = myGuildVolunteerMemberInfo:assistCount(),
        summons = myGuildVolunteerMemberInfo:summonedCount(),
        installation = myGuildVolunteerMemberInfo:obstacleCount(),
        master = myGuildVolunteerMemberInfo:guildMasterCount(),
        commander = myGuildVolunteerMemberInfo:squadLeaderCount(),
        member = myGuildVolunteerMemberInfo:squadMemberCount(),
        death = myGuildVolunteerMemberInfo:deathCount(),
        name = myGuildVolunteerMemberInfo:getName(),
        killBySiege = myGuildVolunteerMemberInfo:killBySiegeWeaponCount(),
        isVolunteer = true
      }
      if _ContentsGroup_NewSiegeRule then
        local killCount = myGuildVolunteerMemberInfo:guildMasterCount() + myGuildVolunteerMemberInfo:squadLeaderCount() + myGuildVolunteerMemberInfo:squadMemberCount()
        tempGuildWarfareList[memberCount + index].member = killCount
      end
    end
  end
end
local function guildListCompareCommandCenter(w1, w2)
  if true == _listSort.command then
    if w1.command < w2.command then
      return true
    end
  elseif w2.command < w1.command then
    return true
  end
end
local function guildListCompareTower(w1, w2)
  if true == _listSort.tower then
    if w2.tower < w1.tower then
      return true
    end
  elseif w1.tower < w2.tower then
    return true
  end
end
local function guildListCompareCastleGate(w1, w2)
  if true == _listSort.castlegate then
    if w2.castlegate < w1.castlegate then
      return true
    end
  elseif w1.castlegate < w2.castlegate then
    return true
  end
end
local function guildListCompareHelp(w1, w2)
  if true == _listSort.help then
    if w1.help < w2.help then
      return true
    end
  elseif w2.help < w1.help then
    return true
  end
end
local function guildListCompareSummons(w1, w2)
  if true == _listSort.summons then
    if w2.summons < w1.summons then
      return true
    end
  elseif w1.summons < w2.summons then
    return true
  end
end
local function guildListCompareInstallation(w1, w2)
  if true == _listSort.installation then
    if w2.installation < w1.installation then
      return true
    end
  elseif w1.installation < w2.installation then
    return true
  end
end
local function guildListCompareMaster(w1, w2)
  if true == _listSort.master then
    if w2.master < w1.master then
      return true
    end
  elseif w1.master < w2.master then
    return true
  end
end
local function guildListCompareCommander(w1, w2)
  if true == _listSort.commander then
    if w2.commander < w1.commander then
      return true
    end
  elseif w1.commander < w2.commander then
    return true
  end
end
local function guildListCompareMember(w1, w2)
  if true == _listSort.member then
    if w2.member < w1.member then
      return true
    end
  elseif w1.member < w2.member then
    return true
  end
end
local function guildListCompareDeath(w1, w2)
  if true == _listSort.death then
    if w2.death < w1.death then
      return true
    end
  elseif w1.death < w2.death then
    return true
  end
end
local function guildListCompareCharName(w1, w2)
  if true == _listSort.name then
    if w2.name < w1.name then
      return true
    end
  elseif w1.name < w2.name then
    return true
  end
end
local function guildListCompareKillBySiege(w1, w2)
  if true == _listSort.killBySiege then
    if w2.killBySiege < w1.killBySiege then
      return true
    end
  elseif w1.killBySiege < w2.killBySiege then
    return true
  end
end
function HandleClicked_GuildWarfareListSort(sortType)
  if nil == Panel_Window_Guild then
    return
  end
  local self = GuildWarfareInfoPage
  _selectSortType = sortType
  GuildWarfareInfoPage:TitleLineReset()
  local staticText_CommandCenter = GuildWarfareInfoPage._ui._staticText_CommandCenter
  local staticText_Tower = GuildWarfareInfoPage._ui._staticText_Tower
  local staticText_CastleGate = GuildWarfareInfoPage._ui._staticText_CastleGate
  local staticText_Help = GuildWarfareInfoPage._ui._staticText_Help
  local staticText_Summons = GuildWarfareInfoPage._ui._staticText_Summons
  local staticText_Installation = GuildWarfareInfoPage._ui._staticText_Installation
  local staticText_Master = GuildWarfareInfoPage._ui._staticText_Master
  local staticText_Commander = GuildWarfareInfoPage._ui._staticText_Commander
  local staticText_Member = GuildWarfareInfoPage._ui._staticText_Member
  local staticText_Death = GuildWarfareInfoPage._ui._staticText_Death
  local staticText_KillBySiege = GuildWarfareInfoPage._ui._staticText_KillBySiege
  local staticText_CharName = GuildWarfareInfoPage._ui._staticText_CharName
  if 0 == sortType then
    if false == _listSort.command then
      staticText_CommandCenter:SetText("\226\150\178")
      _listSort.command = true
    else
      staticText_CommandCenter:SetText("\226\150\188")
      _listSort.command = false
    end
    staticText_CommandCenter:SetShow(true)
    table.sort(tempGuildWarfareList, guildListCompareCommandCenter)
  elseif 1 == sortType then
    if false == _listSort.tower then
      staticText_Tower:SetText("\226\150\178")
      _listSort.tower = true
    else
      staticText_Tower:SetText("\226\150\188")
      _listSort.tower = false
    end
    staticText_Tower:SetShow(true)
    table.sort(tempGuildWarfareList, guildListCompareTower)
  elseif 2 == sortType then
    if false == _listSort.castlegate then
      staticText_CastleGate:SetText("\226\150\178")
      _listSort.castlegate = true
    else
      staticText_CastleGate:SetText("\226\150\188")
      _listSort.castlegate = false
    end
    staticText_CastleGate:SetShow(true)
    table.sort(tempGuildWarfareList, guildListCompareCastleGate)
  elseif 3 == sortType then
    if false == _listSort.help then
      staticText_Help:SetText("\226\150\178")
      _listSort.help = true
    else
      staticText_Help:SetText("\226\150\188")
      _listSort.help = false
    end
    staticText_Help:SetShow(true)
    table.sort(tempGuildWarfareList, guildListCompareHelp)
  elseif 4 == sortType then
    if false == _listSort.summons then
      staticText_Summons:SetText("\226\150\178")
      _listSort.summons = true
    else
      staticText_Summons:SetText("\226\150\188")
      _listSort.summons = false
    end
    staticText_Summons:SetShow(true)
    table.sort(tempGuildWarfareList, guildListCompareSummons)
  elseif 5 == sortType then
    if false == _listSort.installation then
      staticText_Installation:SetText("\226\150\178")
      _listSort.installation = true
    else
      staticText_Installation:SetText("\226\150\188")
      _listSort.installation = false
    end
    staticText_Installation:SetShow(true)
    table.sort(tempGuildWarfareList, guildListCompareInstallation)
  elseif 6 == sortType then
    if false == _listSort.master then
      staticText_Master:SetText("\226\150\178")
      _listSort.master = true
    else
      staticText_Master:SetText("\226\150\188")
      _listSort.master = false
    end
    staticText_Master:SetShow(true)
    table.sort(tempGuildWarfareList, guildListCompareMaster)
  elseif 7 == sortType then
    if false == _listSort.commander then
      staticText_Commander:SetText("\226\150\178")
      _listSort.commander = true
    else
      staticText_Commander:SetText("\226\150\188")
      _listSort.commander = false
    end
    staticText_Commander:SetShow(true)
    table.sort(tempGuildWarfareList, guildListCompareCommander)
  elseif 8 == sortType then
    if false == _listSort.member then
      staticText_Member:SetText("\226\150\178")
      _listSort.member = true
    else
      staticText_Member:SetText("\226\150\188")
      _listSort.member = false
    end
    staticText_Member:SetShow(true)
    table.sort(tempGuildWarfareList, guildListCompareMember)
  elseif 9 == sortType then
    if false == _listSort.death then
      staticText_Death:SetText("\226\150\178")
      _listSort.death = true
    else
      staticText_Death:SetText("\226\150\188")
      _listSort.death = false
    end
    staticText_Death:SetShow(true)
    table.sort(tempGuildWarfareList, guildListCompareDeath)
  elseif 10 == sortType then
    if false == _listSort.name then
      staticText_CharName:SetText("\226\150\178")
      _listSort.name = true
    else
      staticText_CharName:SetText("\226\150\188")
      _listSort.name = false
    end
    staticText_CharName:SetShow(true)
    staticText_CharName:SetPosX(self.ui_Icons[10]:GetPosX() + self.ui_Icons[10]:GetTextSizeX())
    table.sort(tempGuildWarfareList, guildListCompareCharName)
  elseif 11 == sortType then
    if false == _listSort.killBySiege then
      staticText_KillBySiege:SetText("\226\150\178")
      _listSort.killBySiege = true
    else
      staticText_KillBySiege:SetText("\226\150\188")
      _listSort.killBySiege = false
    end
    staticText_KillBySiege:SetShow(true)
    table.sort(tempGuildWarfareList, guildListCompareKillBySiege)
  end
  GuildWarfareInfoPage:UpdateData()
end
function GuildWarfareInfoPage:GuildListSortSet()
  if nil == Panel_Window_Guild then
    return
  end
  GuildWarfareInfoPage:TitleLineReset()
  self._ui._staticText_CharName:SetText("\226\150\178")
  _listSort.name = true
  self._ui._staticText_CharName:SetShow(true)
  table.sort(tempGuildWarfareList, guildListCompareCharName)
  self._ui._staticText_CharName:SetPosX(self.ui_Icons[10]:GetPosX() + self.ui_Icons[10]:GetTextSizeX())
end
function GuildWarfareInfoPage:updateSort()
  if 0 == _selectSortType then
    table.sort(tempGuildWarfareList, guildListCompareCommandCenter)
  elseif 1 == _selectSortType then
    table.sort(tempGuildWarfareList, guildListCompareTower)
  elseif 2 == _selectSortType then
    table.sort(tempGuildWarfareList, guildListCompareCastleGate)
  elseif 3 == _selectSortType then
    table.sort(tempGuildWarfareList, guildListCompareHelp)
  elseif 4 == _selectSortType then
    table.sort(tempGuildWarfareList, guildListCompareSummons)
  elseif 5 == _selectSortType then
    table.sort(tempGuildWarfareList, guildListCompareInstallation)
  elseif 6 == _selectSortType then
    table.sort(tempGuildWarfareList, guildListCompareMaster)
  elseif 7 == _selectSortType then
    table.sort(tempGuildWarfareList, guildListCompareCommander)
  elseif 8 == _selectSortType then
    table.sort(tempGuildWarfareList, guildListCompareMember)
  elseif 9 == _selectSortType then
    table.sort(tempGuildWarfareList, guildListCompareDeath)
  elseif 10 == _selectSortType then
    table.sort(tempGuildWarfareList, guildListCompareCharName)
  elseif 11 == _selectSortType then
    table.sort(tempGuildWarfareList, guildListCompareKillBySiege)
  end
end
function GuildWarfareInfoPage:UpdateData()
  if nil == Panel_Window_Guild then
    return
  end
  if false == self._initComplete then
    return
  end
  GuildWarfareInfoPage:SetGuildList()
  GuildWarfareInfoPage:updateSort()
  local myGuildInfo = ToClient_GetMyGuildInfoWrapper()
  if nil == myGuildInfo then
    return
  end
  contentSizeY = 0
  for index = 0, _constGuildListMaxCount - 1 do
    self._list[index]:SetShow(false)
  end
  local memberCount = myGuildInfo:getMemberCount()
  local volunteerCount = myGuildInfo:getVolunteerMemberCount()
  for index = 0, memberCount + volunteerCount - 1 do
    local dataIdx = tempGuildWarfareList[index + 1].idx
    local isVolunteer = tempGuildWarfareList[index + 1].isVolunteer
    local myGuildMemberInfo
    if false == isVolunteer then
      myGuildMemberInfo = myGuildInfo:getMember(dataIdx)
    elseif true == isVolunteer then
      myGuildMemberInfo = myGuildInfo:getVolunteerMember(dataIdx)
    end
    if nil == myGuildMemberInfo then
      return
    end
    self._list[index]._txtCommandCenter:SetText(tempGuildWarfareList[index + 1].command)
    self._list[index]._txtTower:SetText(tempGuildWarfareList[index + 1].tower)
    self._list[index]._txtCastleGate:SetText(tempGuildWarfareList[index + 1].castlegate)
    self._list[index]._txtHelp:SetText(tempGuildWarfareList[index + 1].help)
    self._list[index]._txtSummons:SetText(tempGuildWarfareList[index + 1].summons)
    self._list[index]._txtInstallation:SetText(tempGuildWarfareList[index + 1].installation)
    self._list[index]._txtMaster:SetText(tempGuildWarfareList[index + 1].master)
    self._list[index]._txtCommander:SetText(tempGuildWarfareList[index + 1].commander)
    self._list[index]._txtMember:SetText(tempGuildWarfareList[index + 1].member)
    self._list[index]._txtDeath:SetText(tempGuildWarfareList[index + 1].death)
    self._list[index]._txtKillBySiege:SetText(tempGuildWarfareList[index + 1].killBySiege)
    local isActivity = self:activityCheck(myGuildMemberInfo)
    if true == myGuildMemberInfo:isOnline() and (false == myGuildMemberInfo:isGhostMode() or true == isActivity) then
      if myGuildMemberInfo:isSelf() then
        self._list[index]._txtCharName:SetFontColor(UI_color.C_FFEF9C7F)
      else
        self._list[index]._txtCharName:SetFontColor(UI_color.C_FFC4BEBE)
      end
      self._list[index]._txtCharName:SetText(myGuildMemberInfo:getName() .. " (" .. myGuildMemberInfo:getCharacterName() .. ")")
      self._list[index]._txtCommandCenter:SetFontColor(UI_color.C_FFC4BEBE)
      self._list[index]._txtTower:SetFontColor(UI_color.C_FFC4BEBE)
      self._list[index]._txtCastleGate:SetFontColor(UI_color.C_FFC4BEBE)
      self._list[index]._txtHelp:SetFontColor(UI_color.C_FFC4BEBE)
      self._list[index]._txtSummons:SetFontColor(UI_color.C_FFC4BEBE)
      self._list[index]._txtInstallation:SetFontColor(UI_color.C_FFC4BEBE)
      self._list[index]._txtMaster:SetFontColor(UI_color.C_FFC4BEBE)
      self._list[index]._txtCommander:SetFontColor(UI_color.C_FFC4BEBE)
      self._list[index]._txtMember:SetFontColor(UI_color.C_FFC4BEBE)
      self._list[index]._txtDeath:SetFontColor(UI_color.C_FFC4BEBE)
      self._list[index]._txtKillBySiege:SetFontColor(UI_color.C_FFC4BEBE)
    else
      self._list[index]._txtCharName:SetText(myGuildMemberInfo:getName() .. " ( - )")
      self._list[index]._txtCharName:SetFontColor(UI_color.C_FF515151)
      self._list[index]._txtCommandCenter:SetFontColor(UI_color.C_FF515151)
      self._list[index]._txtTower:SetFontColor(UI_color.C_FF515151)
      self._list[index]._txtCastleGate:SetFontColor(UI_color.C_FF515151)
      self._list[index]._txtHelp:SetFontColor(UI_color.C_FF515151)
      self._list[index]._txtSummons:SetFontColor(UI_color.C_FF515151)
      self._list[index]._txtInstallation:SetFontColor(UI_color.C_FF515151)
      self._list[index]._txtMaster:SetFontColor(UI_color.C_FF515151)
      self._list[index]._txtCommander:SetFontColor(UI_color.C_FF515151)
      self._list[index]._txtMember:SetFontColor(UI_color.C_FF515151)
      self._list[index]._txtDeath:SetFontColor(UI_color.C_FF515151)
      self._list[index]._txtKillBySiege:SetFontColor(UI_color.C_FF515151)
    end
    if _ContentsGroup_NewSiegeRule then
      local killCount = myGuildMemberInfo:guildMasterCount() + myGuildMemberInfo:squadLeaderCount() + myGuildMemberInfo:squadMemberCount()
      self._list[index]._txtMember:SetText(killCount)
    end
    contentSizeY = contentSizeY + self._list[index]._txtCharName:GetSizeY() + 2
    self._ui._content_Warfare:SetSize(self._ui._content_Warfare:GetSizeX(), contentSizeY)
  end
  for index = 0, _constGuildListMaxCount - 1 do
    if _startMemberIndex + index < memberCount + volunteerCount then
      self._list[index]:SetShow(true)
    else
      self._list[index]:SetShow(false)
    end
  end
  if frameSizeY >= contentSizeY then
    self._scrollBar:SetShow(false)
  else
    self._scrollBar:SetShow(true)
  end
  self._ui._frame_Warfare:UpdateContentScroll()
  self._ui._frame_Warfare:UpdateContentPos()
end
function GuildWarfareInfoPage:activityCheck(memberInfo)
  local value = 0
  value = value + memberInfo:commandPostCount()
  value = value + memberInfo:towerCount()
  value = value + memberInfo:gateCount()
  value = value + memberInfo:assistCount()
  value = value + memberInfo:summonedCount()
  value = value + memberInfo:obstacleCount()
  value = value + memberInfo:guildMasterCount()
  value = value + memberInfo:squadLeaderCount()
  value = value + memberInfo:squadMemberCount()
  value = value + memberInfo:deathCount()
  value = value + memberInfo:killBySiegeWeaponCount()
  return value > 0
end
function GuildWarfareInfoPage:Show()
  if nil == Panel_Window_Guild then
    return
  end
  self._ui._frameDefaultBG_Warfare:SetShow(true)
  self._scrollBar:SetControlPos(0)
  _selectSortType = 10
  self:GuildListSortSet()
  self:UpdateData()
end
function GuildWarfareInfoPage:Hide()
  if nil == Panel_Window_Guild then
    return
  end
  if true == self._ui._frameDefaultBG_Warfare:GetShow() then
    self._ui._frameDefaultBG_Warfare:SetShow(false)
  end
end
function GuildWarfareInfoPage:registEventHandler()
  registerEvent("Event_SiegeScoreUpdateData", "FromClient_GuildWarfareInfoUpdate")
end
function FromClient_GuildWarfareInfoUpdate()
  GuildWarfareInfoPage:UpdateData()
end
function FromClient_GuildWarfare_Init()
  PaGlobal_GuildWarfare_Init()
  GuildWarfareInfoPage:registEventHandler()
end
function PaGlobal_GuildWarfare_Init()
  GuildWarfareInfoPage:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_GuildWarfare_Init")

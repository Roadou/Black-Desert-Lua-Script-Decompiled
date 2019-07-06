local _panel = Panel_Window_GuildWarInfo_Renew
local GuildWarInfo = {
  _ui = {
    stc_titleBar = UI.getChildControl(_panel, "Static_TitleBar"),
    txt_title = nil,
    stc_tabGroup = UI.getChildControl(_panel, "Static_TabGroup"),
    rdo_template = nil,
    rdo_territories = nil,
    stc_defGuildBG = UI.getChildControl(_panel, "Static_TopDesc"),
    stc_territorySymbol = nil,
    stc_emptyBG = UI.getChildControl(_panel, "Static_TopDescEmpty"),
    stc_emptyTerritorySymbol = nil,
    stc_emptyTerritory = nil,
    stc_emptyTerritoryDesc = nil,
    stc_peaceBG = UI.getChildControl(_panel, "Static_NotSiege"),
    stc_peaceTerritorySymbol = nil,
    txt_peaceTerritoryName = nil,
    txt_peaceDescSub = nil,
    txt_peaceTerritoryOwner = nil,
    stc_innerBG = UI.getChildControl(_panel, "Static_innerBG"),
    list2_offenceGuilds = nil,
    stc_bottomBG = UI.getChildControl(_panel, "Static_KeyGuideGroup"),
    txt_keyGuideB = nil,
    txt_keyGuideA = nil,
    gSlot_defGuild = nil,
    gSlot_offGuild = nil
  },
  _selectedTerritoryKey = 0,
  _territoryKeyTable = nil,
  _territoryCount = 0,
  _offenceGuildIndexTable = {},
  _offenceGuildNoTable = {},
  _defenceGuildNo = nil,
  _defenceGuildIndex = nil,
  _guildNo64Table = {},
  _guildWarInfo_timer = 0
}
local SCORE_TYPE = {
  DESTROY = 1,
  KILL = 2,
  DEATH = 3,
  SERVANT = 4
}
local GuildSlot = {}
GuildSlot.__index = GuildSlot
function GuildSlot.new(gSlot, control, isDefenceGuild)
  if nil == gSlot or nil == control then
    _PA_LOG("\235\176\149\235\178\148\236\164\128", "GuildSlot.new return because nil param")
    return
  end
  setmetatable(gSlot, GuildSlot)
  gSlot.isDefGuild = isDefenceGuild
  gSlot.bg = control
  gSlot.stc_guildEmblemBG = UI.getChildControl(control, "Static_GuildEmblemBg")
  gSlot.txt_guildName = UI.getChildControl(gSlot.stc_guildEmblemBG, "StaticText_GuildName")
  gSlot.stc_guildIconBG = UI.getChildControl(gSlot.stc_guildEmblemBG, "Static_GuildIconBG")
  gSlot.stc_guildIcon = UI.getChildControl(gSlot.stc_guildEmblemBG, "Static_GuildIcon")
  gSlot.stc_progressBG = UI.getChildControl(control, "Static_ProgressBG")
  gSlot.txt_percentage = UI.getChildControl(gSlot.stc_progressBG, "StaticText_Percentage")
  gSlot.progress_durability = UI.getChildControl(gSlot.stc_progressBG, "Progress2_1")
  gSlot.txt_scores = {}
  if isDefenceGuild then
    gSlot.txt_guildMasterName = UI.getChildControl(gSlot.stc_guildEmblemBG, "StaticText_MasterName")
    gSlot.txt_scores[SCORE_TYPE.DESTROY] = UI.getChildControl(control, "StaticText_ScoreVal1")
    gSlot.txt_scores[SCORE_TYPE.KILL] = UI.getChildControl(control, "StaticText_ScoreVal2")
    gSlot.txt_scores[SCORE_TYPE.DEATH] = UI.getChildControl(control, "StaticText_ScoreVal3")
    gSlot.txt_scores[SCORE_TYPE.SERVANT] = UI.getChildControl(control, "StaticText_ScoreVal4")
  else
    for ii = 1, 4 do
      local scoreBG = UI.getChildControl(control, "Static_ScoreBG" .. ii)
      gSlot.txt_scores[ii] = UI.getChildControl(scoreBG, "StaticText_Val")
    end
  end
  return gSlot
end
local _tempTable = {}
function GuildSlot.setData(gSlot, territoryKey, index, gNo64)
  if nil == gSlot or nil == territoryKey or nil == index then
    _PA_LOG("\235\176\149\235\178\148\236\164\128", "GuildSlot.setData return because nil param")
    return
  end
  local guildWrapper = ToClient_SiegeGuildAt(territoryKey, index)
  local siegeBuildingInfo = ToClient_SiegeGuildBuildingInfoAt(territoryKey, index)
  if nil == guildWrapper or nil == siegeBuildingInfo then
    _PA_LOG("\235\176\149\235\178\148\236\164\128", "(nil == guildWrapper) or (nil == siegeBuildingInfo) at " .. territoryKey .. ", " .. tostring(index))
    return
  end
  local guildAllianceName = guildWrapper:getAllianceName()
  if "" == guildAllianceName then
    gSlot.txt_guildName:SetText(guildWrapper:getName())
  else
    gSlot.txt_guildName:SetText(guildAllianceName)
  end
  if true == gSlot.isDefGuild then
    gSlot.txt_guildMasterName:SetText(guildWrapper:getGuildMasterName())
  end
  if true == guildWrapper:isAllianceGuild() then
    isSet = setGuildTextureByAllianceNo(guildWrapper:guildAllianceNo_s64(), gSlot.stc_guildIcon)
  else
    local markData = getGuildMarkIndexByGuildNoForXBox(guildWrapper:getGuildNo_s64())
    if nil ~= markData then
      gSlot.stc_guildIconBG:ChangeTextureInfoName("renewal/commonicon/guildmark/console_icon_guildmark_00.dds")
      local bgx1, bgy1, bgx2, bgy2 = PaGlobalFunc_GuildMark_GetBackGroundUV(markData:getBackGroundIdx())
      local x1, y1, x2, y2 = setTextureUV_Func(gSlot.stc_guildIconBG, bgx1, bgy1, bgx2, bgy2)
      gSlot.stc_guildIconBG:getBaseTexture():setUV(x1, y1, x2, y2)
      gSlot.stc_guildIconBG:setRenderTexture(gSlot.stc_guildIconBG:getBaseTexture())
      gSlot.stc_guildIcon:ChangeTextureInfoName("renewal/commonicon/guildmark/console_icon_guildmark_00.dds")
      local iconx1, icony1, iconx2, icony2 = PaGlobalFunc_GuildMark_GetIconUV(markData:getIconIdx())
      local x1, y1, x2, y2 = setTextureUV_Func(gSlot.stc_guildIcon, iconx1, icony1, iconx2, icony2)
      gSlot.stc_guildIcon:getBaseTexture():setUV(x1, y1, x2, y2)
      gSlot.stc_guildIcon:setRenderTexture(gSlot.stc_guildIcon:getBaseTexture())
    end
  end
  gSlot.txt_scores[SCORE_TYPE.DESTROY]:SetText(tostring(guildWrapper:getTotalSiegeCount(SCORE_TYPE.DESTROY - 1)))
  gSlot.txt_scores[SCORE_TYPE.KILL]:SetText(tostring(guildWrapper:getTotalSiegeCount(SCORE_TYPE.KILL - 1)))
  gSlot.txt_scores[SCORE_TYPE.DEATH]:SetText(tostring(guildWrapper:getTotalSiegeCount(SCORE_TYPE.DEATH - 1)))
  gSlot.txt_scores[SCORE_TYPE.SERVANT]:SetText(tostring(guildWrapper:getTotalSiegeCount(SCORE_TYPE.SERVANT - 1)))
  GuildWarInfo._guildNo64Table[index] = gNo64
  gSlot.bg:addInputEvent("Mouse_LUp", "InputMLUp_GuildWarInfo_Select(" .. index .. ")")
  local hpPercent = string.format("%.0f", siegeBuildingInfo:getRemainHp() / 10000)
  gSlot.txt_percentage:SetText(tostring(hpPercent) .. "%")
  gSlot.progress_durability:SetProgressRate(hpPercent)
end
function GuildSlot.setShow(gSlot, isShow)
  gSlot.bg:SetShow(isShow)
end
function PaGlobalFunc_GuildWarInfo_GetGuildNo64Table()
  local self = GuildWarInfo
  return self._guildNo64Table
end
local _territoryName = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_TERRITORYNAME_0"),
  PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_TERRITORYNAME_1"),
  PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_TERRITORYNAME_2"),
  PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_TERRITORYNAME_3"),
  PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_TERRITORYNAME_4")
}
function FromClient_luaLoadComplete_GuildWarInfo_Init()
  GuildWarInfo:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_GuildWarInfo_Init")
local _initialized = false
function GuildWarInfo:initialize()
  self._ui.txt_title = UI.getChildControl(self._ui.stc_titleBar, "StaticText_Title")
  self._ui.rdo_template = UI.getChildControl(self._ui.stc_tabGroup, "RadioButton_Template")
  self._ui.rdo_territories = {}
  local territoryCount = 1
  if true == ToClient_IsContentsGroupOpen("2") then
    territoryCount = territoryCount + 1
  end
  if true == ToClient_IsContentsGroupOpen("3") then
    territoryCount = territoryCount + 1
  end
  if true == ToClient_IsContentsGroupOpen("4") then
    territoryCount = territoryCount + 1
  end
  if true == ToClient_IsContentsGroupOpen("5") then
    territoryCount = territoryCount + 1
  end
  if true == ToClient_IsContentsGroupOpen("6") then
    territoryCount = territoryCount + 1
  end
  self._territoryCount = territoryCount
  local _tabGroupMiddle = self._ui.stc_tabGroup:GetSizeX() * 0.5
  local _rdoGab = (self._ui.stc_tabGroup:GetSizeX() - 100) / territoryCount
  local _rdoXSizeSum = _rdoGab * (territoryCount - 1)
  local _rdoStartX = _tabGroupMiddle - _rdoXSizeSum * 0.5
  for ii = 0, territoryCount - 1 do
    self._ui.rdo_territories[ii] = UI.cloneControl(self._ui.rdo_template, self._ui.stc_tabGroup, "RadioButton_TerritoryClone_" .. ii)
    self._ui.rdo_territories[ii]:SetText(_territoryName[ii])
    self._ui.rdo_territories[ii]:SetPosX(_rdoStartX + ii * _rdoGab - self._ui.rdo_territories[ii]:GetSizeX() * 0.5)
  end
  self._ui.rdo_template:SetShow(false)
  self._ui.stc_emptyTerritorySymbol = UI.getChildControl(self._ui.stc_emptyBG, "Static_TerritorySymbol")
  self._ui.stc_emptyTerritory = UI.getChildControl(self._ui.stc_emptyBG, "StaticText_Desc")
  self._ui.stc_emptyTerritoryDesc = UI.getChildControl(self._ui.stc_emptyBG, "StaticText_DescSub")
  self._ui.stc_peaceTerritorySymbol = UI.getChildControl(self._ui.stc_peaceBG, "Static_TerritorySymbol")
  self._ui.txt_peaceTerritoryName = UI.getChildControl(self._ui.stc_peaceBG, "StaticText_TerritoryName")
  self._ui.txt_peaceDescSub = UI.getChildControl(self._ui.stc_peaceBG, "StaticText_DescSub")
  self._ui.txt_peaceDescSub:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREE_END_XBOX"))
  self._ui.txt_peaceTerritoryOwner = UI.getChildControl(self._ui.stc_peaceBG, "StaticText_TerritoryOwner")
  self._ui.stc_territorySymbol = UI.getChildControl(self._ui.stc_defGuildBG, "Static_TerritorySymbol")
  self._ui.list2_offenceGuilds = UI.getChildControl(self._ui.stc_innerBG, "List2_Guilds")
  self._ui.list2_offenceGuilds:changeAnimationSpeed(10)
  self._ui.list2_offenceGuilds:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_GuildWarInfo_ListCreateControl")
  self._ui.list2_offenceGuilds:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.txt_keyGuideB = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_KeyGuideB")
  self._ui.txt_keyGuideA = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_KeyGuideA")
  self._ui.txt_keyGuideX = UI.getChildControl(self._ui.stc_bottomBG, "StaticText_KeyGuideX")
  local keyGuides = {
    self._ui.txt_keyGuideA,
    self._ui.txt_keyGuideX,
    self._ui.txt_keyGuideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuides, self._ui.stc_bottomBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self:registEventHandler()
  _initialized = true
end
function GuildWarInfo:registEventHandler()
  _panel:registerPadEvent(__eConsoleUIPadEvent_LB, "Input_GuildWarInfo_SetTabNext(true)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_RB, "Input_GuildWarInfo_SetTabNext(false)")
  _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
  _panel:RegisterUpdateFunc("PaGlobalFunc_GuildWarInfo_UpdatePerFrame")
  registerEvent("Event_SiegeScoreUpdateData", "FromClient_GuildWarInfo_UpdateData")
end
function PaGlobalFunc_GuildWarInfo_Open()
  local self = GuildWarInfo
  if false == _panel:GetShow() then
    self._selectedTerritoryKey = 0
    ToClient_RequestSiegeScore(self._selectedTerritoryKey)
    _panel:SetShow(true)
    self._ui.stc_defGuildBG:SetShow(false)
    self._ui.stc_emptyBG:SetShow(false)
    self._ui.stc_peaceBG:SetShow(false)
    self:setTabTo(self._selectedTerritoryKey)
    self:update(true)
  end
end
function PaGlobalFunc_GuildWarInfo_Close()
  local self = GuildWarInfo
  _panel:SetShow(false)
end
function FromClient_GuildWarInfo_UpdateData()
  local self = GuildWarInfo
  if false == _initialized then
    return
  end
  if false == _panel:GetShow() then
    return
  end
  self:setTabTo(self._selectedTerritoryKey)
  self:update(true)
end
function Input_GuildWarInfo_SetTabNext(isLeft)
  local self = GuildWarInfo
  if true == isLeft then
    if 0 > self._selectedTerritoryKey - 1 then
      self._selectedTerritoryKey = self._territoryCount - 1
    else
      self._selectedTerritoryKey = self._selectedTerritoryKey - 1
    end
  elseif self._territoryCount <= self._selectedTerritoryKey + 1 then
    self._selectedTerritoryKey = 0
  else
    self._selectedTerritoryKey = self._selectedTerritoryKey + 1
  end
  ToClient_RequestSiegeScore(self._selectedTerritoryKey)
  self:setTabTo(self._selectedTerritoryKey)
end
function GuildWarInfo:setTabTo(territoryKey)
  self._selectedTerritoryKey = territoryKey
  self:setTerritorySymbol()
  for ii = 0, #self._ui.rdo_territories do
    if ii == territoryKey then
      self._ui.rdo_territories[ii]:SetFontColor(Defines.Color.C_FFEEEEEE)
    else
      self._ui.rdo_territories[ii]:SetFontColor(Defines.Color.C_FF9397A7)
    end
  end
  self._ui.txt_peaceTerritoryName:SetText(_territoryName[self._selectedTerritoryKey])
  self:update()
end
function GuildWarInfo:setTerritorySymbol()
  local _territorySymbolUV = {
    [0] = {
      1,
      1,
      121,
      121
    },
    {
      122,
      1,
      242,
      121
    },
    {
      122,
      122,
      242,
      242
    },
    {
      1,
      122,
      121,
      242
    },
    {
      243,
      1,
      363,
      121
    }
  }
  local function setUV(control)
    control:ChangeTextureInfoName("renewal/ui_icon/console_icon_conqueststatus.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control, _territorySymbolUV[self._selectedTerritoryKey][1], _territorySymbolUV[self._selectedTerritoryKey][2], _territorySymbolUV[self._selectedTerritoryKey][3], _territorySymbolUV[self._selectedTerritoryKey][4])
    control:getBaseTexture():setUV(x1, y1, x2, y2)
    control:setRenderTexture(control:getBaseTexture())
  end
  setUV(self._ui.stc_territorySymbol)
  setUV(self._ui.stc_emptyTerritorySymbol)
  setUV(self._ui.stc_peaceTerritorySymbol)
end
function GuildWarInfo:update()
  self._isSiegeBeing = isSiegeBeing(self._selectedTerritoryKey)
  local siegeWrapper = ToClient_GetSiegeWrapper(self._selectedTerritoryKey)
  if nil == siegeWrapper then
    return
  end
  self._ui.stc_emptyBG:SetShow(false)
  self._ui.stc_defGuildBG:SetShow(false)
  self._ui.stc_peaceBG:SetShow(false)
  self._ui.stc_innerBG:SetShow(false)
  if false == self._isSiegeBeing then
    self._ui.stc_peaceBG:SetShow(true)
    if true == siegeWrapper:doOccupantExist() then
      local guildWrapper = ToClient_GetGuildWrapperByGuildNo(siegeWrapper:getGuildNo())
      local allianceName = ""
      if nil ~= guildWrapper then
        allianceName = guildWrapper:getAllianceName()
      end
      if "" == allianceName then
        self._ui.txt_peaceTerritoryOwner:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREEDESC_END", "getName", siegeWrapper:getGuildName()))
      else
        self._ui.txt_peaceTerritoryOwner:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_ALLIANCE_WARINFOCONTENTS_SETFREEDESC_END", "getName", allianceName))
      end
      self._ui.txt_peaceDescSub:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREE_END", "selectTerritoy", siegeWrapper:getTerritoryName()))
    else
      self._ui.txt_peaceDescSub:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREE", "selectTerritoy", siegeWrapper:getTerritoryName()))
      self._ui.txt_peaceTerritoryOwner:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GUILDWARINFO_WARINFOCONTENTS_SETFREEDESC"))
    end
    self._ui.txt_keyGuideA:SetShow(false)
    self._ui.txt_keyGuideX:SetShow(false)
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
  else
    local guildCount = ToClient_SiegeGuildCount(self._selectedTerritoryKey)
    if siegeWrapper:doOccupantExist() then
      self._ui.stc_defGuildBG:SetShow(true)
      if nil == self._ui.gSlot_defGuild then
        self._ui.gSlot_defGuild = {}
        GuildSlot.new(self._ui.gSlot_defGuild, self._ui.stc_defGuildBG, true)
      end
    else
      self._ui.stc_emptyBG:SetShow(true)
    end
    self._ui.stc_innerBG:SetShow(true)
    self:updateGuildList(siegeWrapper, guildCount)
    self._ui.txt_keyGuideA:SetShow(true)
    self._ui.txt_keyGuideX:SetShow(true)
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_GuildWarInfo_RequestRefresh()")
  end
end
function GuildWarInfo:updateGuildList(siegeWrapper, guildCount)
  self._ui.list2_offenceGuilds:getElementManager():clearKey()
  self._defenceGuildIndex = 999
  self._offenceGuildIndexTable = {}
  self._offenceGuildNoTable = {}
  local siegeGuildIndex = 0
  for index = 0, guildCount - 1 do
    local guildWrapper = ToClient_SiegeGuildAt(self._selectedTerritoryKey, index)
    local siegeBuildingInfo = ToClient_SiegeGuildBuildingInfoAt(self._selectedTerritoryKey, index)
    if nil == guildWrapper or nil == siegeBuildingInfo then
      return
    end
    local isDefenceGuild = false
    if guildWrapper:getGuildNo_s64() == siegeWrapper:getGuildNo() then
      isDefenceGuild = true
      self._defenceGuildNo = guildWrapper:getGuildNo_s64()
      self._defenceGuildIndex = index
      self._ui.gSlot_defGuild:setData(self._selectedTerritoryKey, index, guildWrapper:getGuildNo_s64())
    else
      isDefenceGuild = false
      siegeGuildIndex = index
      if index > self._defenceGuildIndex then
        siegeGuildIndex = siegeGuildIndex - 1
      end
      self._offenceGuildNoTable[index] = guildWrapper:getGuildNo_s64()
      self._offenceGuildIndexTable[#self._offenceGuildIndexTable + 1] = index
    end
  end
  local lineCount = math.ceil(#self._offenceGuildIndexTable / 2)
  for ii = 1, lineCount do
    self._ui.list2_offenceGuilds:getElementManager():pushKey(toInt64(0, ii))
  end
end
function PaGlobalFunc_GuildWarInfo_ListCreateControl(content, lineNo)
  local self = GuildWarInfo
  local lineNo32 = Int64toInt32(lineNo)
  if nil == self._ui.gSlot_offGuild then
    self._ui.gSlot_offGuild = {}
  end
  local leftButtonBG = UI.getChildControl(content, "Button_ButtonBG_L")
  local rightButtonBG = UI.getChildControl(content, "Button_ButtonBG_R")
  if #self._offenceGuildIndexTable >= lineNo32 * 2 - 1 then
    local leftIndex = self._offenceGuildIndexTable[lineNo32 * 2 - 1]
    local guildWrapper = ToClient_SiegeGuildAt(self._selectedTerritoryKey, leftIndex)
    if nil ~= guildWrapper then
      if nil == self._ui.gSlot_offGuild[leftIndex] then
        self._ui.gSlot_offGuild[leftIndex] = {}
        GuildSlot.new(self._ui.gSlot_offGuild[leftIndex], leftButtonBG, false)
      end
      self._ui.gSlot_offGuild[leftIndex]:setData(self._selectedTerritoryKey, leftIndex, guildWrapper:getGuildNo_s64())
    end
  else
    leftButtonBG:SetShow(false)
  end
  if #self._offenceGuildIndexTable >= lineNo32 * 2 then
    local rightIndex = self._offenceGuildIndexTable[lineNo32 * 2]
    local guildWrapper = ToClient_SiegeGuildAt(self._selectedTerritoryKey, rightIndex)
    if nil ~= guildWrapper then
      if nil == self._ui.gSlot_offGuild[rightIndex] then
        self._ui.gSlot_offGuild[rightIndex] = {}
        GuildSlot.new(self._ui.gSlot_offGuild[rightIndex], rightButtonBG, false)
      end
      self._ui.gSlot_offGuild[rightIndex]:setData(self._selectedTerritoryKey, rightIndex, guildWrapper:getGuildNo_s64())
    end
  else
    rightButtonBG:SetShow(false)
  end
end
function InputMLUp_GuildWarInfo_Select(index)
  local self = GuildWarInfo
  PaGlobalFunc_GuildWarInfo_RequestRefresh()
  PaGlobalFunc_GuildWarInfoDetail_Open(index)
end
function PaGlobalFunc_GuildWarInfo_UpdatePerFrame(deltaTime)
  local self = GuildWarInfo
  self._guildWarInfo_timer = self._guildWarInfo_timer + deltaTime
  self._ui.txt_keyGuideX:SetMonoTone(not (self._guildWarInfo_timer > 5))
  if self._guildWarInfo_timer > 30 then
    ToClient_RequestSiegeScore(self._selectedTerritoryKey)
    self._guildWarInfo_timer = 0
  end
end
function PaGlobalFunc_GuildWarInfo_RequestRefresh()
  local self = GuildWarInfo
  if 5 < self._guildWarInfo_timer then
    ToClient_RequestSiegeScore(self._selectedTerritoryKey)
    self._guildWarInfo_timer = 0
  end
end

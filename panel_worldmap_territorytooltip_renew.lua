local _panel = Panel_Worldmap_TerritoryTooltip
local BENEFIT_TERRITORY = {
  MAP_CALPHEON = 2,
  MAP_MEDIA = 3,
  MAP_VALENCIA = 4,
  MAP_KAMASILVIA = 6,
  MAP_DRAGAN = 7
}
local REPUTATION_TYPE = {
  TYPE_ROOKIE = 0,
  TYPE_STRANGE = 1,
  TYPE_CLOSE = 2,
  TYPE_RELIABLE = 3,
  TYPE_FAMOUS = 4
}
local TerritoryTooltipInfo = {
  _ui = {
    stc_TitleGroup = UI.getChildControl(Panel_Worldmap_TerritoryTooltip, "Static_Title_Group"),
    stc_TerritoryInfoGroup = UI.getChildControl(Panel_Worldmap_TerritoryTooltip, "Static_TerritoryInfoGroup"),
    stc_OccupiersInfoGroup = UI.getChildControl(Panel_Worldmap_TerritoryTooltip, "Static_OccupiersInfoGroup"),
    stc_OccupiersBenefitGroup = UI.getChildControl(Panel_Worldmap_TerritoryTooltip, "Static_OccupyBenefitGroup"),
    stc_InformationGroup = UI.getChildControl(Panel_Worldmap_TerritoryTooltip, "Static_InformationGroup")
  },
  needToUpdate = false,
  originalPanelSizeY = Panel_Worldmap_TerritoryTooltip:GetSizeY(),
  originalInformationGroupSpanY = 0,
  originalBenefitGroupSpanY = 0,
  originalPanelPosY = Panel_Worldmap_TerritoryTooltip:GetPosY(),
  groupInterval = 17
}
function TerritoryTooltipInfo:open()
  _panel:SetShow(true)
end
function TerritoryTooltipInfo:close()
  _panel:SetShow(false)
end
function TerritoryTooltipInfo:init()
  self._ui.txt_title = UI.getChildControl(TerritoryTooltipInfo._ui.stc_TitleGroup, "StaticText_Title")
  self._ui.stc_siteIcon = UI.getChildControl(TerritoryTooltipInfo._ui.stc_TerritoryInfoGroup, "Static_SiteIcon")
  self._ui.txt_cityName = UI.getChildControl(TerritoryTooltipInfo._ui.stc_TerritoryInfoGroup, "StaticText_CityName")
  self._ui.txt_localTaxRate = UI.getChildControl(TerritoryTooltipInfo._ui.stc_TerritoryInfoGroup, "StaticText_TransferTax")
  self._ui.stc_guildIconBG = UI.getChildControl(TerritoryTooltipInfo._ui.stc_OccupiersInfoGroup, "Static_GuildIconBG")
  self._ui.stc_guildIcon = UI.getChildControl(TerritoryTooltipInfo._ui.stc_OccupiersInfoGroup, "Static_GuildIcon")
  self._ui.stc_guildName = UI.getChildControl(TerritoryTooltipInfo._ui.stc_OccupiersInfoGroup, "StaticText_OccupationGuild")
  self._ui.stc_guildMasterName = UI.getChildControl(TerritoryTooltipInfo._ui.stc_OccupiersInfoGroup, "StaticText_OccupationOwner")
  self._ui.stc_guildOccupationPeriod = UI.getChildControl(TerritoryTooltipInfo._ui.stc_OccupiersInfoGroup, "StaticText_OccupationPeriod")
  self._ui.stc_guildOccupationWeek = UI.getChildControl(TerritoryTooltipInfo._ui.stc_OccupiersInfoGroup, "StaticText_OccupationWeek")
  self._ui.txt_occupyDesc = UI.getChildControl(TerritoryTooltipInfo._ui.stc_OccupiersBenefitGroup, "StaticText_OccupyDesc")
  self._ui.txt_occupyDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_reputation = UI.getChildControl(TerritoryTooltipInfo._ui.stc_InformationGroup, "StaticText_Reputation")
  self._ui.txt_warInfo = UI.getChildControl(TerritoryTooltipInfo._ui.stc_InformationGroup, "StaticText_WarInfo")
  self.originalBenefitGroupSpanY = self._ui.stc_OccupiersBenefitGroup:GetSpanSize().y
  self.originalInformationGroupSpanY = self._ui.stc_InformationGroup:GetSpanSize().y
  registerEvent("FromClient_TerritoryTooltipShow", "FromClient_TerritoryTooltipInfo_Show")
  registerEvent("FromClient_TerritoryTooltipHide", "FromClient_TerritoryTooltipInfo_Hide")
  registerEvent("FromClient_WorldMapTerritoryNodeCreate", "FromClient_TerritoryTooltipInfo_UICreate")
  registerEvent("FromClient_WorldMapTerritoryNodeGuildMarkUpdate", "FromClient_TerritoryTooltipInfo_updateGuildmark")
end
function TerritoryTooltipInfo:registMessageHandler()
end
function TerritoryTooltipInfo:update_TitleGroup(territoryInfo)
  local self = TerritoryTooltipInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : TerritoryTooltipInfo")
    return
  end
  self._ui.txt_title:SetText(ToClient_getTerritoryName(territoryInfo))
end
function TerritoryTooltipInfo:update_TerritoryInfoGroup(territoryInfo, territoryKeyRaw)
  local imagePath = ToClient_getTerritoryImageName(territoryInfo)
  self._ui.stc_siteIcon:ChangeTextureInfoName(imagePath)
  local siegeWrapper = ToClient_GetSiegeWrapper(territoryKeyRaw)
  if nil ~= siegeWrapper then
    self._ui.txt_cityName:SetText(siegeWrapper:getRegionAreaName())
  end
  local taxrate = siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
  siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
  self._ui.txt_localTaxRate:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORY_LOCAL_TAX") .. " : " .. string.format("%d", taxrate) .. "%")
end
function TerritoryTooltipInfo:update_OccupiersInfoGroup(territoryInfo, territoryKeyRaw)
  local self = TerritoryTooltipInfo
  local siegeWrapper = ToClient_GetSiegeWrapper(territoryKeyRaw)
  local occupyWeekValue = ToClient_GetAccumulatedOccupiedCountByWeek(territoryKeyRaw)
  if false == siegeWrapper:doOccupantExist() then
    self._ui.stc_OccupiersInfoGroup:SetShow(false)
    self.needToUpdate = true
    return
  end
  self.needToUpdate = true
  local markData = getGuildMarkIndexByGuildNoForXBox(siegeWrapper:getGuildNo())
  if nil ~= markData then
    self._ui.stc_guildIconBG:ChangeTextureInfoName("renewal/commonicon/guildmark/console_icon_guildmark_00.dds")
    local bgx1, bgy1, bgx2, bgy2 = PaGlobalFunc_GuildMark_GetBackGroundUV(markData:getBackGroundIdx())
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.stc_guildIconBG, bgx1, bgy1, bgx2, bgy2)
    self._ui.stc_guildIconBG:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.stc_guildIconBG:setRenderTexture(self._ui.stc_guildIconBG:getBaseTexture())
    self._ui.stc_guildIcon:ChangeTextureInfoName("renewal/commonicon/guildmark/console_icon_guildmark_00.dds")
    local iconx1, icony1, iconx2, icony2 = PaGlobalFunc_GuildMark_GetIconUV(markData:getIconIdx())
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.stc_guildIcon, iconx1, icony1, iconx2, icony2)
    self._ui.stc_guildIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.stc_guildIcon:setRenderTexture(self._ui.stc_guildIcon:getBaseTexture())
  end
  self._ui.stc_guildName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_GUILD") .. " : " .. siegeWrapper:getGuildName())
  self._ui.stc_guildMasterName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_MASTER") .. " : " .. siegeWrapper:getGuildMasterName())
  local paDate = siegeWrapper:getOccupyingDate()
  local year = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_YEAR", "year", tostring(paDate:GetYear()))
  local month = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_MONTH", "month", tostring(paDate:GetMonth()))
  local day = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_DAY", "day", tostring(paDate:GetDay()))
  local hour = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_HOUR", "hour", tostring(paDate:GetHour()))
  self._ui.stc_guildOccupationPeriod:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_TIME") .. " : " .. year .. month .. day .. hour)
  if -1 ~= occupyWeekValue then
    self._ui.stc_guildOccupationWeek:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYTOOLTIP_WEEK_HAVE", "value", occupyWeekValue + 1))
  else
    self._ui.stc_guildOccupationWeek:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYTOOLTIP_WEEK"))
  end
end
function TerritoryTooltipInfo:update_OccupiersBenefitGroup(territoryKeyRaw)
  if territoryKeyRaw < BENEFIT_TERRITORY.MAP_CALPHEON or territoryKeyRaw > BENEFIT_TERRITORY.MAP_VALENCIA then
    self._ui.stc_OccupiersBenefitGroup:SetShow(false)
    self.needToUpdate = true
    return
  end
  if BENEFIT_TERRITORY.MAP_CALPHEON == territoryKeyRaw then
    if true == ToClient_IsContentsGroupOpen(BENEFIT_TERRITORY.MAP_KAMASILVIA) then
      self._ui.txt_occupyDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYINFO_BENEFIT_1"))
    else
      self._ui.txt_occupyDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYINFO_BENEFIT_1_OPEN"))
    end
  elseif BENEFIT_TERRITORY.MAP_MEDIA == territoryKeyRaw then
    if true == ToClient_IsContentsGroupOpen(BENEFIT_TERRITORY.MAP_DRAGAN) then
      self._ui.txt_occupyDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYINFO_BENEFIT_2"))
    else
      self._ui.txt_occupyDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYINFO_BENEFIT_2_OPEN"))
    end
  elseif BENEFIT_TERRITORY.MAP_VALENCIA == territoryKeyRaw then
    self._ui.txt_occupyDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYINFO_BENEFIT_3"))
  end
end
function TerritoryTooltipInfo:update_InformationGroup(territoryInfo, territoryKeyRaw)
  local supportPoint = ToClient_getRemainSurportPointByTerritory(territoryInfo)
  local supportExpRate = ToClient_getCurrentExpRate(territoryInfo)
  if REPUTATION_TYPE.TYPE_ROOKIE == supportPoint then
    supportPointText = "<PAColor0xAAFFBB88>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_ROOKIE") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_ADVENTURER") .. "<PAOldColor>"
  elseif REPUTATION_TYPE.TYPE_STRANGE == supportPoint then
    supportPointText = "<PAColor0xAAFFBB88>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_STRANGE") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_ADVENTURER") .. "<PAOldColor>"
  elseif REPUTATION_TYPE.TYPE_CLOSE == supportPoint then
    supportPointText = "<PAColor0xAAFFBB88>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_CLOSE") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_ADVENTURER") .. "<PAOldColor>"
  elseif REPUTATION_TYPE.TYPE_RELIABLE == supportPoint then
    supportPointText = "<PAColor0xAAFFBB88>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_RELIABLE") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_ADVENTURER") .. "<PAOldColor>"
  elseif supportPoint >= REPUTATION_TYPE.TYPE_FAMOUS then
    supportPointText = "<PAColor0xAAFFBB88>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_FAMOUS") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_ADVENTURER") .. "<PAOldColor>"
  end
  self._ui.txt_reputation:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_FAME") .. " : " .. supportPointText)
  local isWar = isSiegeBeing(territoryKeyRaw)
  local joinGuildCount = getCompleteKingOrLordTentCount(territoryKeyRaw)
  if true == isWar then
    self._ui.txt_warInfo:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WOLRDMAP_TERRITORYTOOLTIP_TEXT_GUILDWAR", "joinGuildCount", joinGuildCount))
  else
    self._ui.txt_warInfo:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYTOOLTIP_JOINGUILDCOUNT", "joinGuildCount", joinGuildCount))
  end
end
function TerritoryTooltipInfo:update_PanelSize()
  local isOccupyGuild = self._ui.stc_OccupiersInfoGroup:GetShow()
  local isBenefit = self._ui.stc_OccupiersBenefitGroup:GetShow()
  local totalY = 0
  local resizePanelPosY = _panel:GetPosY()
  if false == isBenefit then
    totalY = totalY + self._ui.stc_OccupiersBenefitGroup:GetSizeY() + self.groupInterval
  else
    resizePanelPosY = resizePanelPosY - 70
  end
  if false == isOccupyGuild then
    totalY = totalY + self._ui.stc_OccupiersInfoGroup:GetSizeY() + self.groupInterval
  else
    resizePanelPosY = resizePanelPosY - 70
  end
  local infoGroupSpanX = self._ui.stc_InformationGroup:GetSpanSize().x
  local infoGroupSpanY = self._ui.stc_InformationGroup:GetSpanSize().y
  if true == isBenefit and false == isOccupyGuild then
    local benefitSpanX = self._ui.stc_OccupiersBenefitGroup:GetSpanSize().x
    local benefitSpanY = self._ui.stc_OccupiersBenefitGroup:GetSpanSize().y
    self._ui.stc_OccupiersBenefitGroup:SetSpanSize(benefitSpanX, benefitSpanY - totalY)
  end
  self._ui.stc_InformationGroup:SetSpanSize(infoGroupSpanX, infoGroupSpanY - totalY)
  _panel:SetPosY(resizePanelPosY)
  _panel:SetSize(_panel:GetSizeX(), _panel:GetSizeY() - totalY)
end
function TerritoryTooltipInfo:reset_PanelGroups()
  self.needToUpdate = false
  self._ui.stc_OccupiersBenefitGroup:SetShow(true)
  self._ui.stc_OccupiersInfoGroup:SetShow(true)
  _panel:SetSize(_panel:GetSizeX(), self.originalPanelSizeY)
  _panel:SetPosY(self.originalPanelPosY)
  self._ui.stc_OccupiersBenefitGroup:SetSpanSize(self._ui.stc_OccupiersBenefitGroup:GetSpanSize().x, self.originalBenefitGroupSpanY)
  self._ui.stc_InformationGroup:SetSpanSize(self._ui.stc_InformationGroup:GetSpanSize().x, self.originalInformationGroupSpanY)
end
function PaGlobalFunc_TerritoryTooltipInfo_Close()
  local self = TerritoryTooltipInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : TerritoryTooltipInfo")
    return
  end
  self:close()
end
function FromClient_TerritoryTooltipInfo_Show(territoryUI, territoryInfo, territoryKeyRaw)
  local self = TerritoryTooltipInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : TerritoryTooltipInfo")
    return
  end
  TerritoryTooltipInfo:reset_PanelGroups()
  TerritoryTooltipInfo:update_TitleGroup(territoryInfo)
  TerritoryTooltipInfo:update_TerritoryInfoGroup(territoryInfo, territoryKeyRaw)
  TerritoryTooltipInfo:update_OccupiersInfoGroup(territoryInfo, territoryKeyRaw)
  TerritoryTooltipInfo:update_OccupiersBenefitGroup(territoryKeyRaw)
  TerritoryTooltipInfo:update_InformationGroup(territoryInfo, territoryKeyRaw)
  if true == self.needToUpdate then
    TerritoryTooltipInfo:update_PanelSize()
  end
  self:open()
end
function FromClient_TerritoryTooltipInfo_Hide()
  local self = TerritoryTooltipInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : TerritoryTooltipInfo")
    return
  end
  self:close()
end
function FromClient_luaLoadComplete_TerritoryTooltipInfo_Init()
  local self = TerritoryTooltipInfo
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : TerritoryTooltipInfo")
    return
  end
  self:init()
end
function FromClient_TerritoryTooltipInfo_UICreate(territoryUI)
  local territoryInfo = territoryUI:FromClient_getTerritoryInfo()
  local guildMark = territoryUI:FromClient_getGuildMark()
  guildMark:SetSize(42, 42)
  guildMark:SetSpanSize(0, 118)
  guildMark:SetHorizonCenter()
  guildMark:SetVerticalMiddle()
  guildMark:SetIgnore(true)
  guildMark:SetShow(false)
  guildMark:SetTexturePreload(false)
  local isSet = ToClient_setGuildTexture(territoryInfo, guildMark)
  if false == isSet then
    guildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/BlankGuildMark.dds")
    guildMark:SetTexturePreload(false)
    guildMark:SetAlpha(0)
  else
    guildMark:SetAlpha(1)
  end
end
function FromClient_TerritoryTooltipInfo_updateGuildmark(territoryUI)
  local territoryInfo = territoryUI:FromClient_getTerritoryInfo()
  local guildMark = territoryUI:FromClient_getGuildMark()
  local isSet = ToClient_setGuildTexture(territoryInfo, guildMark)
  if false == isSet then
    guildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/BlankGuildMark.dds")
    guildMark:SetTexturePreload(false)
    guildMark:SetAlpha(0)
  else
    guildMark:SetAlpha(1)
  end
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_TerritoryTooltipInfo_Init")

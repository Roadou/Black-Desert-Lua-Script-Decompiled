local UI_TM = CppEnums.TextMode
local Window_WorldMap_NodeInfo = {
  _ui = {
    _static_BaseInfoBg = UI.getChildControl(Panel_Worldmap_NodeInfo, "Static_BaseInfoBg"),
    _static_OtherInfoBg = UI.getChildControl(Panel_Worldmap_NodeInfo, "Static_OtherInfoBg"),
    _static_OccupyInfoBg = UI.getChildControl(Panel_Worldmap_NodeInfo, "Static_OccupyInfoBg"),
    _static_BottomBg = UI.getChildControl(Panel_Worldmap_NodeInfo, "Static_BottomBg")
  },
  _isEnableBattle = ToClient_IsContentsGroupOpen("21"),
  _currentNodeData = {},
  _currentTerritoryKey = -1
}
function Window_WorldMap_NodeInfo:SetNationIcon()
  local nodeStaticStatus = self._currentNodeData._nodeSS
  if nil == nodeStaticStatus then
    return
  end
  local nationIcon = self._ui._staticText_NationIcon
  if PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_CONTRY_KALPEON") == tostring(getNodeNationalName(nodeStaticStatus)) then
    nationIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(nationIcon, 418, 71, 436, 90)
    nationIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_CONTRY_BALENCIA") == tostring(getNodeNationalName(nodeStaticStatus)) then
    nationIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(nationIcon, 456, 71, 474, 90)
    nationIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_CONTRY_MEDIA") == tostring(getNodeNationalName(nodeStaticStatus)) then
    nationIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(nationIcon, 437, 71, 455, 90)
    nationIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif PAGetString(Defines.StringSheet_GAME, "LUA_CONTRYNAME_6") == tostring(getNodeNationalName(nodeStaticStatus)) then
    nationIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(nationIcon, 474, 71, 492, 90)
    nationIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  else
    nationIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(nationIcon, 418, 71, 436, 90)
    nationIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  end
  nationIcon:setRenderTexture(nationIcon:getBaseTexture())
  nationIcon:SetText(getNodeNationalName(nodeStaticStatus))
end
function Window_WorldMap_NodeInfo:SetTerritoryIcon()
  local nodeStaticStatus = self._currentNodeData._nodeSS
  if nil == nodeStaticStatus then
    return
  end
  local territoryIcon = self._ui._staticText_TerritoryIcon
  territoryIcon:SetShow(true)
  if PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_BALENOS") == tostring(getNodeTerritoryName(nodeStaticStatus)) then
    territoryIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/dialogue_etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(territoryIcon, 399, 71, 417, 90)
    territoryIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_SERENDIA") == tostring(getNodeTerritoryName(nodeStaticStatus)) then
    territoryIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/dialogue_etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(territoryIcon, 380, 71, 398, 90)
    territoryIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_KALPEON") == tostring(getNodeTerritoryName(nodeStaticStatus)) then
    territoryIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/dialogue_etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(territoryIcon, 418, 71, 436, 90)
    territoryIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_MEDIA") == tostring(getNodeTerritoryName(nodeStaticStatus)) then
    territoryIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/dialogue_etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(territoryIcon, 437, 71, 455, 90)
    territoryIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_BALENCIA") == tostring(getNodeTerritoryName(nodeStaticStatus)) then
    territoryIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(territoryIcon, 456, 71, 474, 90)
    territoryIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  else
    if PAGetString(Defines.StringSheet_GAME, "LUA_CONTRYNAME_6") == tostring(getNodeTerritoryName(nodeStaticStatus)) then
      territoryIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(territoryIcon, 474, 71, 492, 90)
      territoryIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    else
    end
  end
  territoryIcon:setRenderTexture(territoryIcon:getBaseTexture())
  territoryIcon:SetText(getNodeTerritoryName(nodeStaticStatus))
end
function Window_WorldMap_NodeInfo:SetIcon()
  self:SetNationIcon()
  self:SetTerritoryIcon()
end
function Window_WorldMap_NodeInfo:SetWeather()
  local nodeKey = self._currentNodeData._wayPointKey
  local fWeatherCloudRate = getWeatherInfoByWaypoint(CppEnums.WEATHER_SYSTEM_FACTOR_TYPE.eWSFT_CLOUD_RATE, nodeKey)
  local fWeatherRainAmount = getWeatherInfoByWaypoint(CppEnums.WEATHER_SYSTEM_FACTOR_TYPE.eWSFT_RAIN_AMOUNT, nodeKey)
  local fWeatherCelsius = getWeatherInfoByWaypoint(CppEnums.WEATHER_SYSTEM_FACTOR_TYPE.eWSFT_CELSIUS, nodeKey)
  local strWeatherCloudRate, strWeatherRainAmount, strWeatherCelsius
  if fWeatherCloudRate > 0.6 then
    strWeatherCloudRate = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_CLOUDRATE_HIGH")
  elseif fWeatherCloudRate > 0.3 then
    strWeatherCloudRate = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_CLOUDRATE_MID")
  else
    strWeatherCloudRate = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_CLOUDRATE_LOW")
  end
  if fWeatherRainAmount > 0.6 then
    if fWeatherCelsius < 0 then
      strWeatherRainAmount = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_SNOWAMOUNT_HIGH")
    else
      strWeatherRainAmount = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_RAINAMOUNT_HIGH")
    end
  elseif fWeatherRainAmount > 0.3 then
    if fWeatherCelsius < 0 then
      strWeatherRainAmount = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_SNOWAMOUNT_MID")
    else
      strWeatherRainAmount = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_RAINAMOUNT_MID")
    end
  else
    strWeatherRainAmount = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_RAINAMOUNT_LOW")
  end
  if fWeatherCelsius > 30 then
    strWeatherCelsius = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_CELSIUS_HIGH")
  elseif fWeatherCelsius > 0 then
    strWeatherCelsius = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_CELSIUS_MID")
  else
    strWeatherCelsius = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_CELSIUS_LOW")
  end
  self._ui._staticText_WeatherIcon:SetText(strWeatherCloudRate .. "/" .. strWeatherRainAmount .. "/" .. strWeatherCelsius)
end
function Window_WorldMap_NodeInfo:SetOtherInfo()
  local nodeStaticStatus = self._currentNodeData._nodeSS
  local nodeKey = self._currentNodeData._wayPointKey
  local nodeManagerName = requestNodeManagerName(nodeKey)
  local tax = self:GetTax()
  local popular = self:GetPopular()
  local warInfo = self:GetWarInfo()
  self._ui._staticText_TerritoryInfoValue:SetText(getExploreNodeName(nodeStaticStatus))
  self._ui._staticText_TaxInfoValue:SetText(tax)
  self._ui._staticText_PlayerInfoValue:SetText(popular)
  self._ui._staticText_SiegeInfoValue:SetText(warInfo)
  self._ui._staticText_NodeManagerValue:SetText(nodeManagerName)
  self._ui._staticText_TerritoryInfoValue:SetShow(self._currentNodeData._isTown)
  self._ui._staticText_TaxInfoValue:SetShow(self._currentNodeData._isTown)
  self._ui._staticText_PlayerInfoValue:SetShow(self._currentNodeData._isTown)
  self._ui._staticText_SiegeInfoValue:SetShow(self._currentNodeData._isTown)
  self._ui._staticText_TerritoryInfoTitle:SetShow(self._currentNodeData._isTown)
  self._ui._staticText_TaxInfoTitle:SetShow(self._currentNodeData._isTown)
  self._ui._staticText_PlayerInfoTitle:SetShow(self._currentNodeData._isTown)
  self._ui._staticText_SiegeInfoTitle:SetShow(self._currentNodeData._isTown)
  self._ui._staticText_NodeManagerTitle:SetShow(not self._currentNodeData._isTown)
  self._ui._staticText_NodeManagerValue:SetShow(not self._currentNodeData._isTown)
  self._ui._staticText_NoInvestDesc:SetShow(not self._currentNodeData._isTown and not ToClient_isAbleInvestnWithdraw(nodeKey))
  if true == self._currentNodeData._isTown then
    Panel_Worldmap_NodeInfo:SetSize(Panel_Worldmap_NodeInfo:GetSizeX(), 590)
  else
    Panel_Worldmap_NodeInfo:SetSize(Panel_Worldmap_NodeInfo:GetSizeX(), 400)
  end
  self._ui._static_BottomBg:ComputePos()
end
function Window_WorldMap_NodeInfo:GetTax()
  local territoryKeyRaw = self._currentNodeData._territoryKeyRaw
  local siegeWrapper = ToClient_GetSiegeWrapper(territoryKeyRaw)
  local taxrate = siegeWrapper:getTaxRateForFortress(CppEnums.TaxType.eTaxTypeSellItemToItemMarket)
  return PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORY_LOCAL_TAX") .. " : " .. string.format("%d", taxrate) .. "%"
end
function Window_WorldMap_NodeInfo:GetPopular()
  local nodeStaticStatus = self._currentNodeData._nodeSS
  local territoryInfo = getNodeTerritoryInfo(nodeStaticStatus)
  local supportPoint = ToClient_getRemainSurportPointByTerritory(territoryInfo)
  local supportExpRate = ToClient_getCurrentExpRate(territoryInfo)
  if 0 == supportPoint then
    supportPointText = "<PAColor0xAAFFBB88>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_ROOKIE") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_ADVENTURER") .. "<PAOldColor>"
  elseif 1 == supportPoint then
    supportPointText = "<PAColor0xAAFFBB88>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_STRANGE") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_ADVENTURER") .. "<PAOldColor>"
  elseif 2 == supportPoint then
    supportPointText = "<PAColor0xAAFFBB88>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_CLOSE") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_ADVENTURER") .. "<PAOldColor>"
  elseif 3 == supportPoint then
    supportPointText = "<PAColor0xAAFFBB88>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_RELIABLE") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_ADVENTURER") .. "<PAOldColor>"
  elseif supportPoint >= 4 then
    supportPointText = "<PAColor0xAAFFBB88>" .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_FAMOUS") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_GUIDE_ADVENTURER") .. "<PAOldColor>"
  end
  return supportPointText
end
function Window_WorldMap_NodeInfo:GetWarInfo()
  local territoryKeyRaw = self._currentNodeData._territoryKeyRaw
  local isWar = isSiegeBeing(territoryKeyRaw)
  local joinGuildCount = getCompleteKingOrLordTentCount(territoryKeyRaw)
  if true == isWar then
    return PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WOLRDMAP_TERRITORYTOOLTIP_TEXT_GUILDWAR", "joinGuildCount", joinGuildCount)
  else
    return PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYTOOLTIP_JOINGUILDCOUNT", "joinGuildCount", joinGuildCount)
  end
end
function Window_WorldMap_NodeInfo:SetOccupyInfoFromTown()
  local territoryKeyRaw = self._currentNodeData._territoryKeyRaw
  local siegeWrapper = ToClient_GetSiegeWrapper(territoryKeyRaw)
  local occupyWeekValue = ToClient_GetAccumulatedOccupiedCountByWeek(territoryKeyRaw)
  self._ui._staticText_GuildName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_GUILD"))
  self._ui._staticText_GuildMasterName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_MASTER"))
  local paDate = siegeWrapper:getOccupyingDate()
  local year = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_YEAR", "year", tostring(paDate:GetYear()))
  local month = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_MONTH", "month", tostring(paDate:GetMonth()))
  local day = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_DAY", "day", tostring(paDate:GetDay()))
  local hour = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_HOUR", "hour", tostring(paDate:GetHour()))
  self._ui._staticText_OccupyDate:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_TIME"))
  self._ui._staticText_GuildNameInfo:SetText(siegeWrapper:getGuildName())
  self._ui._staticText_GuildMasterNameInfo:SetText(siegeWrapper:getGuildMasterName())
  self._ui._staticText_OccupyDateInfo:SetText(year .. month .. day .. hour)
  self._ui._staticText_BenefitTitle:SetShow(false)
  self._ui._staticText_BenefitDesc:SetShow(false)
  if nil ~= siegeWrapper and true == siegeWrapper:doOccupantExist() then
    self._ui._static_OccupyInfoBg:SetShow(true)
  else
    self._ui._static_OccupyInfoBg:SetShow(false)
  end
end
function Window_WorldMap_NodeInfo:SetOccupyInfoFromNode()
  self._ui._static_OccupyInfoBg:SetShow(true)
  local nodeStaticStatus = self._currentNodeData._nodeSS
  local regionInfo = nodeStaticStatus:getMinorSiegeRegion()
  if nil == regionInfo then
    return
  end
  local regionKey = regionInfo._regionKey
  local regionWrapper = getRegionInfoWrapper(regionKey:get())
  local minorSiegeWrapper = regionWrapper:getMinorSiegeWrapper()
  local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(regionKey:get())
  local paDate = siegeWrapper:getOccupyingDate()
  local siegeTentCount = ToClient_GetCompleteSiegeTentCount(regionKey:get())
  local dropType = regionInfo:getDropGroupRerollCountOfSieger()
  local nodeTaxType = regionInfo:getVillageTaxLevel()
  local year = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_YEAR", "year", tostring(paDate:GetYear()))
  local month = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_MONTH", "month", tostring(paDate:GetMonth()))
  local day = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_DAY", "day", tostring(paDate:GetDay()))
  local hour = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_HOUR", "hour", tostring(paDate:GetHour()))
  local dropTypeValue = ""
  local isSiegeBeing = minorSiegeWrapper:isSiegeBeing()
  local hasOccupantExist = siegeWrapper:doOccupantExist()
  self:SetShowText(isSiegeBeing)
  self:SetFontColor(isSiegeBeing, hasOccupantExist)
  if true == hasOccupantExist then
    local markData = getGuildMarkIndexByGuildNoForXBox(siegeWrapper:getGuildNo())
    if nil ~= markData then
      self._ui._static_GuildIconBG:ChangeTextureInfoName("renewal/commonicon/guildmark/console_icon_guildmark_00.dds")
      local bgx1, bgy1, bgx2, bgy2 = PaGlobalFunc_GuildMark_GetBackGroundUV(markData:getBackGroundIdx())
      local x1, y1, x2, y2 = setTextureUV_Func(self._ui._static_GuildIconBG, bgx1, bgy1, bgx2, bgy2)
      self._ui._static_GuildIconBG:getBaseTexture():setUV(x1, y1, x2, y2)
      self._ui._static_GuildIconBG:setRenderTexture(self._ui._static_GuildIconBG:getBaseTexture())
      self._ui._static_GuildIcon:ChangeTextureInfoName("renewal/commonicon/guildmark/console_icon_guildmark_00.dds")
      local iconx1, icony1, iconx2, icony2 = PaGlobalFunc_GuildMark_GetIconUV(markData:getIconIdx())
      local x1, y1, x2, y2 = setTextureUV_Func(self._ui._static_GuildIcon, iconx1, icony1, iconx2, icony2)
      self._ui._static_GuildIcon:getBaseTexture():setUV(x1, y1, x2, y2)
      self._ui._static_GuildIcon:setRenderTexture(self._ui._static_GuildIcon:getBaseTexture())
    end
    self._ui._staticText_GuildName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_GUILD"))
    self._ui._staticText_GuildMasterName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_MASTER"))
    self._ui._staticText_OccupyDate:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_TIME"))
    self._ui._staticText_GuildNameInfo:SetText(siegeWrapper:getGuildName())
    self._ui._staticText_GuildMasterNameInfo:SetText(siegeWrapper:getGuildMasterName())
    self._ui._staticText_OccupyDateInfo:SetText(year .. month .. day .. hour)
    local nodeTaxLevel = 0
    if true == _ContentsGroup_SeigeSeason5 then
      nodeTaxLevel = nodeTaxType + 1
    else
      nodeTaxLevel = nodeTaxType
    end
    if 0 == dropType and nodeTaxLevel >= 1 then
      dropTypeValue = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_TAX", "nodeTaxType", nodeTaxLevel)
    elseif dropType >= 1 and 0 == nodeTaxType then
      dropTypeValue = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_LIFE", "dropType", dropType + 1)
    elseif dropType >= 1 and nodeTaxType >= 1 then
      dropTypeValue = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_BOTH", "nodeTaxType", tostring(nodeTaxLevel), "dropType", tostring(dropType + 1))
    else
      dropTypeValue = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_NOT")
    end
    self._ui._staticText_BenefitDesc:SetText(dropTypeValue)
  else
    self._ui._static_GuildIconBG:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui._static_GuildIconBG, 0, 0, 0, 0)
    self._ui._static_GuildIconBG:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui._static_GuildIconBG:setRenderTexture(self._ui._static_GuildIconBG:getBaseTexture())
    self._ui._static_GuildIcon:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui._static_GuildIcon, 0, 0, 0, 0)
    self._ui._static_GuildIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui._static_GuildIcon:setRenderTexture(self._ui._static_GuildIcon:getBaseTexture())
    self._ui._staticText_GuildName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_GUILD"))
    self._ui._staticText_GuildMasterName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_MASTER"))
    self._ui._staticText_OccupyDate:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_TIME"))
    self._ui._staticText_GuildNameInfo:SetText("<PAColor0xfff26a6a>" .. PAGetString(Defines.StringSheet_GAME, "LUA_GRAND_WORLDMAP_NODEOWNERINFO_NOWAR") .. "<PAOldColor>")
    self._ui._staticText_GuildMasterNameInfo:SetText("<PAColor0xfff26a6a>" .. PAGetString(Defines.StringSheet_GAME, "LUA_GRAND_WORLDMAP_NODEOWNERINFO_NOWAR") .. "<PAOldColor>")
    self._ui._staticText_OccupyDateInfo:SetText("<PAColor0xfff26a6a>" .. PAGetString(Defines.StringSheet_GAME, "LUA_GRAND_WORLDMAP_NODEOWNERINFO_NOWAR") .. "<PAOldColor>")
    local nodeTaxLevel = 0
    if true == _ContentsGroup_SeigeSeason5 then
      nodeTaxLevel = nodeTaxType + 1
    else
      nodeTaxLevel = nodeTaxType
    end
    if 0 == dropType and nodeTaxLevel >= 1 then
      dropTypeValue = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_TAX", "nodeTaxType", nodeTaxLevel)
    elseif dropType >= 1 and 0 == nodeTaxType then
      dropTypeValue = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_LIFE", "dropType", dropType + 1)
    elseif dropType >= 1 and nodeTaxType >= 1 then
      dropTypeValue = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_BOTH", "nodeTaxType", tostring(nodeTaxLevel), "dropType", tostring(dropType + 1))
    else
      dropTypeValue = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_BENEFITS_NOT")
    end
    self._ui._staticText_BenefitDesc:SetText(dropTypeValue)
  end
  self._ui._staticText_BenefitTitle:SetShow(true)
  self._ui._staticText_BenefitDesc:SetShow(true)
end
function Window_WorldMap_NodeInfo:SetFontColor(isSiegeBeing, hasOccupant)
end
function Window_WorldMap_NodeInfo:SetShowText(isSiegeBeing)
end
function Window_WorldMap_NodeInfo:SetGuildIcon()
  local nodeStaticStatus = self._currentNodeData._nodeSS
  local territoryInfo = self._currentNodeData._territoryInfo
  local isSet = ToClient_setGuildTexture(territoryInfo, self._ui._static_GuildIcon)
  if true == isSet then
    self._ui._static_GuildIcon:SetAlpha(1)
  else
    self._ui._static_GuildIcon:ChangeTextureInfoName("New_UI_Common_forLua/Default/BlankGuildMark.dds")
    self._ui._static_GuildIcon:SetAlpha(0)
  end
end
function Window_WorldMap_NodeInfo:Update()
  self:SetIcon()
  self:SetWeather()
  self:SetOtherInfo()
  self._ui._static_OccupyInfoBg:SetShow(false)
  if false == self._isEnableBattle then
    return
  end
  if true == self._currentNodeData._isTown then
    self:SetOccupyInfoFromTown()
  elseif true == self._currentNodeData._isSiegeNode then
    self:SetOccupyInfoFromNode()
  end
end
function Window_WorldMap_NodeInfo:SetNodeData(nodeData)
  local self = Window_WorldMap_NodeInfo
  self._currentNodeData = {}
  self._currentNodeData._nodeSS = nodeData:getStaticStatus()
  self._currentNodeData._plantKey = nodeData:getPlantKey()
  self._currentNodeData._wayPointKey = self._currentNodeData._plantKey:getWaypointKey()
  self._currentNodeData._territoryKeyRaw = getNodeTerritoryKeyRaw(nodeData:getStaticStatus())
  self._currentNodeData._territoryInfo = getNodeTerritoryInfo(nodeData:getStaticStatus())
  self._currentNodeData._isTown = worldmap_getisTownByPlantKey(nodeData:getPlantKey())
  local nodeStaticStatus = self._currentNodeData._nodeSS
  local regionInfo = nodeStaticStatus:getMinorSiegeRegion()
  if nil == regionInfo then
    return
  end
  local regionKey = regionInfo._regionKey
  local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(regionKey:get())
  if nil == siegeWrapper then
    self._currentNodeData._isSiegeNode = false
  else
    self._currentNodeData._isSiegeNode = true
  end
end
function Window_WorldMap_NodeInfo:InitControl()
  self._ui._staticText_NationIcon = UI.getChildControl(self._ui._static_BaseInfoBg, "StaticText_NationIcon")
  self._ui._staticText_TerritoryIcon = UI.getChildControl(self._ui._static_BaseInfoBg, "StaticText_TerritoryIcon")
  self._ui._staticText_WeatherIcon = UI.getChildControl(self._ui._static_BaseInfoBg, "StaticText_WeatherIcon")
  self._ui._staticText_TerritoryInfoTitle = UI.getChildControl(self._ui._static_OtherInfoBg, "StaticText_TerritoryInfoTitle")
  self._ui._staticText_TaxInfoTitle = UI.getChildControl(self._ui._static_OtherInfoBg, "StaticText_TaxInfoTitle")
  self._ui._staticText_PlayerInfoTitle = UI.getChildControl(self._ui._static_OtherInfoBg, "StaticText_PlayerInfoTitle")
  self._ui._staticText_SiegeInfoTitle = UI.getChildControl(self._ui._static_OtherInfoBg, "StaticText_SiegeInfoTitle")
  self._ui._staticText_TerritoryInfoValue = UI.getChildControl(self._ui._static_OtherInfoBg, "StaticText_TerritoryInfoValue")
  self._ui._staticText_TaxInfoValue = UI.getChildControl(self._ui._static_OtherInfoBg, "StaticText_TaxInfoValue")
  self._ui._staticText_PlayerInfoValue = UI.getChildControl(self._ui._static_OtherInfoBg, "StaticText_PlayerInfoValue")
  self._ui._staticText_SiegeInfoValue = UI.getChildControl(self._ui._static_OtherInfoBg, "StaticText_SiegeInfoValue")
  self._ui._staticText_NodeManagerTitle = UI.getChildControl(self._ui._static_OtherInfoBg, "StaticText_NodeManagerTitle")
  self._ui._staticText_NodeManagerValue = UI.getChildControl(self._ui._static_OtherInfoBg, "StaticText_NodeManagerValue")
  self._ui._staticText_NoInvestDesc = UI.getChildControl(self._ui._static_OtherInfoBg, "StaticText_NoInvestDesc")
  self._ui._staticText_NoInvestDesc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self._ui._staticText_NoInvestDesc:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_WORLDMAP_FINDNODEMANAGER"))
  self._ui._static_GuildIconBG = UI.getChildControl(self._ui._static_OccupyInfoBg, "Static_GuildIconBG")
  self._ui._static_GuildIcon = UI.getChildControl(self._ui._static_OccupyInfoBg, "Static_GuildIcon")
  self._ui._staticText_GuildName = UI.getChildControl(self._ui._static_OccupyInfoBg, "StaticText_GuildName")
  self._ui._staticText_GuildMasterName = UI.getChildControl(self._ui._static_OccupyInfoBg, "StaticText_GuildMaster")
  self._ui._staticText_OccupyDate = UI.getChildControl(self._ui._static_OccupyInfoBg, "StaticText_OccupyDate")
  self._ui._staticText_GuildName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_GUILD"))
  self._ui._staticText_GuildMasterName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_MASTER"))
  self._ui._staticText_OccupyDate:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_TIME"))
  self._ui._staticText_GuildNameInfo = UI.getChildControl(self._ui._static_OccupyInfoBg, "StaticText_GuildNameInfo")
  self._ui._staticText_GuildMasterNameInfo = UI.getChildControl(self._ui._static_OccupyInfoBg, "StaticText_GuildMasterInfo")
  self._ui._staticText_OccupyDateInfo = UI.getChildControl(self._ui._static_OccupyInfoBg, "StaticText_OccupyDateInfo")
  self._ui._staticText_BenefitTitle = UI.getChildControl(self._ui._static_OccupyInfoBg, "StaticText_BenefitTitle")
  self._ui._staticText_BenefitDesc = UI.getChildControl(self._ui._static_OccupyInfoBg, "StaticText_BenefitDesc")
  self._ui._static_Exit = UI.getChildControl(self._ui._static_BottomBg, "StaticText_B_ConsoleUI")
  self._keyGuideAlign = {
    self._ui._static_Exit
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui._static_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function Window_WorldMap_NodeInfo:InitEvent()
  registerEvent("FromClient_BuildingNodeRClick", "PaGlobalFunc_WorldMapInfo_BuildingNodeRClick")
end
function Window_WorldMap_NodeInfo:InitRegister()
end
function Window_WorldMap_NodeInfo:Initialize()
  self:InitControl()
  self:InitEvent()
  self:InitRegister()
end
function PaGlobalFunc_WorldMapInfo_BuildingNodeRClick(nodeBtn)
  local buildInfoSS = nodeBtn:ToClient_getBuildingStaticStatus()
  if nil ~= buildInfoSS then
    FromClient_RClickWorldmapPanel(ToClient_getBuildingPosition(buildInfoSS), true, false)
  end
end
function PaGlobalFunc_WorldMap_NodeInfo_GetShow()
  return Panel_Worldmap_NodeInfo:GetShow()
end
function PaGlobalFunc_WorldMap_NodeInfo_SetShow(isShow, isAni)
  Panel_Worldmap_NodeInfo:SetShow(isShow, isAni)
end
function PaGlobalFunc_WorldMap_NodeInfo_Open(nodeData)
  local self = Window_WorldMap_NodeInfo
  if true == PaGlobalFunc_WorldMap_NodeInfo_GetShow() then
    return
  end
  if nil == nodeData then
    _PA_ASSERT(false, "WorldMap NodeInfo\236\151\144 nodeData\235\138\148 \237\149\132\236\136\152 \236\158\133\235\139\136\235\139\164.")
    return
  end
  self:SetNodeData(nodeData)
  self:Update()
  PaGlobalFunc_nodeSiegeInfo_Close()
  PaGlobalFunc_WorldMap_RingMenu_Close()
  PaGlobalFunc_WorldMap_TopMenu_Close()
  PaGlobalFunc_WorldMap_BottomMenu_Close()
  PaGlobalFunc_WorldMap_NodeInfo_SetShow(true, false)
end
function PaGlobalFunc_WorldMap_NodeInfo_Close()
  if false == PaGlobalFunc_WorldMap_NodeInfo_GetShow() then
    return
  end
  PaGlobalFunc_WorldMap_RingMenu_Open()
  PaGlobalFunc_WorldMap_TopMenu_Open()
  PaGlobalFunc_WorldMap_BottomMenu_Open()
  PaGlobalFunc_WorldMap_NodeInfo_SetShow(false, false)
end
function PaGlobalFunc_FromClient_WorldMap_NodeInfo_luaLoadComplete()
  local self = Window_WorldMap_NodeInfo
  self:Initialize()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_FromClient_WorldMap_NodeInfo_luaLoadComplete")

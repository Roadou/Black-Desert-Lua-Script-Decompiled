local _panel = Panel_Worldmap_NodeInfo_Console
local WorldMapNodeInfo = {
  _ui = {
    stc_mainBG = UI.getChildControl(_panel, "Static_MainBG"),
    txt_title = nil,
    txt_nodeName = nil,
    txt_territoryName = nil,
    txt_weather = nil,
    groups = nil,
    stc_nodeInvestInfoBG = nil,
    txt_manager = nil,
    txt_managerName = nil,
    txt_nodeLv = nil,
    stc_progressBG = nil,
    progress2_level = nil,
    txt_desc = nil,
    txt_warning = nil,
    btn_energyInvestment = nil,
    btn_disinvestment = nil,
    btn_investment = nil,
    btn_connectedNode = nil,
    stc_contributeInfoBG = UI.getChildControl(_panel, "Static_ContributeInfo"),
    txt_contributeText = nil,
    txt_contributeVal = nil,
    stc_occupyBG = UI.getChildControl(_panel, "Static_OccupyGuildInfo"),
    txt_occupyTitle = nil,
    stc_occupyIcon = nil,
    txt_occupyTime = nil,
    txt_occupyName = nil,
    txt_occupyMasterName = nil,
    stc_occupyBonusBG = nil,
    txt_occupyBonusTitle = nil,
    txt_occupyBonusDetail = nil,
    txt_occupyNowWar = nil
  },
  _wayPointKey = nil,
  _nodeStaticStatus = nil,
  _affiliatedTownKey = nil,
  _nodeLevel = nil,
  _ownerInfoIsUp = false
}
local nodeBtnArray = {}
local dayType = {
  [0] = "0Sunday",
  "1Monday",
  "2Tuesday",
  "3wednesday",
  "4Thursday",
  "5Friday",
  "6Saturday"
}
function FromClient_luaLoadComplete_WorldMapNodeInfo()
  WorldMapNodeInfo:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_WorldMapNodeInfo")
function WorldMapNodeInfo:initialize()
  self._ui.txt_title = UI.getChildControl(self._ui.stc_mainBG, "StaticText_Title")
  self._ui.txt_nodeName = UI.getChildControl(self._ui.stc_mainBG, "StaticText_NodeName")
  self._ui.txt_territoryName = UI.getChildControl(self._ui.stc_mainBG, "StaticText_TerritoryName")
  self._ui.txt_weather = UI.getChildControl(self._ui.stc_mainBG, "StaticText_Weather")
  self._ui.stc_dividers = {}
  self._ui.stc_dividers[1] = UI.getChildControl(self._ui.stc_mainBG, "Static_Divider1")
  self._ui.stc_dividers[2] = UI.getChildControl(self._ui.stc_mainBG, "Static_Divider2")
  self._ui.stc_dividers[3] = UI.getChildControl(self._ui.stc_mainBG, "Static_Divider3")
  self._ui.stc_nodeInvestInfoBG = UI.getChildControl(self._ui.stc_mainBG, "Static_NodeInvestInfo")
  self._ui.txt_manager = UI.getChildControl(self._ui.stc_nodeInvestInfoBG, "StaticText_Manager")
  self._ui.txt_managerName = UI.getChildControl(self._ui.stc_nodeInvestInfoBG, "StaticText_NpcName")
  self._ui.txt_nodeLv = UI.getChildControl(self._ui.stc_nodeInvestInfoBG, "StaticText_NodeLevel")
  self._ui.stc_progressBG = UI.getChildControl(self._ui.txt_nodeLv, "Static_Progress_BG")
  self._ui.progress2_level = UI.getChildControl(self._ui.stc_progressBG, "Progress2_Level")
  self._ui.txt_desc = UI.getChildControl(self._ui.stc_nodeInvestInfoBG, "StaticText_Desc")
  self._ui.txt_warning = UI.getChildControl(self._ui.stc_nodeInvestInfoBG, "StaticText_Warning")
  self._ui.btn_connectedNode = UI.getChildControl(self._ui.stc_nodeInvestInfoBG, "Button_ConnectedNode")
  self._ui.btn_investment = UI.getChildControl(self._ui.stc_nodeInvestInfoBG, "Button_Investment")
  self._ui.btn_energyInvestment = UI.getChildControl(self._ui.stc_nodeInvestInfoBG, "Button_EnergyInvestment")
  self._ui.btn_disinvestment = UI.getChildControl(self._ui.stc_nodeInvestInfoBG, "Button_Disinvestment")
  self._ui.txt_contributeText = UI.getChildControl(self._ui.stc_contributeInfoBG, "StaticText_Point")
  self._ui.txt_contributeVal = UI.getChildControl(self._ui.stc_contributeInfoBG, "StaticText_Point_Val")
  self._ui.txt_occupyTitle = UI.getChildControl(self._ui.stc_occupyBG, "StaticText_Title")
  self._ui.stc_occupyIcon = UI.getChildControl(self._ui.stc_occupyBG, "Static_Icon")
  self._ui.txt_occupyTime = UI.getChildControl(self._ui.stc_occupyBG, "StaticText_Time")
  self._ui.txt_occupyName = UI.getChildControl(self._ui.stc_occupyBG, "StaticText_Name")
  self._ui.txt_occupyMasterName = UI.getChildControl(self._ui.stc_occupyBG, "StaticText_Master")
  self._ui.txt_occupyNowWar = UI.getChildControl(self._ui.stc_occupyBG, "StaticText_NowWar")
  self._ui.stc_occupyBonusBG = UI.getChildControl(self._ui.stc_occupyBG, "Static_Guild_Bonus")
  self._ui.txt_occupyBonusTitle = UI.getChildControl(self._ui.stc_occupyBonusBG, "StaticText_Guild_Bonus_Title")
  self._ui.txt_occupyBonusDetail = UI.getChildControl(self._ui.stc_occupyBonusBG, "StaticText_Guild_Bonus_Detail")
  self:registEvent()
  self:registMessageHandler()
end
function WorldMapNodeInfo:registEvent()
  self._ui.btn_investment:addInputEvent("Mouse_LUp", "Input_WorldMapNodeInfo_OnInvestment()")
  self._ui.btn_disinvestment:addInputEvent("Mouse_LUp", "Input_WorldMapNodeInfo_OnDisInvestment()")
  self._ui.btn_energyInvestment:addInputEvent("Mouse_LUp", "Input_WorldMapNodeInfo_OnEnergyInvest()")
  self._ui.btn_connectedNode:addInputEvent("Mouse_LUp", "Input_WorldMapNodeInfo_OnNearNode()")
end
function WorldMapNodeInfo:registMessageHandler()
  registerEvent("FromClient_FillNodeInfo", "PaGlobalFunc_WorldMapNodeInfo_Update")
  registerEvent("WorldMap_NodeWithdraw", "PaGlobalFunc_WorldMapNodeInfo_Update")
  registerEvent("FromClient_CreateWorldMapNodeIcon", "FromClient_WorldMapNodeInfo_CreateNodeIcon")
  registerEvent("FromClient_RClickedWorldMapNode", "FromClient_WorldMapNodeInfo_RClickedWorldMapNode")
  registerEvent("FromClient_ShowBuildingInfo", "FromClient_WorldMapNodeInfo_ShowBuildingInfo")
  registerEvent("FromClient_BuildingNodeRClick", "FromClient_WorldMapInfo_BuildingNodeRClick")
  registerEvent("FromClint_EventIncreaseExperienceExplorationNode", "FromClient_WorldMapNodeInfo_ExplorationNode")
  registerEvent("FromClient_StartMinorSiege", "FromClient_WorldMapNodeInfo_StartMinorSiege")
  registerEvent("FromClient_EndMinorSiege", "FromClient_WorldMapNodeInfo_EndMinorSiege")
  registerEvent("FromClient_SetGuildModeeWorldMapNodeIcon", "FromClient_WorldMapNodeInfo_SetGuildMode")
  registerEvent("FromClient_OnVillageSiegeBuildingNodeGroup", "FromClient_WorldMapNodeInfo_OnVillageSiegeBuildingNodeGroup")
  registerEvent("FromClient_OutVillageSiegeBuildingNodeGroup", "FromClient_WorldMapNodeInfo_OutVillageSiegeBuildingNodeGroup")
  registerEvent("onScreenResize", "FromClient_WorldMapNodeInfo_OnScreenResize")
end
function PaGlobalFunc_WorldMapNodeInfo_Open(node)
  WorldMapNodeInfo:open(node)
end
function WorldMapNodeInfo:open(node)
  _panel:SetShow(true)
  self:update(node)
end
function PaGlobalFunc_WorldMapNodeInfo_Close()
  WorldMapNodeInfo:close()
end
function WorldMapNodeInfo:close()
  _panel:SetShow(false)
end
function PaGlobalFunc_WorldMapNodeInfo_Update(node)
  WorldMapNodeInfo:update(node)
end
function WorldMapNodeInfo:update(node)
  if not _panel:GetShow() then
    return
  end
  if nil ~= node then
    self._plantKey = node:getPlantKey()
    self._nodeIsMaxLevel = node:isMaxLevel()
    self._nodeStaticStatus = node:getStaticStatus()
  end
  self._wayPointKey = self._plantKey:getWaypointKey()
  local wayPlant = ToClient_getPlant(self._plantKey)
  self._affiliatedTownKey = 0
  local plantKeyActual = self._plantKey:get()
  if (plantKeyActual == CppEnums.MiniGameParam.eMiniGameParamLoggiaCorn or plantKeyActual == CppEnums.MiniGameParam.eMiniGameParamLoggiaFarm or plantKeyActual == CppEnums.MiniGameParam.eMiniGameParamAlehandroHoney or plantKeyActual == CppEnums.MiniGameParam.eMiniGameParamImpCave) and true == self._nodeIsMaxLevel then
    FGlobal_MiniGame_RequestPlantInvest(plantKeyActual)
  end
  if nil ~= wayPlant then
    self._affiliatedTownKey = ToClinet_getPlantAffiliatedWaypointKey(wayPlant)
  end
  FGlobal_SetNodeName(getExploreNodeName(self._nodeStaticStatus))
  self:updateExplorePoint()
  self:updateCountryName()
  self:updateTerritoryName()
  self:updateWeatherText()
  self._ui.txt_managerName:SetText(requestNodeManagerName(self._wayPointKey))
  self:updateNodeOwner()
  self._ui.btn_investment:SetShow(false)
  self._ui.txt_nodeLv:SetShow(true)
  self._ui.btn_disinvestment:SetShow(false)
  self._ui.btn_energyInvestment:SetShow(true)
  self._ui.txt_warning:SetShow(false)
  self._ui.btn_connectedNode:SetShow(false)
  local needPoint = getPlantNeedPoint()
  local supportPoint = getPlantNeedSupportPoint()
  local needMoney = getPlantNeedMoney()
  local recipeItems = getPlantInvestItemList(self._nodeStaticStatus)
  if isExploreUpgradable(self._wayPointKey) then
    if false == self._nodeIsMaxLevel then
      if ToClient_isAbleInvestnWithdraw(self._wayPointKey) then
        self._ui.btn_investment:SetShow(true)
        self._ui.txt_nodeLv:SetShow(false)
        self._ui.btn_disinvestment:SetShow(false)
        self._ui.btn_energyInvestment:SetShow(false)
        self._ui.txt_warning:SetShow(false)
        self._ui.btn_connectedNode:SetShow(false)
      else
        self._ui.txt_warning:SetShow(true)
        self._ui.txt_warning:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_WORLDMAP_FINDNODEMANAGER"))
        self._ui.txt_desc:SetShow(false)
        self._ui.txt_nodeLv:SetShow(false)
        self._ui.btn_investment:SetShow(false)
        self._ui.btn_disinvestment:SetShow(false)
        self._ui.btn_energyInvestment:SetShow(false)
        self._ui.btn_connectedNode:SetShow(false)
      end
    elseif isWithdrawablePlant(self._wayPointKey) then
      self._ui.btn_disinvestment:SetShow(true)
      self:updateNodeLevel()
      self._ui.txt_nodeLv:SetShow(true)
      self._ui.btn_energyInvestment:SetShow(true)
      self._ui.txt_desc:SetShow(false)
      self._ui.txt_warning:SetShow(false)
      self._ui.btn_investment:SetShow(false)
      self._ui.btn_connectedNode:SetShow(false)
      TooltipSimple_Hide()
      if needPoint > 0 or supportPoint > 0 or needMoney > 0 or recipeItems > 0 then
        if workerManager_CheckWorkingOtherChannel() then
          self._ui.txt_desc:SetText(workerManager_getWorkingOtherChannelMsg())
        else
          self._ui.txt_desc:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_WORLDMAP_NODENOTWITHDRAW"))
        end
      end
    end
  else
    local isMainNode = self._nodeStaticStatus._isMainNode
    if true == isMainNode then
      self._ui.txt_desc:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_WORLDMAP_NODENOTUPGRADE"))
      self._ui.btn_connectedNode:SetShow(true)
    elseif false == isMainNode then
      self._ui.txt_desc:SetText(PAGetString(Defines.StringSheet_GAME, "PANEL_WORLDMAP_NODENOTUPGRADE_SUB"))
      self._ui.btn_connectedNode:SetShow(false)
    end
    self._ui.txt_desc:SetShow(true)
    self._ui.btn_disinvestment:SetShow(false)
    self._ui.txt_nodeLv:SetShow(false)
    self._ui.txt_warning:SetShow(false)
    self._ui.btn_investment:SetShow(false)
    self._ui.btn_energyInvestment:SetShow(false)
  end
end
function WorldMapNodeInfo:updateExplorePoint()
  local territoryKeyRaw = ToClient_getDefaultTerritoryKey()
  local explorePoint = ToClient_getExplorePointByTerritoryRaw(territoryKeyRaw)
  self._ui.txt_contributeVal:SetText(tostring(explorePoint:getRemainedPoint()) .. " / " .. tostring(explorePoint:getAquiredPoint()))
end
function WorldMapNodeInfo:updateCountryName()
  local nodeStaticStatus = self._nodeStaticStatus
  if nil == nodeStaticStatus then
    return
  end
  local countryIcon = self._ui.txt_nodeName
  local nodeNationalName = getNodeNationalName(nodeStaticStatus)
  if PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_CONTRY_KALPEON") == tostring(nodeNationalName) then
    countryIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(countryIcon, 418, 71, 436, 90)
    countryIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_CONTRY_BALENCIA") == tostring(nodeNationalName) then
    countryIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(countryIcon, 456, 71, 474, 90)
    countryIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_CONTRY_MEDIA") == tostring(nodeNationalName) then
    countryIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(countryIcon, 437, 71, 455, 90)
    countryIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif PAGetString(Defines.StringSheet_GAME, "LUA_CONTRYNAME_6") == tostring(nodeNationalName) then
    countryIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(countryIcon, 474, 71, 492, 90)
    countryIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  else
    countryIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(countryIcon, 418, 71, 436, 90)
    countryIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  end
  countryIcon:setRenderTexture(countryIcon:getBaseTexture())
  countryIcon:SetText(nodeNationalName)
end
function WorldMapNodeInfo:updateTerritoryName()
  local nodeStaticStatus = self._nodeStaticStatus
  if nil == nodeStaticStatus then
    return
  end
  local territoryIcon = self._ui.txt_territoryName
  local territoryName = getNodeTerritoryName(nodeStaticStatus)
  territoryIcon:SetShow(true)
  if PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_BALENOS") == tostring(territoryName) then
    territoryIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/dialogue_etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(territoryIcon, 399, 71, 417, 90)
    territoryIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_SERENDIA") == tostring(territoryName) then
    territoryIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/dialogue_etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(territoryIcon, 380, 71, 398, 90)
    territoryIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_KALPEON") == tostring(territoryName) then
    territoryIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/dialogue_etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(territoryIcon, 418, 71, 436, 90)
    territoryIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_MEDIA") == tostring(territoryName) then
    territoryIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/dialogue_etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(territoryIcon, 437, 71, 455, 90)
    territoryIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  elseif PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_BALENCIA") == tostring(territoryName) then
    territoryIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(territoryIcon, 456, 71, 474, 90)
    territoryIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  else
    if PAGetString(Defines.StringSheet_GAME, "LUA_CONTRYNAME_6") == tostring(territoryName) then
      territoryIcon:ChangeTextureInfoName("new_ui_common_forlua/widget/dialogue/Dialogue_Etc_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(territoryIcon, 474, 71, 492, 90)
      territoryIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    else
    end
  end
  territoryIcon:setRenderTexture(territoryIcon:getBaseTexture())
  territoryIcon:SetText(territoryName)
end
function WorldMapNodeInfo:updateWeatherText()
  local nodeKey = self._wayPointKey
  if nil == nodeKey then
    return
  end
  local fWeatherCloudRate = getWeatherInfoByWaypoint(CppEnums.WEATHER_SYSTEM_FACTOR_TYPE.eWSFT_CLOUD_RATE, nodeKey)
  local fWeatherRainAmount = getWeatherInfoByWaypoint(CppEnums.WEATHER_SYSTEM_FACTOR_TYPE.eWSFT_RAIN_AMOUNT, nodeKey)
  local fWeatherCelsius = getWeatherInfoByWaypoint(CppEnums.WEATHER_SYSTEM_FACTOR_TYPE.eWSFT_CELSIUS, nodeKey)
  local strWeatherCloudRate = ""
  local strWeatherRainAmount = ""
  local strWeatherCelsius = ""
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
  self._ui.txt_weather:SetText(strWeatherCloudRate .. "/" .. strWeatherRainAmount .. "/" .. strWeatherCelsius)
end
function WorldMapNodeInfo:updateNodeLevel()
  if nil == self._wayPointKey then
    return
  end
  local nodeLv = ToClient_GetNodeLevel(self._wayPointKey)
  local nodeExp = Int64toInt32(ToClient_GetNodeExperience_s64(self._wayPointKey))
  local nodeExpMax = Int64toInt32(ToClient_GetNeedExperienceToNextNodeLevel_s64(self._wayPointKey))
  local nodeExpPercent = nodeExp / nodeExpMax * 100
  self._ui.txt_nodeLv:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_HELPICON_NODELEVEL") .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. ". " .. tostring(nodeLv))
  self._nodeLevel = nodeLv
  if _isProgressReset then
    self._ui.progress2_level:SetProgressRate(0)
    _isProgressReset = false
  else
    self._ui.progress2_level:SetProgressRate(nodeExpPercent)
  end
end
function WorldMapNodeInfo:updateNodeOwner()
  local regionInfo = self._nodeStaticStatus:getMinorSiegeRegion()
  self._ownerInfoIsUp = false
  if nil == regionInfo then
    self._ui.stc_occupyBG:SetShow(false)
    return
  end
  local regionKey = regionInfo._regionKey
  local regionWrapper = getRegionInfoWrapper(regionKey:get())
  local minorSiegeWrapper = regionWrapper:getMinorSiegeWrapper()
  if nil == minorSiegeWrapper then
    self._ui.stc_occupyBG:SetShow(false)
    return
  end
  local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(regionKey:get())
  if nil == siegeWrapper then
    self._ui.stc_occupyBG:SetShow(false)
    return
  end
  self._ownerInfoIsUp = true
  local paDate = siegeWrapper:getOccupyingDate()
  local siegeTentCount = ToClient_GetCompleteSiegeTentCount(regionKey:get())
  local year = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_YEAR", "year", tostring(paDate:GetYear()))
  local month = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_MONTH", "month", tostring(paDate:GetMonth()))
  local day = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_DAY", "day", tostring(paDate:GetDay()))
  local hour = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLD_MAP_SIEGE_HOUR", "hour", tostring(paDate:GetHour()))
  local isSiegeBeing = minorSiegeWrapper:isSiegeBeing()
  local hasOccupantExist = siegeWrapper:doOccupantExist()
  self._ui.txt_occupyTime:SetShow(not isSiegeBeing)
  self._ui.txt_occupyName:SetShow(not isSiegeBeing)
  self._ui.txt_occupyMasterName:SetShow(not isSiegeBeing)
  self._ui.txt_occupyBonusTitle:SetShow(not isSiegeBeing)
  self._ui.txt_occupyBonusDetail:SetShow(not isSiegeBeing)
  self._ui.txt_occupyNowWar:SetShow(isSiegeBeing)
  if true == isSiegeBeing then
    local isSiegeChannel = ToClient_doMinorSiegeInTerritory(regionWrapper:getTerritoryKeyRaw())
    if true == isSiegeChannel then
      self._ui.txt_occupyNowWar:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_NODEWAR_COUNT", "siegeTentCount", siegeTentCount))
    else
      self._ui.txt_occupyNowWar:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODEOWNERINFO_NOT_NODEWAR"))
    end
    self.ui.txt_occupyName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODEOWNERINFO_WAR"))
  elseif true == hasOccupantExist then
    local isSet = setGuildTextureByGuildNo(siegeWrapper:getGuildNo(), self._ui.stc_occupyIcon)
    if not isSet then
      self._ui.stc_occupyIcon:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(self._ui.stc_occupyIcon, 183, 1, 188, 6)
      self._ui.stc_occupyIcon:getBaseTexture():setUV(x1, y1, x2, y2)
      self._ui.stc_occupyIcon:setRenderTexture(self._ui.stc_occupyIcon:getBaseTexture())
    end
    self._ui.txt_occupyName:SetText(siegeWrapper:getGuildName())
    self._ui.txt_occupyMasterName:SetText(siegeWrapper:getGuildMasterName())
    self._ui.txt_occupyTime:SetText(year .. " " .. month .. " " .. day .. " " .. hour)
  else
    self._ui.stc_occupyIcon:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.stc_occupyIcon, 0, 0, 0, 0)
    self._ui.stc_occupyIcon:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.stc_occupyIcon:setRenderTexture(self._ui.stc_occupyIcon:getBaseTexture())
    self._ui.txt_occupyName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_GRAND_WORLDMAP_NODEOWNERINFO_NOWAR"))
    self._ui.txt_occupyMasterName:SetText("-")
    self._ui.txt_occupyTime:SetText("-")
  end
  if true == self._ownerInfoIsUp then
    local dropTypeValue = ""
    local dropType = regionInfo:getDropGroupRerollCountOfSieger()
    local nodeTaxType = regionInfo:getVillageTaxLevel()
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
    self._ui.txt_occupyBonusDetail:SetText(dropTypeValue)
  end
end
function PaGlobalFunc_WorldMapNodeInfo_UpdateExplorePoint()
  WorldMapNodeInfo:updateExplorePoint()
end
local _isProgressReset = false
function Input_WorldMapNodeInfo_OnInvestment()
  local self = WorldMapNodeInfo
  if nil == self._wayPointKey then
    return
  end
  _isProgressReset = true
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  ToClient_WorldMapRequestUpgradeExplorationNode(self._wayPointKey)
  PaGlobal_TutorialManager:handleOnNodeUpgradeClick(self._wayPointKey)
end
function Input_WorldMapNodeInfo_OnDisInvestment()
  local self = WorldMapNodeInfo
  if nil == self._wayPointKey then
    return
  end
  local function NodeWithdrawExecute()
    _AudioPostEvent_SystemUiForXBOX(50, 1)
    ToClient_WorldMapRequestWithdrawPlant(self._wayPointKey)
  end
  if Panel_Plant_WorkManager:GetShow() then
    WorldMapPopupManager:popPanel()
  end
  local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_PANEL_WORLDMAP_NODE_WITHDRAWCONFIRM")
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WARNING"),
    content = messageBoxMemo,
    functionYes = NodeWithdrawExecute,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData, "top")
end
function Input_WorldMapNodeInfo_OnEnergyInvest()
  local self = WorldMapNodeInfo
  if nil == self._wayPointKey then
    return
  end
  if false == ToClient_WorldMapIsShow() then
    return
  end
  local player = getSelfPlayer()
  if nil == player then
    return
  end
  local wp = player:getWp()
  local maxWp = player:getMaxWp()
  local s64_maxNumber = toInt64(0, 0)
  local wpCalc = math.floor(wp / 10)
  if maxWp > wpCalc then
    s64_maxNumber = tonumber64(wpCalc)
  end
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  Panel_NumberPad_Show(true, s64_maxNumber, self._wayPointKey, PaGlobalFunc_WorldMapNodeInfo_EnergyInvest)
end
function PaGlobalFunc_WorldMapNodeInfo_EnergyInvest(inputNumber, param)
  local wpCount = Int64toInt32(inputNumber) * 10
  ToClient_RequestIncreaseExperienceNode(param, wpCount)
end
function Input_WorldMapNodeInfo_OnNearNode()
  local self = WorldMapNodeInfo
  if nil == self._wayPointKey then
    return
  end
  if true == PaGlobal_TutorialManager:isDoingTutorial() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TUTORIAL_PROGRSS_ACK"))
    return
  end
  ToClient_DeleteNaviGuideByGroup(0)
  ToClient_WorldMapFindNearNode(self._wayPointKey, NavigationGuideParam())
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  FGlobal_WorldMapWindowEscape()
end
function FromClient_WorldMapNodeInfo_CreateNodeIcon(nodeBtn)
  FromClient_WorldMapNodeInfo_GuildWarSet(nodeBtn)
  local tradeIcon = nodeBtn:FromClient_getTradeIcon()
  local explorationInfo = nodeBtn:FromClient_getExplorationNodeInClient()
  local plantKey = explorationInfo:getPlantKey()
  local wayPointKey = plantKey:getWaypointKey()
  if nil ~= explorationInfo then
    local explorationInfoSSW = explorationInfo:getStaticStatus()
    local minorSiegeRegion = explorationInfoSSW:getMinorSiegeRegion()
    if nil ~= minorSiegeRegion then
      local regionKey = minorSiegeRegion._regionKey:get()
      local isWeekNode = ToClient_IsVillageSiegeInThisWeek(regionKey)
      local guildIcon = nodeBtn:FromClient_getNodeGuildIcon()
      local guildIconBG = nodeBtn:FromClient_getGuildMarkBG()
      local guildMark = nodeBtn:FromClient_getGuildMark()
      if isWeekNode then
        guildIcon:SetMonoTone(false)
        guildIconBG:SetMonoTone(false)
        guildMark:SetMonoTone(false)
      else
        guildIcon:SetMonoTone(true)
        guildIconBG:SetMonoTone(true)
        guildMark:SetMonoTone(true)
      end
    end
  end
  local territoryKeyRaw = nodeBtn:FromClient_getTerritoryKey()
  if 301 == wayPointKey or 1 == wayPointKey or 601 == wayPointKey or 1101 == wayPointKey or 1301 == wayPointKey then
    tradeIcon:SetSpanSize(-10, 20)
    tradeIcon:SetShow(false)
    nodeBtnArray[wayPointKey] = nodeBtn
    tradeIcon:addInputEvent("Mouse_LUp", "FGlobal_handleOpenItemMarket(" .. territoryKeyRaw .. ")")
    tradeIcon:addInputEvent("Mouse_On", "CreateNodeIconForTradeIcon_ShowTooltip(" .. wayPointKey .. ", true )")
    tradeIcon:addInputEvent("Mouse_Out", "CreateNodeIconForTradeIcon_ShowTooltip(" .. wayPointKey .. ", false )")
  end
end
function FromClient_WorldMapNodeInfo_GuildWarSet(nodeBtn)
  local explorationInfo = nodeBtn:FromClient_getExplorationNodeInClient()
  local nodeStaticStatus = explorationInfo:getStaticStatus()
  local regionInfo = nodeStaticStatus:getMinorSiegeRegion()
  local warStateIcon = nodeBtn:FromClient_getWarStateIcon()
  local guildModeGuildMark = nodeBtn:FromClient_getNodeGuildIcon()
  if nil ~= regionInfo then
    local regionKey = regionInfo._regionKey
    local regionWrapper = getRegionInfoWrapper(regionKey:get())
    local minorSiegeWrapper = regionWrapper:getMinorSiegeWrapper()
    local siegeWrapper = ToClient_GetSiegeWrapperByRegionKey(regionKey:get())
    local guildMark = nodeBtn:FromClient_getGuildMark()
    local guildMarkBG = nodeBtn:FromClient_getGuildMarkBG()
    if nil ~= minorSiegeWrapper then
      if minorSiegeWrapper:isSiegeBeing() then
        warStateIcon:setUpdateTextureAni(true)
        warStateIcon:SetShow(true)
        guildMark:SetShow(false)
        guildMarkBG:SetShow(false)
      else
        warStateIcon:setUpdateTextureAni(false)
        if true == siegeWrapper:doOccupantExist() then
          local isSet = setGuildTextureByGuildNo(siegeWrapper:getGuildNo(), guildMark)
          if false == isSet then
            guildMark:ChangeTextureInfoName("New_UI_Common_forLua/Default/Default_Buttons.dds")
            local x1, y1, x2, y2 = setTextureUV_Func(guildMark, 183, 1, 188, 6)
            guildMark:getBaseTexture():setUV(x1, y1, x2, y2)
          else
            guildMark:getBaseTexture():setUV(0, 0, 1, 1)
          end
          guildMark:setRenderTexture(guildMark:getBaseTexture())
          warStateIcon:SetShow(false)
          guildMark:SetShow(true)
          guildMarkBG:SetShow(true)
        else
          warStateIcon:SetShow(true)
          guildMark:SetShow(false)
          guildMarkBG:SetShow(false)
        end
      end
    else
      warStateIcon:SetShow(false)
      guildMark:SetShow(false)
      guildMarkBG:SetShow(false)
    end
    guildModeGuildMark:SetShow(false)
  end
end
function FromClient_WorldmapNodeInfo_RClickedWorldMapNode(nodeBtn)
  local node = nodeBtn:FromClient_getExplorationNodeInClient()
  if nil == node then
    return
  end
  local nodeStaticStatus = node:getStaticStatus()
  local position = ToClient_getNodeManagerPosition(nodeStaticStatus)
  if 0 == position.x and 0 == position.y and 0 == position.z then
    position = nodeStaticStatus:getPosition()
  end
  FromClient_RClickWorldmapPanel(position, true, false)
end
function FromClient_WorldMapNodeInfo_ShowBuildingInfo(nodeBtn)
  buildingActorKey = nodeBtn:ToClient_getActorKey()
  local buildingSS = ToClient_getBuildingInfo(buildingActorKey)
  if nil == buildingSS then
    return
  end
  local workableCount = ToClient_getBuildingWorkableListCount(buildingSS)
  if workableCount > 0 then
    WorldMapNodeInfo:onClickBuildingManage()
  end
end
function WorldMapNodeInfo:onClickBuildingManage()
  local buildingSS = ToClient_getBuildingInfo(buildingActorKey)
  if nil == buildingSS then
    return
  end
  if false == ToClient_isMyBuilding(buildingSS) then
    return
  end
  if 1 <= buildingSS:getBuildingProgress() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_CLICK_COMPLETED_BUILDING"))
  else
    FGlobal_Building_WorkManager_Reset_Pos()
    FGlobal_Building_WorkManager_Open(buildingActorKey)
    WorldMapPopupManager:increaseLayer()
    WorldMapPopupManager:push(Panel_Building_WorkManager, true)
  end
end
function FromClient_WorldMapInfo_BuildingNodeRClick(nodeBtn)
  local buildInfoSS = nodeBtn:ToClient_getBuildingStaticStatus()
  if nil ~= buildInfoSS then
    FromClient_RClickWorldmapPanel(ToClient_getBuildingPosition(buildInfoSS), true, false)
  end
end
function FromClient_WorldMapNodeInfo_ExplorationNode(WaypointKey, ExplorationLevel, TExperience)
  WorldMapNodeInfo:updateNodeLevel(WaypointKey)
end
function FromClient_WorldMapNodeInfo_StartMinorSiege(nodeBtn)
  local warStateIcon = nodeBtn:FromClient_getWarStateIcon()
  warStateIcon:setUpdateTextureAni(true)
  warStateIcon:SetShow(true)
  local guildMark = nodeBtn:FromClient_getGuildMark()
  local guildMarkBG = nodeBtn:FromClient_getGuildMarkBG()
  guildMark:SetShow(false)
  guildMarkBG:SetShow(false)
end
function FromClient_WorldMapNodeInfo_EndMinorSiege(nodeBtn)
  worldmapNodeIcon_GuildWarSet(nodeBtn)
end
function FromClient_WorldMapNodeInfo_OnVillageSiegeBuildingNodeGroup(nodeBtn)
  nodeBtn:EraseAllEffect()
  nodeBtn:AddEffect("UI_WorldMap_Ping01", true, 0, 0)
end
function FromClient_WorldMapNodeInfo_OutVillageSiegeBuildingNodeGroup(nodeBtn)
  nodeBtn:EraseAllEffect()
end
function FromClient_WorldMapNodeInfo_SetGuildMode(nodeBtn)
  if PaGlobalFunc_WorldMapSideBar_IsGuildWarMode() then
    local warStateIcon = nodeBtn:FromClient_getWarStateIcon()
    local guildMark = nodeBtn:FromClient_getGuildMark()
    local guildMarkBG = nodeBtn:FromClient_getGuildMarkBG()
    local guildIcon = nodeBtn:FromClient_getNodeGuildIcon()
    local explorationInfo = nodeBtn:FromClient_getExplorationNodeInClient()
    local villageSiegeType = nodeBtn:getVillageSiegeType()
    local siegeNode = nodeBtn:FromClient_getExplorationNodeInClient():getStaticStatus():getMinorSiegeRegion()
    if nil ~= siegeNode and villageSiegeType < 7 then
      local taxGrade = siegeNode:getVillageTaxLevel()
      warStateIcon:SetShow(false)
      guildMark:SetShow(false)
      guildMarkBG:SetShow(false)
      nodeBtn:SetMonoTone(false)
      local normalUrl = "New_UI_Common_forLua/Widget/WorldMap/WorldMap_NodeWarGuildIcon/" .. dayType[villageSiegeType] .. "/" .. tostring(taxGrade) .. "_Nomal.dds"
      local overUrl = "New_UI_Common_forLua/Widget/WorldMap/WorldMap_NodeWarGuildIcon/" .. dayType[villageSiegeType] .. "/" .. tostring(taxGrade) .. "_Over.dds"
      local clickUrl = "New_UI_Common_forLua/Widget/WorldMap/WorldMap_NodeWarGuildIcon/" .. dayType[villageSiegeType] .. "/" .. tostring(taxGrade) .. "_Click.dds"
      nodeBtn:ChangeTextureInfoName(normalUrl)
      nodeBtn:getBaseTexture():setUV(0, 0, 1, 1)
      nodeBtn:setRenderTexture(nodeBtn:getBaseTexture())
      nodeBtn:ChangeOnTextureInfoName(overUrl)
      nodeBtn:ChangeClickTextureInfoName(clickUrl)
    end
    if nil ~= explorationInfo then
      local explorationInfoSSW = explorationInfo:getStaticStatus()
      local minorSiegeRegion = explorationInfoSSW:getMinorSiegeRegion()
      if nil ~= minorSiegeRegion then
        local regionKey = minorSiegeRegion._regionKey:get()
        local isWeekNode = ToClient_IsVillageSiegeInThisWeek(regionKey)
        if isWeekNode then
          guildMark:SetMonoTone(false)
          guildMarkBG:SetMonoTone(false)
          guildIcon:SetMonoTone(false)
        else
          guildMark:SetMonoTone(true)
          guildMarkBG:SetMonoTone(true)
          guildIcon:SetMonoTone(true)
        end
      end
    end
  else
    FromClient_WorldMapNodeInfo_GuildWarSet(nodeBtn)
  end
end
function FromClient_WorldMapNodeInfo_OnScreenResize()
  _panel:SetSize(getScreenSizeX(), getScreenSizeY())
end

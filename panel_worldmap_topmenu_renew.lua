local _panel = Panel_Worldmap_TopMenu
local Window_WorldMap_TopMenuInfo = {
  _ui = {
    _static_MenuBg = UI.getChildControl(_panel, "Static_MainMenuBg"),
    _static_SubMenuBg = UI.getChildControl(_panel, "Static_SubMenuBg"),
    _staticText_Title = UI.getChildControl(_panel, "StaticText_Title"),
    stc_keyGuideYLeftRight = nil,
    stc_keyGuideYDown = UI.getChildControl(_panel, "StaticText_YDownToolTip"),
    _menuButtonList = {}
  },
  _config = {
    _menuCount = 8,
    _buttonGapX = 70,
    _isEnablePlunderGame = ToClient_IsContentsGroupOpen("360"),
    _isEnableBattle = ToClient_IsContentsGroupOpen("21")
  },
  _strConfig = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_PLANT_NAME"),
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_REGION_NAME"),
    [2] = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_WATER_NAME"),
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_CELCIUS_NAME"),
    [4] = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_HUMIDITY_NAME"),
    [5] = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_GUILDWAR_NAME"),
    [6] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TOOLTIP_NODEFILTER"),
    [7] = PAGetString(Defines.StringSheet_GAME, "INTIMACYINFORMATION_TYPE_KNOWLEDGE")
  },
  _stateFilterConfig = {
    [0] = {
      true,
      false,
      false,
      true,
      false,
      true,
      false,
      true,
      true,
      true
    },
    [1] = {
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      true
    },
    [2] = {
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      true
    },
    [3] = {
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      true
    },
    [4] = {
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      true
    },
    [5] = {
      false,
      false,
      false,
      true,
      false,
      true,
      false,
      false,
      false,
      true
    },
    [6] = {
      false,
      false,
      false,
      true,
      false,
      false,
      false,
      false,
      false,
      true
    },
    [7] = {
      false,
      true,
      true,
      false,
      false,
      false,
      false,
      false,
      false,
      true
    }
  },
  _currentMenuIndex = 0,
  _isBlackFog = false,
  _isGuildWarMode = false,
  _currentNodeInfo = nil,
  _worldmapTitleString = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORLDMAP_TOPMENU_TITLE"),
  _prevMenuIndex = 0
}
function Window_WorldMap_TopMenuInfo:UpdateFilder(state)
  local eState = CppEnums.WorldMapState
  local filter = self._stateFilterConfig[state]
  if nil == filter then
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "\236\155\148\235\147\156\235\167\181 \236\160\149\235\179\180 \236\157\184\235\141\177\236\138\164\234\176\128 \236\158\152\235\170\187 \235\147\164\236\150\180\236\153\148\236\138\181\235\139\136\235\139\164.")
    return
  end
  for index, isShow in pairs(filter) do
    ToClient_WorldmapCheckState(index - 1, isShow, false)
  end
end
function PaGlobalFunc_WorldMap_TopMenu_ToggleTownMenu()
  PaGlobalFunc_WorldMap_RightMenu_Toggle()
end
function PaGlobalFunc_WorldMap_TopMenu_NextMenu(isLeft)
  local self = Window_WorldMap_TopMenuInfo
  if true == isLeft then
    self._currentMenuIndex = self._currentMenuIndex - 1
  else
    self._currentMenuIndex = self._currentMenuIndex + 1
  end
  if self._currentMenuIndex < 0 then
    self._currentMenuIndex = self._config._menuCount - 1
  end
  if self._config._menuCount - 1 < self._currentMenuIndex then
    self._currentMenuIndex = 0
  end
  if false == self._config._isEnableBattle and 5 == self._currentMenuIndex then
    if false == isLeft then
      self._currentMenuIndex = self._currentMenuIndex + 1
    else
      self._currentMenuIndex = self._currentMenuIndex - 1
    end
  end
  if 5 == self._currentMenuIndex then
    PaGlobalFunc_WorldMap_TopMenu_ShowYDown(true)
  else
    PaGlobalFunc_WorldMap_TopMenu_ShowYDown(false)
  end
  PaGlobalFunc_nodeSiegeInfo_Close()
  self:UpdateButtonWorldMode()
  self:UpdateInfo(self._currentMenuIndex)
end
function PaGlobalFunc_WorldMap_TopMenu_GetMenuIndex()
  return Window_WorldMap_TopMenuInfo._currentMenuIndex
end
function Window_WorldMap_TopMenuInfo:UpdateButtonWorldMode()
  self._ui._static_MenuBg:SetShow(true)
  self._ui._static_SubMenuBg:SetShow(false)
  for index, control in pairs(self._ui._menuButtonList) do
    control:SetCheck(index == self._currentMenuIndex)
  end
  self._ui._staticText_Tooltip:SetText(self._strConfig[self._currentMenuIndex])
end
function Window_WorldMap_TopMenuInfo:UpdateButtonTownMode()
  self._ui._static_MenuBg:SetShow(false)
  self._ui._static_SubMenuBg:SetShow(true)
  self._ui._staticRoundBg:SetShow(true)
  local receipeCount = ToClient_getTownReceipeList()
  self._ui._staticRoundBg:SetShow(0 ~= receipeCount)
  self._ui._staticText_TownTooltip:SetShow(0 ~= receipeCount)
end
function Window_WorldMap_TopMenuInfo:UpdateInfo(index)
  local eState = CppEnums.WorldMapState
  if self._prevMenuIndex == index then
    return
  end
  local renderState = index + 1
  if index >= 7 then
    renderState = eState.eWMS_EXPLORE_PLANT
  end
  self._isBlackFog = false
  if eState.eWMS_EXPLORE_PLANT == renderState then
    self._isGuildWarMode = false
  elseif eState.eWMS_GUILD_WAR == renderState then
    if true == self._config._isEnablePlunderGame then
    end
    self._isGuildWarMode = true
    renderState = eState.eWMS_EXPLORE_PLANT
  elseif eState.eWMS_PRODUCT_NODE == renderState then
    self._isBlackFog = true
    self._isGuildWarMode = false
    renderState = eState.eWMS_EXPLORE_PLANT
  else
    self._isGuildWarMode = false
  end
  ToClient_SetGuildMode(self._isGuildWarMode)
  ToClient_reloadNodeLine(self._isGuildWarMode, CppEnums.WaypointKeyUndefined)
  ToClient_WorldmapStateChange(renderState)
  self:UpdateFilder(index)
  ToClient_setDoTerrainHide(self._isBlackFog)
  if renderState == eState.eWMS_EXPLORE_PLANT then
    if true == self._stateFilterConfig[index][CppEnums.WorldMapCheckState.eCheck_Postions] then
      FGlobal_ActorTooltip_SetShowPartyMemberIcon(true)
    else
      FGlobal_ActorTooltip_SetShowPartyMemberIcon(false)
    end
  else
    FGlobal_ActorTooltip_SetShowPartyMemberIcon(false)
  end
  self._prevMenuIndex = index
end
function Window_WorldMap_TopMenuInfo:InitProductNodeFilter()
end
function PaGlobalFunc_WorldMap_TopMenu_GetIsGuildMode()
  local self = Window_WorldMap_TopMenuInfo
  return self._isGuildWarMode
end
function PaGlobalFunc_WorldMap_TopMenu_SetCurrentNodeInfo(NodeInfo)
  local self = Window_WorldMap_TopMenuInfo
  self._currentNodeInfo = NodeInfo
end
function PaGlobalFunc_FromClient_WorldMap_TopMenu_RenderStateChange(state)
  local self = Window_WorldMap_TopMenuInfo
  local eState = CppEnums.WorldMapState
  local eCheckState = CppEnums.WorldMapCheckState
  if true == _ContentsGroup_ForXBoxFinalCert then
    FromClient_WorldMapSideBar_RenderStateChange(state)
    return
  end
  local questShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Quest)
  local knowledgeShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Knowledge)
  local fishNChipShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_FishnChip)
  local nodeShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Node)
  local tradeShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Trade)
  local wayShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Way)
  local positionShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Postions)
  local wagonIsShow = ToClient_isWorldmapCheckState(eCheckState.eCheck_Wagon)
  if eState.eWMS_EXPLORE_PLANT == state then
    ToClient_worldmapNodeMangerSetShow(true)
    ToClient_worldmapBuildingManagerSetShow(true)
    ToClient_worldmapQuestManagerSetShow(questShow)
    ToClient_worldmapGuideLineSetShow(wayShow)
    ToClient_worldmapDeliverySetShow(wagonIsShow)
    ToClient_worldmapTerritoryManagerSetShow(true)
    ToClient_worldmapActorManagerSetShow(positionShow)
    ToClient_worldmapPinSetShow(positionShow)
    ToClient_worldmapGuildHouseSetShow(true, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapLifeKnowledgeSetShow(fishNChipShow, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapExceptionLifeKnowledgeSetShow(knowledgeShow, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapTradeNpcSetShow(tradeShow, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapHouseManagerSetShow(false, CppEnums.WaypointKeyUndefined)
    ToClient_SetGuildMode(PaGlobalFunc_WorldMap_TopMenu_GetIsGuildMode())
    ToClient_WorldmapBookMarkInfoSetShow(true)
  elseif eState.eWMS_REGION == state then
    ToClient_worldmapNodeMangerSetShow(false)
    ToClient_worldmapBuildingManagerSetShow(false)
    ToClient_worldmapQuestManagerSetShow(false)
    ToClient_worldmapGuideLineSetShow(false)
    ToClient_worldmapDeliverySetShow(false)
    ToClient_worldmapActorManagerSetShow(false)
    ToClient_worldmapPinSetShow(false)
    ToClient_worldmapTradeNpcSetShow(false, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapHouseManagerSetShow(false, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapLifeKnowledgeSetShow(fishNChipShow, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapExceptionLifeKnowledgeSetShow(knowledgeShow, CppEnums.WaypointKeyUndefined)
    ToClient_WorldmapBookMarkInfoSetShow(true)
  elseif eState.eWMS_LOCATION_INFO_WATER == state then
    ToClient_worldmapNodeMangerSetShow(false)
    ToClient_worldmapBuildingManagerSetShow(false)
    ToClient_worldmapQuestManagerSetShow(false)
    ToClient_worldmapGuideLineSetShow(false)
    ToClient_worldmapDeliverySetShow(false)
    ToClient_worldmapActorManagerSetShow(false)
    ToClient_worldmapPinSetShow(false)
    ToClient_worldmapTradeNpcSetShow(false, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapHouseManagerSetShow(false, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapLifeKnowledgeSetShow(fishNChipShow, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapExceptionLifeKnowledgeSetShow(knowledgeShow, CppEnums.WaypointKeyUndefined)
    ToClient_WorldmapBookMarkInfoSetShow(true)
  elseif eState.eWMS_LOCATION_INFO_CELCIUS == state then
    ToClient_worldmapNodeMangerSetShow(false)
    ToClient_worldmapBuildingManagerSetShow(false)
    ToClient_worldmapQuestManagerSetShow(false)
    ToClient_worldmapGuideLineSetShow(false)
    ToClient_worldmapDeliverySetShow(false)
    ToClient_worldmapActorManagerSetShow(false)
    ToClient_worldmapPinSetShow(false)
    ToClient_worldmapTradeNpcSetShow(false, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapHouseManagerSetShow(false, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapLifeKnowledgeSetShow(fishNChipShow, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapExceptionLifeKnowledgeSetShow(knowledgeShow, CppEnums.WaypointKeyUndefined)
    ToClient_WorldmapBookMarkInfoSetShow(true)
  elseif eState.eWMS_LOCATION_INFO_HUMIDITY == state then
    ToClient_worldmapNodeMangerSetShow(false)
    ToClient_worldmapBuildingManagerSetShow(false)
    ToClient_worldmapQuestManagerSetShow(false)
    ToClient_worldmapGuideLineSetShow(false)
    ToClient_worldmapDeliverySetShow(false)
    ToClient_worldmapActorManagerSetShow(false)
    ToClient_worldmapPinSetShow(false)
    ToClient_worldmapTradeNpcSetShow(false, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapHouseManagerSetShow(false, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapLifeKnowledgeSetShow(fishNChipShow, CppEnums.WaypointKeyUndefined)
    ToClient_worldmapExceptionLifeKnowledgeSetShow(knowledgeShow, CppEnums.WaypointKeyUndefined)
    ToClient_WorldmapBookMarkInfoSetShow(true)
  else
    _PA_LOG("\236\157\180\237\152\184\236\132\156", "\236\131\129\237\131\156 \236\157\184\235\141\177\236\138\164\234\176\128 \236\158\152\235\170\187 \235\147\164\236\150\180\236\153\148\236\138\181\235\139\136\235\139\164.")
  end
end
function Window_WorldMap_TopMenuInfo:InitControl()
  self._ui._menuButtonList = {}
  for index = 0, self._config._menuCount - 1 do
    self._ui._menuButtonList[index] = UI.getChildControl(self._ui._static_MenuBg, "RadioButton_" .. index + 1)
  end
  if false == self._config._isEnableBattle then
    self._ui._menuButtonList[5]:SetShow(false)
    self._ui._static_MenuBg:SetPosX(self._ui._static_MenuBg:GetPosX() + 70)
  else
    self._ui._menuButtonList[5]:SetShow(true)
  end
  local posXIndex = 0
  local standPosX = self._ui._menuButtonList[0]:GetPosX()
  for index = 0, self._config._menuCount - 1 do
    if true == self._ui._menuButtonList[index]:GetShow() then
      self._ui._menuButtonList[index]:SetPosX(standPosX + self._config._buttonGapX * posXIndex)
      posXIndex = posXIndex + 1
    end
  end
  self._ui._staticRoundBg = UI.getChildControl(self._ui._static_SubMenuBg, "Static_RoundBg")
  self._ui._staticText_TownTooltip = UI.getChildControl(self._ui._static_SubMenuBg, "StaticText_SelectedMenu")
  self._ui._staticText_Tooltip = UI.getChildControl(self._ui._static_MenuBg, "StaticText_SelectedMenu")
  self._ui.stc_keyGuideY = UI.getChildControl(self._ui._static_MenuBg, "Static_Y_ConsoleUI")
  self._ui.stc_keyGuideYLeftRight = UI.getChildControl(self._ui.stc_keyGuideY, "StaticText_YButtonToolTip")
  self._ui.stc_keyGuideYLeftRight:SetShow(false)
  self._ui.stc_keyGuideYDown:SetShow(false)
end
function Window_WorldMap_TopMenuInfo:InitEvent()
end
function Window_WorldMap_TopMenuInfo:InitRegister()
  registerEvent("FromClient_RenderStateChange", "PaGlobalFunc_FromClient_WorldMap_TopMenu_RenderStateChange")
end
function Window_WorldMap_TopMenuInfo:Initialize()
  self:InitControl()
  self:InitEvent()
  self:InitRegister()
end
function PaGlobalFunc_WorldMap_TopMenu_ChangeMode()
  local self = Window_WorldMap_TopMenuInfo
  if false == PaGlobalFunc_WorldMap_GetIsTownMode() then
    self:UpdateButtonWorldMode()
    self:UpdateInfo(self._currentMenuIndex)
    self:UpdateFilder(self._currentMenuIndex)
    self._ui._staticText_Title:SetText(self._worldmapTitleString)
  elseif nil ~= self._currentNodeInfo then
    local name = getExploreNodeName(self._currentNodeInfo:getStaticStatus())
    self._ui._staticText_Title:SetText(name)
    self:UpdateButtonTownMode()
  end
end
function PaGlobalFunc_WorldMap_TopMenu_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_WorldMap_TopMenu_SetShow(isShow, isAni)
  _panel:SetShow(isShow, isAni)
end
function PaGlobalFunc_WorldMap_TopMenu_Open()
  local self = Window_WorldMap_TopMenuInfo
  PaGlobalFunc_WorldMap_TopMenu_ChangeMode()
  if true == PaGlobalFunc_WorldMap_TopMenu_GetShow() then
    return
  end
  PaGlobalFunc_WorldMap_TopMenu_SetShow(true, false)
end
function PaGlobalFunc_WorldMap_TopMenu_Close()
  if false == PaGlobalFunc_WorldMap_TopMenu_GetShow() then
    return
  end
  PaGlobalFunc_WorldMap_TopMenu_SetShow(false, false)
end
function PaGlobalFunc_FromClient_WorldMap_TopMenu_luaLoadComplete()
  local self = Window_WorldMap_TopMenuInfo
  self:Initialize()
end
function PaGlobalFunc_WorldMap_TopMenu_OnYPressed(isPressed)
  local self = Window_WorldMap_TopMenuInfo
  self._ui.stc_keyGuideYLeftRight:SetShow(isPressed)
end
function PaGlobalFunc_WorldMap_TopMenu_ShowYDown(isShow)
  local self = Window_WorldMap_TopMenuInfo
  self._ui.stc_keyGuideYDown:SetShow(isShow)
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_FromClient_WorldMap_TopMenu_luaLoadComplete")

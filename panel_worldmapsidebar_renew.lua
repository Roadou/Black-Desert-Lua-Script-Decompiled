local _panel = Panel_Worldmap_Console
local STATE = CppEnums.WorldMapState
local VIEW_TOGGLE = CppEnums.WorldMapCheckState
local WorldMapSideBar = {
  _ui = {
    txt_panelTitle = UI.getChildControl(_panel, "StaticText_Title_Icon_Text"),
    txt_filterTitle = UI.getChildControl(_panel, "StaticText_Filter_Title"),
    stc_stateBG = UI.getChildControl(_panel, "Static_Category"),
    rdo_states = nil,
    btn_xBoxKey_LT = nil,
    btn_xBoxKey_RT = nil,
    txt_stateNameTag = nil,
    stc_stateNameTagMarker = nil,
    stc_viewToggleBG = UI.getChildControl(_panel, "Static_Category_Detail"),
    chk_viewToggles = nil,
    txt_selectedBox = nil,
    txt_infoTitle = UI.getChildControl(_panel, "StaticText_Info_Title"),
    stc_searchListBG = UI.getChildControl(_panel, "Static_Result_List"),
    rdo_searchByNodeTypes = nil,
    stc_searchTypePictogram = nil,
    frame_searchResult = nil,
    rdo_searchedItems = nil
  },
  _stateMax = 7,
  _viewToggleMax = 9,
  _searchTypeMax = 6,
  _currentState = nil,
  _isGuildWarMode = false,
  _isBlackFog = false,
  _viewToggles = nil,
  _selectNodeType = 1,
  _currentSearchCondition = nil,
  _currentSearchNodeType = nil,
  _searchResultCount = 0,
  _searchResultYGap = 40,
  _btnArray = nil,
  _isBlackFog = nil,
  _isGuildWarMode = nil
}
local _stateData = {
  [STATE.eWMS_EXPLORE_PLANT] = {
    tooltip = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_PLANT_NAME")
  },
  [STATE.eWMS_REGION] = {
    tooltip = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_REGION_NAME")
  },
  [STATE.eWMS_LOCATION_INFO_WATER] = {
    tooltip = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_WATER_NAME")
  },
  [STATE.eWMS_LOCATION_INFO_CELCIUS] = {
    tooltip = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_CELCIUS_NAME")
  },
  [STATE.eWMS_LOCATION_INFO_HUMIDITY] = {
    tooltip = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_HUMIDITY_NAME")
  },
  [STATE.eWMS_GUILD_WAR] = {
    tooltip = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_GUILDWAR_NAME")
  },
  [STATE.eWMS_PRODUCT_NODE] = {
    tooltip = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TOOLTIP_NODEFILTER")
  }
}
local _viewTogglesData = {
  [1] = {
    genericText = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_QUEST_NAME"),
    productNodeText = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODETYPE_0"),
    productNodeKey = -1
  },
  [2] = {
    genericText = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_KNOWLEDGE_NAME"),
    productNodeText = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODETYPE_1"),
    productNodeKey = CppEnums.ExplorationNodeType.eExplorationNodeType_Farm
  },
  [3] = {
    genericText = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_FISH_NAME"),
    productNodeText = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODETYPE_2"),
    productNodeKey = CppEnums.ExplorationNodeType.eExplorationNodeType_Collect
  },
  [4] = {
    genericText = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_NODE_NAME"),
    productNodeText = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODETYPE_3"),
    productNodeKey = CppEnums.ExplorationNodeType.eExplorationNodeType_Quarry
  },
  [5] = {
    genericText = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_DIRECTION_NAME"),
    productNodeText = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODETYPE_4"),
    productNodeKey = CppEnums.ExplorationNodeType.eExplorationNodeType_Logging
  },
  [6] = {
    genericText = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_WHERE_NAME"),
    productNodeText = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODETYPE_5"),
    productNodeKey = CppEnums.ExplorationNodeType.eExplorationNodeType_Craft
  },
  [7] = {
    genericText = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_TRADE_NAME"),
    productNodeText = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODETYPE_6"),
    productNodeKey = CppEnums.ExplorationNodeType.eExplorationNodeType_Excavation
  },
  [8] = {
    genericText = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_PANEL_TOOLTIP_WAGON"),
    productNodeText = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODETYPE_7"),
    productNodeKey = CppEnums.ExplorationNodeType.eExplorationNodeType_MonopolyFarm
  },
  [9] = {
    genericText = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_PANEL_TOOLTIP_MONSTERINFO_NAME")
  }
}
local SEARCH_BY = {
  NAME_OF_NODE = 0,
  NAME_OF_ITEM = 1,
  TYPE_OF_NODE = 2,
  PURPOSE = 3,
  GUILD_NAME = 4
}
local NODE_TYPE = {
  NORMAL = 1,
  VILLIAGE = 2,
  CITY = 3,
  GATE = 4,
  TRADE = 5,
  DANGEROUS = 6
}
local _nodeData = {
  [NODE_TYPE.NORMAL] = {
    nodeTypeName = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_NODETYPE_NORMAL"),
    key = 0
  },
  [NODE_TYPE.VILLIAGE] = {
    nodeTypeName = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_NODETYPE_VILIAGE"),
    key = 1
  },
  [NODE_TYPE.CITY] = {
    nodeTypeName = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_NODETYPE_CITY"),
    key = 2
  },
  [NODE_TYPE.GATE] = {
    nodeTypeName = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_NODETYPE_GATE"),
    key = 3
  },
  [NODE_TYPE.TRADE] = {
    nodeTypeName = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_NODETYPE_TRADE"),
    key = 5
  },
  [NODE_TYPE.DANGEROUS] = {
    nodeTypeName = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_NODETYPE_DANGEROUS"),
    key = 9
  }
}
function FromClient_luaLoadComplete_WorldMapSideBar_Init()
  WorldMapSideBar:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_WorldMapSideBar_Init")
function WorldMapSideBar:initialize()
  self._btnArray = {}
  self._ui.rdo_states = {}
  for ii = 1, self._stateMax do
    self._ui.rdo_states[ii] = UI.getChildControl(self._ui.stc_stateBG, "RadioButton_Category_" .. ii)
    self._ui.rdo_states[ii]:addInputEvent("Mouse_LUp", "Input_WorldMapSideBar_SetStateTo(" .. ii .. ")")
  end
  self._ui.btn_xBoxKey_LT = UI.getChildControl(self._ui.stc_stateBG, "Button_LT")
  self._ui.btn_xBoxKey_RT = UI.getChildControl(self._ui.stc_stateBG, "Button_RT")
  self._ui.txt_stateNameTag = UI.getChildControl(self._ui.stc_stateBG, "StaticText_Desc")
  self._ui.stc_stateNameTagMarker = UI.getChildControl(self._ui.txt_stateNameTag, "Static_Marker")
  self._viewToggles = {}
  self._ui.chk_viewToggles = {}
  for ii = 1, self._viewToggleMax do
    self._ui.chk_viewToggles[ii] = UI.getChildControl(self._ui.stc_viewToggleBG, "CheckButton_ViewToggle_" .. ii)
  end
  self._ui.txt_selectedBox = UI.getChildControl(self._ui.stc_viewToggleBG, "StaticText_Selected_Box")
  self._ui.txt_selectedBox:SetShow(false)
  self._ui.rdo_searchByNodeTypes = {}
  for ii = 1, self._searchTypeMax do
    self._ui.rdo_searchByNodeTypes[ii] = UI.getChildControl(self._ui.stc_searchListBG, "RadioButton_NodeType_" .. ii)
    self._ui.rdo_searchByNodeTypes[ii]:addInputEvent("Mouse_LUp", "Input_WorldMapSideBar_SearchByNodeType(" .. ii .. ")")
  end
  self._ui.frame_searchResult = UI.getChildControl(self._ui.stc_searchListBG, "Frame_NodeList")
  self._ui.rdo_searchedItems = {}
  self._currentState = STATE.eWMS_EXPLORE_PLANT
  self._currentSearchNodeType = NODE_TYPE.CITY
  self:registEventHandler()
  self:registMessageHandler()
end
function WorldMapSideBar:registEventHandler()
end
function WorldMapSideBar:registMessageHandler()
  _panel:RegisterShowEventFunc(true, "PaGlobalFunc_ WorldMapSideBar_ShowAni()")
  _panel:RegisterShowEventFunc(false, "PaGlobalFunc_ WorldMapSideBar_HideAni()")
  registerEvent("FromClient_NodeFilterOn", "FromClient_WorldMapSideBar_NodeFilterOn")
end
function PaGlobalFunc_WorldMapSideBar_Open(sustainStates)
  WorldMapSideBar:open(sustainStates)
end
function WorldMapSideBar:open(sustainStates)
  _panel:SetShow(true, true)
  if not sustainStates then
    for ii = 1, self._stateMax do
      self._viewToggles[ii] = {}
      for jj = 1, self._viewToggleMax do
        if ii == STATE.eWMS_EXPLORE_PLANT then
          self._viewToggles[ii][jj] = ToClient_isWorldmapCheckState(jj - 1)
        else
          self._viewToggles[ii][jj] = false
        end
      end
    end
  end
  self._viewToggles[STATE.eWMS_GUILD_WAR][VIEW_TOGGLE.eCheck_Node] = true
  self._viewToggles[STATE.eWMS_GUILD_WAR][VIEW_TOGGLE.eCheck_Postions] = true
  self._viewToggles[STATE.eWMS_PRODUCT_NODE][VIEW_TOGGLE.eCheck_Node] = true
  self._ui.stc_searchTypePictogram = {}
  for ii = 1, self._searchTypeMax do
    self._ui.stc_searchTypePictogram[ii] = UI.getChildControl(self._ui.rdo_searchByNodeTypes[ii], "Static_Pictogram_On_" .. ii)
  end
  self._ui.rdo_states[self._currentState]:SetCheck(true)
  self:updateStateButtons(self._currentState)
  self:updateViewTogglesByState(self._currentState)
  self:updateSearchList()
end
function WorldMapSideBar_ShowAni()
end
function WorldMapSideBar_HideAni()
end
function PaGlobalFunc_WorldMapSidebar_PerFrameUpdate(deltaTime)
end
function WorldMapSideBar:updateStateButtons(state)
  local radio = self._ui.rdo_states[state]
  local tag = self._ui.txt_stateNameTag
  radio:SetCheck(true)
  tag:SetText(_stateData[state].tooltip)
  tag:SetSize(tag:GetTextSizeX() + 28, tag:GetSizeY())
  tag:SetPosX(radio:GetPosX() + radio:GetSizeX() / 2 - tag:GetSizeX() / 2)
  self._ui.stc_stateNameTagMarker:ComputePos()
end
function WorldMapSideBar:updateViewTogglesByState(state)
  local toggleButton = self._ui.chk_viewToggles
  if STATE.eWMS_PRODUCT_NODE == state then
    for ii = 1, self._viewToggleMax do
      if nil ~= _viewTogglesData[ii].productNodeText then
        toggleButton[ii]:SetShow(true)
        toggleButton[ii]:SetText(_viewTogglesData[ii].productNodeText)
        toggleButton[ii]:removeInputEvent("Mouse_LUp")
        toggleButton[ii]:addInputEvent("Mouse_LUp", "Input_WorldMapSideBar_SetViewToggleWhenProductState(" .. ii .. ")")
        if ii == self._selectNodeType then
          toggleButton[ii]:SetCheck(true)
        else
          toggleButton[ii]:SetCheck(false)
        end
      else
        toggleButton[ii]:SetShow(false)
      end
    end
  else
    for ii = 1, self._viewToggleMax do
      toggleButton[ii]:SetShow(true)
      toggleButton[ii]:SetText(_viewTogglesData[ii].genericText)
      toggleButton[ii]:SetCheck(self._viewToggles[state][ii])
      toggleButton[ii]:removeInputEvent("Mouse_LUp")
      toggleButton[ii]:addInputEvent("Mouse_LUp", "Input_WorldMapSideBar_SetViewToggle(" .. ii .. ")")
      ToClient_WorldmapCheckState(ii - 1, toggleButton[ii]:IsCheck(), false)
    end
  end
end
function WorldMapSideBar:updateSearchList()
  if self._searchTypeMax < 1 then
    return
  end
  local pictograms = self._ui.stc_searchTypePictogram
  for ii = 1, self._searchTypeMax do
    pictograms[ii]:SetShow(false)
  end
  pictograms[self._currentSearchNodeType]:SetShow(true)
  local loopCount = math.max(#self._ui.rdo_searchedItems, self._searchResultCount)
  for ii = 1, loopCount do
    if ii <= self._searchResultCount then
      if nil == self._ui.rdo_searchedItems[ii] then
        self._ui.rdo_searchedItems[ii] = UI.getChildControl(self._ui.frame_searchResult:GetFrameContent(), "RadioButton_Item_" .. ii)
        if nil == self._ui.rdo_searchedItems[ii] then
          self._ui.rdo_searchedItems[ii] = UI.createAndCopyBasePropertyControl(self._ui.frame_searchResult:GetFrameContent(), "RadioButton_Item", self._ui.frame_searchResult:GetFrameContent(), "RadioButton_Item_" .. ii)
        end
      end
      local resultItem = self._ui.rdo_searchedItems[ii]
      resultItem:SetShow(true)
      resultItem:SetPosY((ii - 1) * self._searchResultYGap + 11)
      resultItem:SetText(ToClient_getFindResultNameByIndex(ii - 1))
    elseif nil ~= self._ui.rdo_searchedItems[ii] then
      self._ui.rdo_searchedItems[ii]:SetShow(false)
    end
  end
  self._ui.frame_searchResult:GetVScroll():SetControlTop()
end
function Input_WorldMapSideBar_SetStateTo(state)
  local self = WorldMapSideBar
  self._currentState = state
  local renderState = state
  if STATE.eWMS_GUILD_WAR == state then
    renderState = STATE.eWMS_EXPLORE_PLANT
    self._isBlackFog = false
    self._isGuildWarMode = true
  elseif STATE.eWMS_PRODUCT_NODE == state then
    renderState = STATE.eWMS_EXPLORE_PLANT
    self._isBlackFog = true
    self._isGuildWarMode = false
  else
    self._isBlackFog = false
    self._isGuildWarMode = false
  end
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  ToClient_SetGuildMode(self._isGuildWarMode)
  ToClient_reloadNodeLine(self._isGuildWarMode, CppEnums.WaypointKeyUndefined)
  ToClient_WorldmapStateChange(renderState)
  ToClient_setDoTerrainHide(self._isBlackFog)
  self:updateStateButtons(state)
  self:updateViewTogglesByState(state)
end
function Input_WorldMapSideBar_SetViewToggle(index)
  local self = WorldMapSideBar
  local withSave = self._currentState == STATE.eWMS_EXPLORE_PLANT
  local checkButton = self._ui.chk_viewToggles
  ToClient_WorldmapCheckState(index - 1, checkButton[index]:IsCheck(), withSave)
  if withSave then
    self._viewToggles[self._currentState][index - 1] = checkButton[index]:IsCheck()
  end
end
function Input_WorldMapSideBar_SetViewToggleWhenProductState(index)
  local self = WorldMapSideBar
  self._selectNodeType = index
  PaGlobalFunc_WorldMapSideBar_EraseArrow()
  self:eraseArrow()
  ToClient_FilterNodeType(-1, _viewTogglesData[index].productNodeKey)
  self:updateViewTogglesByState(self._currentState)
end
function Input_WorldMapSideBar_SearchByNodeType(nodeType)
  local self = WorldMapSideBar
  self._currentSearchCondition = SEARCH_BY.TYPE_OF_NODE
  self._currentSearchNodeType = nodeType
  self._searchResultCount = ToClient_FindNodeByType(_nodeData[nodeType].key)
  self:updateSearchList()
end
function PaGlobalFunc_WorldMapSideBar_IsGuildWarMode()
  return STATE.eWMS_GUILD_WAR == WorldMapSideBar._currentState
end
function FromClient_WorldMapSideBar_NodeFilterOn(house_btn)
  local self = WorldMapSideBar
  local btn = house_btn
  table.insert(self._btnArray, btn)
  local nodeType = btn:FromClient_getExplorationNodeInClient():getStaticStatus()._nodeType
  local textureLink = ""
  if CppEnums.ExplorationNodeType.eExplorationNodeType_Trade == nodeType then
    textureLink = "new_ui_common_forlua/widget/worldmap/TradeNode_Sequence.dds"
  elseif CppEnums.ExplorationNodeType.eExplorationNodeType_Dangerous == nodeType then
    textureLink = "new_ui_common_forlua/widget/worldmap/DangerNode_Sequence.dds"
  elseif CppEnums.ExplorationNodeType.eExplorationNodeType_Normal == nodeType then
    textureLink = "new_ui_common_forlua/widget/worldmap/Node_Sequence.dds"
  elseif CppEnums.ExplorationNodeType.eExplorationNodeType_Viliage == nodeType then
    textureLink = "new_ui_common_forlua/widget/worldmap/VillageNode_Sequence.dds"
  end
  if "" ~= textureLink then
    btn:getBaseTextureInfo():setVertexAnimation(4, 4, 0.1, CppEnums.PA_UI_ANI_TYPE.PA_UI_ANI_INFINITE)
    btn:ChangeTextureInfoName(textureLink)
  end
  btn:EraseAllEffect()
  btn:AddEffect("UI_ArrowMark_Diagonal01", true, 70, 80)
end
function PaGlobalFunc_WorldMapSideBar_ResetFilter()
  local self = WorldMapSideBar
  self:eraseArrow()
  ToClient_FilterNodeType(-1, _viewTogglesData[self._selectNodeType].productNodeKey)
end
function PaGlobalFunc_WorldMapSideBar_EraseArrow()
  WorldMapSideBar:eraseArrow()
end
function WorldMapSideBar:eraseArrow()
  if nil == self._btnArray then
    return
  end
  for v, btn in pairs(self._btnArray) do
    btn:EraseAllEffect()
    btn:getBaseTextureInfo():setVertexAnimation(1, 1, 0, CppEnums.PA_UI_ANI_TYPE.PA_UI_ANI_ONETIME_DISAPPEAR)
    local nodeType = btn:FromClient_getExplorationNodeInClient():getStaticStatus()._nodeType
    if CppEnums.ExplorationNodeType.eExplorationNodeType_Trade == nodeType then
      btn:ChangeTextureInfoName("New_UI_Common_forLua/Widget/worldmap/worldmap_icon_03.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(btn, 344, 203, 512, 399)
      btn:getBaseTexture():setUV(x1, y1, x2, y2)
      btn:setRenderTexture(btn:getBaseTexture())
      btn:ChangeOnTextureInfoName("New_UI_Common_forLua/Widget/Dialogue/worldmap_icon_03.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(btn, 344, 4, 511, 200)
      btn:getOnTexture():setUV(x1, y1, x2, y2)
    elseif CppEnums.ExplorationNodeType.eExplorationNodeType_Dangerous == nodeType then
      btn:ChangeTextureInfoName("New_UI_Common_forLua/Widget/worldmap/worldmap_icon_04.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(btn, 0, 203, 167, 398)
      btn:getBaseTexture():setUV(x1, y1, x2, y2)
      btn:setRenderTexture(btn:getBaseTexture())
      btn:ChangeOnTextureInfoName("New_UI_Common_forLua/Widget/Dialogue/worldmap_icon_04.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(btn, 0, 4, 167, 199)
      btn:getOnTexture():setUV(x1, y1, x2, y2)
    elseif CppEnums.ExplorationNodeType.eExplorationNodeType_Normal == nodeType then
      btn:ChangeTextureInfoName("New_UI_Common_forLua/Widget/worldmap/worldmap_icon_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(btn, 171, 203, 340, 399)
      btn:getBaseTexture():setUV(x1, y1, x2, y2)
      btn:setRenderTexture(btn:getBaseTexture())
      btn:ChangeOnTextureInfoName("New_UI_Common_forLua/Widget/Dialogue/worldmap_icon_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(btn, 171, 4, 340, 200)
      btn:getOnTexture():setUV(x1, y1, x2, y2)
    elseif CppEnums.ExplorationNodeType.eExplorationNodeType_Viliage == nodeType then
      btn:ChangeTextureInfoName("New_UI_Common_forLua/Widget/worldmap/worldmap_icon_02.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(btn, 0, 203, 168, 399)
      btn:getBaseTexture():setUV(x1, y1, x2, y2)
      btn:setRenderTexture(btn:getBaseTexture())
      btn:ChangeOnTextureInfoName("New_UI_Common_forLua/Widget/Dialogue/worldmap_icon_02.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(btn, 0, 4, 168, 200)
      btn:getOnTexture():setUV(x1, y1, x2, y2)
    end
  end
  self._btnArray = {}
end
function FromClient_WorldMapSideBar_RenderStateChange(state)
  if STATE.eWMS_EXPLORE_PLANT == state then
    local questShow = ToClient_isWorldmapCheckState(VIEW_TOGGLE.eCheck_Quest)
    local knowledgeShow = ToClient_isWorldmapCheckState(VIEW_TOGGLE.eCheck_Knowledge)
    local fishNChipShow = ToClient_isWorldmapCheckState(VIEW_TOGGLE.eCheck_FishnChip)
    local nodeShow = ToClient_isWorldmapCheckState(VIEW_TOGGLE.eCheck_Node)
    local tradeShow = ToClient_isWorldmapCheckState(VIEW_TOGGLE.eCheck_Trade)
    local wayShow = ToClient_isWorldmapCheckState(VIEW_TOGGLE.eCheck_Way)
    local positionShow = ToClient_isWorldmapCheckState(VIEW_TOGGLE.eCheck_Postions)
    local wagonIsShow = ToClient_isWorldmapCheckState(VIEW_TOGGLE.eCheck_Wagon)
    ToClient_worldmapNodeMangerSetShow(nodeShow)
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
    ToClient_SetGuildMode(PaGlobalFunc_WorldMapSideBar_IsGuildWarMode())
  elseif STATE.eWMS_REGION == state then
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
  elseif STATE.eWMS_LOCATION_INFO_WATER == state then
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
  elseif STATE.eWMS_LOCATION_INFO_CELCIUS == state then
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
  elseif STATE.eWMS_LOCATION_INFO_HUMIDITY == state then
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
  end
end
function PaGlobalFunc_WorldMapSideBar_RetreatToWorldMapMode()
  ClearFocusEdit()
  SetUIMode(Defines.UIMode.eUIMode_WorldMap)
end
function PaGlobalFunc_WorldMapSideBar_Close()
  WorldMapSideBar:close()
end
function WorldMapSideBar:close()
  _panel:SetShow(false, false)
end

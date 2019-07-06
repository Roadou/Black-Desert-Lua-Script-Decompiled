local UI_TYPE = CppEnums.PA_UI_CONTROL_TYPE
local ENT = CppEnums.ExplorationNodeType
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
local UI_TM = CppEnums.TextMode
local UI_PP = CppEnums.PAUIMB_PRIORITY
local UI_TT = CppEnums.PAUI_TEXTURE_TYPE
local nodeStaticStatus, _wayPointKey
local isProgressReset = false
local _currentNodeLv
local static_TitleBG = UI.getChildControl(Panel_NodeMenu, "Static_TitleBG")
local Txt_Node_Name = UI.getChildControl(static_TitleBG, "MainMenu_Title")
local static_MainMenuBG = UI.getChildControl(Panel_NodeMenu, "MainMenu_Bg")
local Txt_Node_Title = UI.getChildControl(static_MainMenuBG, "MainMenu_Title")
local Txt_NodeManager = UI.getChildControl(Panel_NodeMenu, "MainMenu_StaticText_NodeManager")
local static_NodeManagerBG = UI.getChildControl(Panel_NodeMenu, "MainMenu_Bg")
local Txt_NodeManager_Name = UI.getChildControl(Panel_NodeMenu, "MainMenu_StaticText_NodeManager_Value")
local Txt_Node_Desc = UI.getChildControl(Panel_NodeMenu, "MainMenu_StaticText_NodeLinkStatus")
local Tex_NeedExplorePoint = UI.getChildControl(Panel_NodeMenu, "MainMenu_NeedExplorePoint_LinkIcon")
local Txt_NeedExplorePoint = UI.getChildControl(Panel_NodeMenu, "MainMenu_NeedExplorePoint_Link_Value")
local Btn_NodeLink = UI.getChildControl(Panel_NodeMenu, "MainMenu_Button_NodeLink")
local Btn_NearNode = UI.getChildControl(Panel_NodeMenu, "MainMenu_Button_NearNode")
local Btn_NodeUnlink = UI.getChildControl(Panel_NodeMenu, "MainMenu_Button_NodeUnLink")
local Tex_ExplorePoint_BG = UI.getChildControl(Panel_NodeMenu, "MainMenu_ExplorePoint_Bg")
local Stc_ExplorePoint_Icon = UI.getChildControl(Tex_ExplorePoint_BG, "MainMenu_ExplorePoint_Icon")
local Txt_ExplorePoint_Value = UI.getChildControl(Tex_ExplorePoint_BG, "MainMenu_ExplorePoint_Value")
local NodeLevelGroup = {
  Btn_NodeLev = UI.getChildControl(Panel_NodeMenu, "MainMenu_Button_NodeLev"),
  Txt_NodeLevel = UI.getChildControl(Panel_NodeMenu, "MainMenu_CurrentNodeLevel"),
  Tex_ProgressBG = UI.getChildControl(Panel_NodeMenu, "MainMenu_ProgressBg_NodeLev"),
  Progress_NodeLevel = UI.getChildControl(Panel_NodeMenu, "MainMenu_Progress_NodeLev"),
  Btn_NodeLevHelp = UI.getChildControl(Panel_NodeMenu, "MainMenu_NodelLev_Help")
}
local savedisMaxLevel = false
local NodeWarGroup = {}
local function nodeMenu_init()
  NodeLevelGroup.Btn_NodeLevHelp:addInputEvent("Mouse_On", "HandleOnout_GrandWorldMap_NodeMenu_explorePointHelp( true, " .. 0 .. " )")
  NodeLevelGroup.Btn_NodeLevHelp:addInputEvent("Mouse_Out", "HandleOnout_GrandWorldMap_NodeMenu_explorePointHelp( false, " .. 0 .. " )")
  NodeLevelGroup.Btn_NodeLevHelp:setTooltipEventRegistFunc("HandleOnout_GrandWorldMap_NodeMenu_explorePointHelp( true, " .. 0 .. " )")
  static_TitleBG:SetSize(getScreenSizeX(), static_TitleBG:GetSizeY())
  static_TitleBG:ComputePos()
end
local IconType = {
  Country = 0,
  Territory = 1,
  NodeType = 2,
  Weather = 3
}
local NodeIconArray = {
  [IconType.Country] = UI.getChildControl(Panel_NodeMenu, "MainMenu_Contry"),
  [IconType.Territory] = UI.getChildControl(Panel_NodeMenu, "MainMenu_City"),
  [IconType.NodeType] = UI.getChildControl(Panel_NodeMenu, "MainMenu_NodeType")
}
NodeLevelGroup.Btn_NodeLev:SetAutoDisableTime(0.3)
local nodeButtonTextSwitchCaseList = {
  [ENT.eExplorationNodeType_Normal] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_EMPTY"),
  [ENT.eExplorationNodeType_Viliage] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_VILIAGE"),
  [ENT.eExplorationNodeType_City] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_CITY"),
  [ENT.eExplorationNodeType_Gate] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_GATE"),
  [ENT.eExplorationNodeType_Farm] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_FARM"),
  [ENT.eExplorationNodeType_Trade] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_FILTRATION"),
  [ENT.eExplorationNodeType_Collect] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_COLLECT"),
  [ENT.eExplorationNodeType_Quarry] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_QUARRY"),
  [ENT.eExplorationNodeType_Logging] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_LOGGING"),
  [ENT.eExplorationNodeType_Dangerous] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_DECOTREE"),
  [ENT.eExplorationNodeType_Finance] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_FINANCE"),
  [ENT.eExplorationNodeType_FishTrap] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_FISHTRAP"),
  [ENT.eExplorationNodeType_MinorFinance] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_MINORFINANCE"),
  [ENT.eExplorationNodeType_MonopolyFarm] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TYPE_MONOPOLYFARM")
}
local NodeTextType = {
  NODE_DESCRIPTION = 0,
  NODE_NATIONAL_TITLE = 1,
  NODE_NATIONAL_TEXT = 2,
  NODE_TERRITORY_TITLE = 3,
  NODE_TERRITORY_TEXT = 4,
  NODE_AFFILIATEDTOWN_TITLE = 5,
  NODE_AFFILIATEDTOWN_TEXT = 6,
  NODE_MANAGER_TITLE = 7,
  NODE_MANAGER_TEXT = 8,
  NODE_POINT_TEXT = 9,
  NODE_SUPPORT_TEXT = 10,
  NODE_MONEY_TEXT = 11,
  NODE_ITEM1_TEXT = 12,
  NODE_ITEM2_TEXT = 13,
  NODE_ITEM3_TEXT = 14,
  NODE_FINDMANGER_TEXT = 15,
  NODE_UNUPGRADE_TEXT = 16,
  NODE_UNWITHDRAW_TEXT = 17,
  NODE_LAST = 18
}
local NodeTextColor = {
  [NodeTextType.NODE_DESCRIPTION] = UI_color.C_FFFFFFFF,
  [NodeTextType.NODE_NATIONAL_TITLE] = UI_color.C_FFC4BEBE,
  [NodeTextType.NODE_NATIONAL_TEXT] = UI_color.C_FFFAE696,
  [NodeTextType.NODE_TERRITORY_TITLE] = UI_color.C_FFC4BEBE,
  [NodeTextType.NODE_TERRITORY_TEXT] = UI_color.C_FFFAE696,
  [NodeTextType.NODE_AFFILIATEDTOWN_TITLE] = UI_color.C_FFC4BEBE,
  [NodeTextType.NODE_AFFILIATEDTOWN_TEXT] = UI_color.C_FFFAE696,
  [NodeTextType.NODE_MANAGER_TITLE] = UI_color.C_FFC4BEBE,
  [NodeTextType.NODE_MANAGER_TEXT] = UI_color.C_FF6DC6FF,
  [NodeTextType.NODE_POINT_TEXT] = UI_color.C_FFFF7C67,
  [NodeTextType.NODE_SUPPORT_TEXT] = UI_color.C_FFFF7C67,
  [NodeTextType.NODE_MONEY_TEXT] = UI_color.C_FF67FFA4,
  [NodeTextType.NODE_ITEM1_TEXT] = UI_color.C_FF67FFA4,
  [NodeTextType.NODE_ITEM2_TEXT] = UI_color.C_FF67FFA4,
  [NodeTextType.NODE_ITEM3_TEXT] = UI_color.C_FF67FFA4,
  [NodeTextType.NODE_FINDMANGER_TEXT] = UI_color.C_FF6DC6FF,
  [NodeTextType.NODE_UNUPGRADE_TEXT] = UI_color.C_FFFF4729,
  [NodeTextType.NODE_UNWITHDRAW_TEXT] = UI_color.C_FF88DF00
}
local NodeTextString = {
  [NodeTextType.NODE_NATIONAL_TITLE] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_NATIONAL"),
  [NodeTextType.NODE_TERRITORY_TITLE] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_TERRITORY"),
  [NodeTextType.NODE_MANAGER_TITLE] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_MANAGER"),
  [NodeTextType.NODE_AFFILIATEDTOWN_TITLE] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_AFFILIATEDTOWN"),
  [NodeTextType.NODE_POINT_TEXT] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_CONTRIBUTIVENESS"),
  [NodeTextType.NODE_MONEY_TEXT] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_GOLD"),
  [NodeTextType.NODE_FINDMANGER_TEXT] = PAGetString(Defines.StringSheet_GAME, "PANEL_WORLDMAP_FINDNODEMANAGER")
}
local NodeTextControl = {}
local SetFontColorAndText = function(uiControl, text, color)
  uiControl:SetText(text)
  uiControl:SetFontColor(color)
end
function OnNearNodeClick(nodeKey)
  if true == PaGlobal_TutorialManager:isDoingTutorial() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RADER_TUTORIAL_PROGRSS_ACK"))
    return
  end
  ToClient_DeleteNaviGuideByGroup(0)
  ToClient_WorldMapFindNearNode(nodeKey, NavigationGuideParam())
  audioPostEvent_SystemUi(0, 14)
  _AudioPostEvent_SystemUiForXBOX(0, 14)
  FGlobal_WorldMapWindowEscape()
end
function OnNodeUpgradeClick(nodeKey)
  isProgressReset = true
  ToClient_WorldMapRequestUpgradeExplorationNode(nodeKey)
  PaGlobal_TutorialManager:handleOnNodeUpgradeClick(nodeKey)
end
function OnNodeWithdrawClick(nodeKey)
  local function NodeWithdrawExecute()
    ToClient_WorldMapRequestWithdrawPlant(nodeKey)
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
local MakeNodeWeatherStatus = function(nodeKey)
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
  return "[" .. strWeatherCloudRate .. "/" .. strWeatherRainAmount .. "/" .. strWeatherCelsius .. "]"
end
local function FillContryInfo(nodeStaticStatus)
  local countryIcon = NodeIconArray[IconType.Country]
  if tostring(getNodeNationalName(nodeStaticStatus)) == PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_CONTRY_KALPEON") then
    countryIcon:ChangeTextureInfoName("Renewal/ETC/WordMap/territorymark_Calpheon_Small.dds")
  elseif tostring(getNodeNationalName(nodeStaticStatus)) == PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_CONTRY_BALENCIA") then
    countryIcon:ChangeTextureInfoName("Renewal/ETC/WordMap/territorymark_valencia_Small.dds")
  elseif tostring(getNodeNationalName(nodeStaticStatus)) == PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_CONTRY_MEDIA") then
    countryIcon:ChangeTextureInfoName("Renewal/ETC/WordMap/territorymark_mediah_Small.dds")
  elseif tostring(getNodeNationalName(nodeStaticStatus)) == PAGetString(Defines.StringSheet_GAME, "LUA_CONTRYNAME_6") then
    countryIcon:ChangeTextureInfoName("Renewal/ETC/WordMap/territorymark_Kamasylvia_Small.dds")
  elseif tostring(getNodeNationalName(nodeStaticStatus)) == PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYSTRING_0") then
    countryIcon:ChangeTextureInfoName("Renewal/ETC/WordMap/territorymark_valenos_Small.dds")
  elseif tostring(getNodeNationalName(nodeStaticStatus)) == PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYSTRING_1") then
    countryIcon:ChangeTextureInfoName("Renewal/ETC/WordMap/territorymark_selendia_Small.dds")
  elseif tostring(getNodeNationalName(nodeStaticStatus)) == PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_7") then
    countryIcon:ChangeTextureInfoName("Renewal/ETC/WordMap/territorymark_Drigan_Small.dds")
  end
  local x1, y1, x2, y2 = setTextureUV_Func(countryIcon, 0, 0, 20, 20)
  countryIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  countryIcon:setRenderTexture(countryIcon:getBaseTexture())
  countryIcon:SetText(getNodeNationalName(nodeStaticStatus))
  countryIcon:SetFontColor(NodeTextColor[NodeTextType.NODE_NATIONAL_TEXT])
end
local function FillTerritoryInfo(nodeStaticStatus)
  local territoryIcon = NodeIconArray[IconType.Territory]
  territoryIcon:SetShow(true)
  if tostring(getNodeTerritoryName(nodeStaticStatus)) == PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_CONTRY_KALPEON") then
    territoryIcon:ChangeTextureInfoName("Renewal/ETC/WordMap/territorymark_Calpheon_Small.dds")
  elseif tostring(getNodeTerritoryName(nodeStaticStatus)) == PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_CONTRY_BALENCIA") then
    territoryIcon:ChangeTextureInfoName("Renewal/ETC/WordMap/territorymark_valencia_Small.dds")
  elseif tostring(getNodeTerritoryName(nodeStaticStatus)) == PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODE_CONTRY_MEDIA") then
    territoryIcon:ChangeTextureInfoName("Renewal/ETC/WordMap/territorymark_mediah_Small.dds")
  elseif tostring(getNodeTerritoryName(nodeStaticStatus)) == PAGetString(Defines.StringSheet_GAME, "LUA_CONTRYNAME_6") then
    territoryIcon:ChangeTextureInfoName("Renewal/ETC/WordMap/territorymark_Kamasylvia_Small.dds")
  elseif tostring(getNodeTerritoryName(nodeStaticStatus)) == PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYSTRING_0") then
    territoryIcon:ChangeTextureInfoName("Renewal/ETC/WordMap/territorymark_valenos_Small.dds")
  elseif tostring(getNodeTerritoryName(nodeStaticStatus)) == PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYSTRING_1") then
    territoryIcon:ChangeTextureInfoName("Renewal/ETC/WordMap/territorymark_selendia_Small.dds")
  elseif tostring(getNodeTerritoryName(nodeStaticStatus)) == PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_7") then
    territoryIcon:ChangeTextureInfoName("Renewal/ETC/WordMap/territorymark_Drigan_Small.dds")
  else
    territoryIcon:SetShow(false)
  end
  local x1, y1, x2, y2 = setTextureUV_Func(territoryIcon, 0, 0, 20, 20)
  territoryIcon:getBaseTexture():setUV(x1, y1, x2, y2)
  territoryIcon:setRenderTexture(territoryIcon:getBaseTexture())
  territoryIcon:SetText(getNodeTerritoryName(nodeStaticStatus))
  territoryIcon:SetFontColor(NodeTextColor[NodeTextType.NODE_TERRITORY_TEXT])
end
local function FillExploreUpgradeAble(nodeStaticStatus, nodeKey)
  local needPoint = getPlantNeedPoint()
  if needPoint > 0 then
    local contributeText = NodeTextString[NodeTextType.NODE_POINT_TEXT] .. " : " .. tostring(needPoint)
    Txt_NeedExplorePoint:SetText(contributeText)
  end
  local recipeItems = getPlantInvestItemList(nodeStaticStatus)
  local needPoint = getPlantNeedPoint()
  local supportPoint = getPlantNeedSupportPoint()
  local needMoney = getPlantNeedMoney()
  if ToClient_isAbleInvestnWithdraw(nodeKey) then
    Btn_NodeLink:SetShow(true)
    Btn_NodeLink:addInputEvent("Mouse_LUp", "OnNodeUpgradeClick(" .. tostring(nodeKey) .. ")")
    Btn_NodeLink:addInputEvent("Mouse_On", "HandleOnOut_Contribution_ButtonTooltip ( true )")
    Btn_NodeLink:addInputEvent("Mouse_Out", "HandleOnOut_Contribution_ButtonTooltip ( false )")
  else
    Txt_Node_Desc:SetAutoResize(true)
    Txt_Node_Desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
    Txt_Node_Desc:SetText(NodeTextString[NodeTextType.NODE_FINDMANGER_TEXT])
    Txt_Node_Desc:SetShow(true)
  end
end
function HandleOnOut_Contribution_ButtonTooltip(isShow)
  if isShow then
    local title = ""
    title = PAGetString(Defines.StringSheet_RESOURCE, "WORLDMAP_NODE_BTN_REQUIRE")
    local desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_CONTRIBUTIONTOOLTIP")
    TooltipSimple_Show(Btn_NodeLink, title, desc)
  else
    TooltipSimple_Hide()
  end
end
function HandledMouseEvent_FillNodeInfo(isShow, nodeType, nodeKey)
  local name, desc, control
  if nil ~= nodeType and nil ~= nodeKey then
    name = nodeButtonTextSwitchCaseList[nodeType] .. " - " .. MakeNodeWeatherStatus(nodeKey)
    control = NodeMenu.Type
  end
  if true == isShow then
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
local function SetNodeType(nodeType)
  local uiControl = NodeIconArray[IconType.NodeType]
  uiControl:SetShow(true)
  if 0 == tonumber(nodeType) then
    uiControl:ChangeTextureInfoName("new_ui_common_forlua/widget/worldmap/WorldMap_Etc_05.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(uiControl, 1, 253, 20, 272)
    uiControl:getBaseTexture():setUV(x1, y1, x2, y2)
    uiControl:setRenderTexture(uiControl:getBaseTexture())
  elseif 1 == tonumber(nodeType) then
    uiControl:ChangeTextureInfoName("new_ui_common_forlua/widget/worldmap/WorldMap_Etc_05.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(uiControl, 21, 253, 40, 272)
    uiControl:getBaseTexture():setUV(x1, y1, x2, y2)
    uiControl:setRenderTexture(uiControl:getBaseTexture())
  elseif 2 == tonumber(nodeType) then
    uiControl:ChangeTextureInfoName("new_ui_common_forlua/widget/worldmap/WorldMap_Etc_05.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(uiControl, 41, 253, 60, 272)
    uiControl:getBaseTexture():setUV(x1, y1, x2, y2)
    uiControl:setRenderTexture(uiControl:getBaseTexture())
  elseif 3 == tonumber(nodeType) then
    uiControl:ChangeTextureInfoName("new_ui_common_forlua/widget/worldmap/WorldMap_Etc_05.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(uiControl, 61, 253, 80, 272)
    uiControl:getBaseTexture():setUV(x1, y1, x2, y2)
    uiControl:setRenderTexture(uiControl:getBaseTexture())
  elseif 5 == tonumber(nodeType) then
    uiControl:ChangeTextureInfoName("new_ui_common_forlua/widget/worldmap/WorldMap_Etc_05.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(uiControl, 81, 253, 100, 272)
    uiControl:getBaseTexture():setUV(x1, y1, x2, y2)
    uiControl:setRenderTexture(uiControl:getBaseTexture())
  elseif 9 == tonumber(nodeType) then
    uiControl:ChangeTextureInfoName("new_ui_common_forlua/widget/worldmap/WorldMap_Etc_05.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(uiControl, 101, 253, 120, 272)
    uiControl:getBaseTexture():setUV(x1, y1, x2, y2)
    uiControl:setRenderTexture(uiControl:getBaseTexture())
  else
    uiControl:SetShow(false)
  end
end
local SetNodeCountryAndTerritory = function(nodeStaticStatus)
end
local function SetWeatherAndNodeTypeIcon(nodeKey)
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
  local string = "[" .. strWeatherCloudRate .. "/" .. strWeatherRainAmount .. "/" .. strWeatherCelsius .. "]"
  NodeIconArray[IconType.NodeType]:SetText(string)
end
local function GenerateNodeInfo(nodeStaticStatus, nodeKey, isAffiliated, isMaxLevel)
  FillContryInfo(nodeStaticStatus)
  FillTerritoryInfo(nodeStaticStatus)
  SetWeatherAndNodeTypeIcon(nodeKey)
  SetNodeType(nodeStaticStatus._nodeType)
  Txt_Node_Title:SetText(PAGetString(Defines.StringSheet_RESOURCE, "WORLDMAP_NODE_LV_TITLE"))
  Txt_Node_Name:SetText(PAGetString(Defines.StringSheet_RESOURCE, "WORLDMAP_NODE_LV_TITLE"))
  local nodeManagerName = requestNodeManagerName(nodeKey)
  Txt_NodeManager:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLD_MAP_NODE_MANAGER"))
  if "" ~= nodeManagerName then
    Txt_NodeManager:SetShow(true)
    Txt_NodeManager_Name:SetShow(true)
    SetFontColorAndText(Txt_NodeManager, NodeTextString[NodeTextType.NODE_MANAGER_TITLE], NodeTextColor[NodeTextType.NODE_MANAGER_TITLE])
    SetFontColorAndText(Txt_NodeManager_Name, nodeManagerName, NodeTextColor[NodeTextType.NODE_MANAGER_TEXT])
    if Txt_NodeManager_Name:GetSizeX() <= Txt_NodeManager_Name:GetTextSizeX() then
      Txt_NodeManager_Name:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
      Txt_NodeManager_Name:SetText(Txt_NodeManager_Name:GetText())
      Txt_NodeManager_Name:addInputEvent("Mouse_On", "nodeMenu_SimpleTooltips(true)")
      Txt_NodeManager_Name:addInputEvent("Mouse_Out", "nodeMenu_SimpleTooltips(false)")
    end
  else
    Txt_NodeManager:SetShow(false)
    Txt_NodeManager_Name:SetShow(false)
  end
end
local function Align_NodeControls()
  local nextSpanY = 160
  if Txt_NodeManager:GetShow() then
    Txt_NodeManager:SetSpanSize(Txt_NodeManager:GetSpanSize().x, nextSpanY)
    nextSpanY = Txt_NodeManager:GetSpanSize().y + Txt_NodeManager:GetSizeY() + 10
  end
  if Txt_NodeManager_Name:GetShow() then
    Txt_NodeManager_Name:SetSpanSize(Txt_NodeManager_Name:GetSpanSize().x, nextSpanY)
    nextSpanY = Txt_NodeManager_Name:GetSpanSize().y + Txt_NodeManager_Name:GetSizeY() + 10
  end
  if Txt_Node_Desc:GetShow() then
    Txt_Node_Desc:SetSpanSize(Txt_Node_Desc:GetSpanSize().x, nextSpanY)
    nextSpanY = Txt_Node_Desc:GetSpanSize().y + Txt_Node_Desc:GetSizeY() + 10
  end
  if Tex_NeedExplorePoint:GetShow() then
    Tex_NeedExplorePoint:SetSpanSize(Tex_NeedExplorePoint:GetSpanSize().x, nextSpanY + 5)
    Txt_NeedExplorePoint:SetSpanSize(Txt_NeedExplorePoint:GetSpanSize().x, nextSpanY + 5)
    nextSpanY = Tex_NeedExplorePoint:GetSpanSize().y + Tex_NeedExplorePoint:GetSizeY() + 10
  end
  if Btn_NodeLink:GetShow() then
    Btn_NodeLink:SetSpanSize(Btn_NodeLink:GetSpanSize().x, nextSpanY)
    nextSpanY = Btn_NodeLink:GetSpanSize().y + Btn_NodeLink:GetSizeY() + 10
  end
  if Btn_NodeUnlink:GetShow() then
    Btn_NodeUnlink:SetSpanSize(Btn_NodeUnlink:GetSpanSize().x, nextSpanY)
    nextSpanY = Btn_NodeUnlink:GetSpanSize().y + Btn_NodeUnlink:GetSizeY() + 10
  end
  if Btn_NearNode:GetShow() then
    Btn_NearNode:SetSpanSize(Btn_NearNode:GetSpanSize().x, nextSpanY)
    nextSpanY = Btn_NearNode:GetSpanSize().y + Btn_NearNode:GetSizeY() + 5
  end
  if NodeLevelGroup.Txt_NodeLevel:GetShow() then
    NodeLevelGroup.Txt_NodeLevel:SetSpanSize(NodeLevelGroup.Txt_NodeLevel:GetSpanSize().x, nextSpanY)
    NodeLevelGroup.Tex_ProgressBG:SetSpanSize(NodeLevelGroup.Tex_ProgressBG:GetSpanSize().x, nextSpanY + 7)
    NodeLevelGroup.Progress_NodeLevel:SetSpanSize(NodeLevelGroup.Progress_NodeLevel:GetSpanSize().x, nextSpanY + 7)
    NodeLevelGroup.Btn_NodeLevHelp:SetSpanSize(NodeLevelGroup.Btn_NodeLevHelp:GetSpanSize().x, nextSpanY)
    nextSpanY = NodeLevelGroup.Txt_NodeLevel:GetSpanSize().y + NodeLevelGroup.Txt_NodeLevel:GetSizeY() + 10
  end
  if NodeLevelGroup.Btn_NodeLev:GetShow() then
    NodeLevelGroup.Btn_NodeLev:SetSpanSize(NodeLevelGroup.Btn_NodeLev:GetSpanSize().x, nextSpanY)
    nextSpanY = NodeLevelGroup.Btn_NodeLev:GetSpanSize().y + NodeLevelGroup.Btn_NodeLev:GetSizeY() + 10
  end
  static_NodeManagerBG:SetSize(static_NodeManagerBG:GetSizeX(), nextSpanY)
  if Tex_ExplorePoint_BG:GetShow() then
    Tex_ExplorePoint_BG:SetSpanSize(Tex_ExplorePoint_BG:GetSpanSize().x, nextSpanY + 3)
  end
end
local function update_ExplorePoint()
  local territoryKeyRaw = ToClient_getDefaultTerritoryKey()
  local explorePoint = ToClient_getExplorePointByTerritoryRaw(territoryKeyRaw)
  local cont_expRate = Int64toInt32(explorePoint:getExperience_s64()) / Int64toInt32(getRequireExplorationExperience_s64())
  Stc_ExplorePoint_Icon:SetTextMode(UI_TM.eTextMode_AutoWrap)
  Stc_ExplorePoint_Icon:SetText(NodeTextString[NodeTextType.NODE_POINT_TEXT])
  Txt_ExplorePoint_Value:SetText(tostring(explorePoint:getRemainedPoint()) .. " / " .. tostring(explorePoint:getAquiredPoint()))
  if isGameTypeEnglish() or isGameTypeSA() or isGameTypeTH() or isGameTypeID() or isGameTypeTR() then
    Stc_ExplorePoint_Icon:SetVerticalTop()
    Txt_ExplorePoint_Value:SetPosY(Stc_ExplorePoint_Icon:GetPosY() + Stc_ExplorePoint_Icon:GetTextSizeY() + 10)
    Tex_ExplorePoint_BG:SetSize(229, Stc_ExplorePoint_Icon:GetTextSizeY() + Txt_ExplorePoint_Value:GetTextSizeY() + 25)
  else
    Tex_ExplorePoint_BG:SetSize(229, 40)
    Stc_ExplorePoint_Icon:SetVerticalTop()
    Txt_ExplorePoint_Value:SetTextVerticalTop()
    Txt_ExplorePoint_Value:SetSpanSize(10, 12)
  end
end
local function FillNodeInfo(nodeStaticStatus, nodeKey, isAffiliated, isMaxLevel)
  GenerateNodeInfo(nodeStaticStatus, nodeKey, isAffiliated, isMaxLevel)
  NodeLevelGroup:SetShow(false)
  savedisMaxLevel = isMaxLevel
  Txt_Node_Desc:SetAutoResize(true)
  Txt_Node_Desc:SetTextMode(UI_TM.eTextMode_AutoWrap)
  Txt_Node_Desc:SetShow(false)
  local recipeItems = getPlantInvestItemList(nodeStaticStatus)
  local needPoint = getPlantNeedPoint()
  local supportPoint = getPlantNeedSupportPoint()
  local needMoney = getPlantNeedMoney()
  if isExploreUpgradable(nodeKey) then
    NodeLevelGroup:SetNodeLevel(nodeKey)
    if isMaxLevel == false then
      FillExploreUpgradeAble(nodeStaticStatus, nodeKey)
      Tex_NeedExplorePoint:SetShow(true)
      Txt_NeedExplorePoint:SetShow(true)
    else
      NodeLevelGroup:SetShow(true)
      Tex_NeedExplorePoint:SetShow(false)
      Txt_NeedExplorePoint:SetShow(false)
      if isWithdrawablePlant(nodeKey) then
        Txt_Node_Desc:SetShow(false)
        Btn_NodeUnlink:SetShow(true)
        Btn_NodeUnlink:SetText(PAGetString(Defines.StringSheet_RESOURCE, "WORLDMAP_NODE_BTN_WITHDRAW") .. "( " .. needPoint .. " )")
        Btn_NodeUnlink:addInputEvent("Mouse_LUp", "OnNodeWithdrawClick( " .. tostring(nodeKey) .. ")")
        TooltipSimple_Hide()
      elseif needPoint > 0 or supportPoint > 0 or needMoney > 0 or recipeItems > 0 then
        if workerManager_CheckWorkingOtherChannel() then
        else
          SetFontColorAndText(Txt_Node_Desc, PAGetString(Defines.StringSheet_GAME, "PANEL_WORLDMAP_NODENOTWITHDRAW"), NodeTextColor[NodeTextType.NODE_UNWITHDRAW_TEXT])
        end
        Txt_Node_Desc:SetShow(true)
      end
    end
  else
    if true == nodeStaticStatus._isMainNode then
      SetFontColorAndText(Txt_Node_Desc, PAGetString(Defines.StringSheet_GAME, "PANEL_WORLDMAP_NODENOTUPGRADE"), NodeTextColor[NodeTextType.NODE_UNUPGRADE_TEXT])
      Btn_NearNode:SetShow(true)
      Btn_NearNode:addInputEvent("Mouse_LUp", "OnNearNodeClick(" .. tostring(nodeKey) .. ")")
      Tex_NeedExplorePoint:SetShow(false)
      Txt_NeedExplorePoint:SetShow(false)
    elseif false == nodeStaticStatus._isMainNode then
      SetFontColorAndText(Txt_Node_Desc, PAGetString(Defines.StringSheet_GAME, "PANEL_WORLDMAP_NODENOTUPGRADE_SUB"), NodeTextColor[NodeTextType.NODE_UNUPGRADE_TEXT])
    end
    Txt_Node_Desc:SetShow(true)
  end
  update_ExplorePoint()
  Align_NodeControls()
end
function WorldMap_ItemMarket_Open(territoryKeyRaw)
  FGlobal_ItemMarket_Open_ForWorldMap(territoryKeyRaw)
end
local function ClearNodeInfo()
  Btn_NodeLink:SetShow(false)
  Btn_NodeUnlink:SetShow(false)
  Btn_NearNode:SetShow(false)
  NodeLevelGroup.Btn_NodeLev:SetShow(false)
end
function FGlobal_NodeMenu_SetEnableNodeLinkButton(bEnable)
  Btn_NodeLink:SetEnable(bEnable)
  Btn_NodeLink:SetDisableColor(not bEnable)
end
function FGlobal_NodeMenu_SetEnableNodeUnlinkButton(bEnable)
  Btn_NodeUnlink:SetEnable(bEnable)
  Btn_NodeUnlink:SetDisableColor(not bEnable)
end
function NodeLevelGroup:SetNodeLevel(nodeKey)
  local nodeLv = ToClient_GetNodeLevel(nodeKey)
  local nodeExp = Int64toInt32(ToClient_GetNodeExperience_s64(nodeKey))
  local nodeExpMax = Int64toInt32(ToClient_GetNeedExperienceToNextNodeLevel_s64(nodeKey))
  local nodeExpPercent = nodeExp / nodeExpMax * 100
  self.Txt_NodeLevel:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. ". " .. tostring(nodeLv))
  _currentNodeLv = nodeLv
  if isProgressReset then
    self.Progress_NodeLevel:SetProgressRate(0)
    isProgressReset = false
  else
    self.Progress_NodeLevel:SetProgressRate(nodeExpPercent)
  end
end
function NodeLevelGroup:SetShow(isShow)
  self.Btn_NodeLev:SetShow(isShow)
  self.Txt_NodeLevel:SetShow(isShow)
  self.Tex_ProgressBG:SetShow(isShow)
  self.Progress_NodeLevel:SetShow(isShow)
  self.Btn_NodeLevHelp:SetShow(isShow)
end
function FGlobal_ShowInfoNodeMenuPanel(node)
  if false == ToClient_IsGrowStepOpen(__eGrowStep_node) then
    Panel_NodeMenu:SetShow(false)
    Panel_NodeOwnerInfo:SetShow(false)
    nodeStaticStatus = node:getStaticStatus()
    if nil ~= nodeStaticStatus then
      FGlobal_SetNodeName(getExploreNodeName(nodeStaticStatus))
    end
    return
  end
  if false == ToClient_WorldMapIsShow() then
    return
  end
  local plantKey = node:getPlantKey()
  _wayPointKey = plantKey:getWaypointKey()
  local wayPlant = ToClient_getPlant(plantKey)
  local affiliatedTownKey = 0
  if (plantKey:get() == CppEnums.MiniGameParam.eMiniGameParamLoggiaCorn or plantKey:get() == CppEnums.MiniGameParam.eMiniGameParamLoggiaFarm or plantKey:get() == CppEnums.MiniGameParam.eMiniGameParamAlehandroHoney or plantKey:get() == CppEnums.MiniGameParam.eMiniGameParamImpCave) and true == node:isMaxLevel() then
    FGlobal_MiniGame_RequestPlantInvest(plantKey:get())
  end
  nodeStaticStatus = node:getStaticStatus()
  if nil ~= wayPlant then
    affiliatedTownKey = ToClinet_getPlantAffiliatedWaypointKey(wayPlant)
  end
  ClearNodeInfo()
  FillNodeInfo(node:getStaticStatus(), _wayPointKey, _wayPointKey == affiliatedTownKey, node:isMaxLevel())
  FGlobal_nodeOwnerInfo_SetInfo(node:getStaticStatus())
  NodeLevelGroup.Btn_NodeLev:SetText(PAGetString(Defines.StringSheet_RESOURCE, "WORLDMAP_NODE_LV_INVEST"))
  NodeLevelGroup.Btn_NodeLev:addInputEvent("Mouse_LUp", "InvestNodeLevelNumpad( " .. _wayPointKey .. " )")
  local btnNodeLevSizeX = NodeLevelGroup.Btn_NodeLev:GetSizeX() + 23
  local btnNodeLevTextPosX = btnNodeLevSizeX - btnNodeLevSizeX / 2 - NodeLevelGroup.Btn_NodeLev:GetTextSizeX() / 2
  NodeLevelGroup.Btn_NodeLev:SetTextSpan(btnNodeLevTextPosX, 5)
  FromClient_WorldMap_HouseNaviShow()
  FGlobal_SetNodeName(getExploreNodeName(nodeStaticStatus))
  FGlobal_WorldMapGrand_NodeExplorePoint_Update()
  FGlobal_WorldmapGrand_Main_UpdateExplorePoint()
end
function InvestNodeLevelNumpad(wayPointKey)
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
  Panel_NumberPad_Show(true, s64_maxNumber, wayPointKey, InvestNodeLevelExecute)
end
function InvestNodeLevelExecute(inputNumber, param)
  local wpCount = Int64toInt32(inputNumber) * 10
  ToClient_RequestIncreaseExperienceNode(param, wpCount)
end
function FGlobal_CloseNodeMenu()
  ClearNodeInfo()
  Panel_NodeMenu:SetShow(false)
end
function FromClient_RClickedWorldMapNode(nodeBtn)
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
local buildingActorKey
function FGlobal_ShowBuildingInfo(nodeBtn)
  buildingActorKey = nodeBtn:ToClient_getActorKey()
  local buildingSS = ToClient_getBuildingInfo(buildingActorKey)
  if nil == buildingSS then
    return
  end
  local workableCount = ToClient_getBuildingWorkableListCount(buildingSS)
  if workableCount > 0 then
    FGlobal_OnClickBuildingManage()
  end
end
function FGlobal_OnClickBuildingManage()
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
function FromClient_BuildingNodeRClick(nodeBtn)
  local buildInfoSS = nodeBtn:ToClient_getBuildingStaticStatus()
  if nil ~= buildInfoSS then
    FromClient_RClickWorldmapPanel(ToClient_getBuildingPosition(buildInfoSS), true, false)
  end
end
function FGlobal_OnClickTradeIcon(territoryKeyRaw)
  WorldMap_ItemMarket_Open(territoryKeyRaw)
end
local nodeBtnArray = {}
function CreateNodeIconForTradeIcon_ShowTooltip(wayPointKey, isShow)
  if isLuaLoadingComplete then
    if true == isShow then
      local name = PAGetString(Defines.StringSheet_GAME, "GAME_ITEM_MARKET_NAME")
      if nil ~= nodeBtnArray[wayPointKey] then
        local tradeIcon = nodeBtnArray[wayPointKey]:FromClient_getTradeIcon()
        TooltipSimple_Show(tradeIcon, name)
      end
    else
      TooltipSimple_Hide()
    end
  end
end
function FGlobal_ExplorationNode(WaypointKey, ExplorationLevel, TExperience)
  NodeLevelGroup:SetNodeLevel(WaypointKey)
end
function worldmapNodeIcon_GuildWarSet(nodeBtn)
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
          local isAlliance = siegeWrapper:isOccupantGuildAlliance()
          local isSet = false
          if true == isAlliance then
            isSet = setGuildTextureByAllianceNo(siegeWrapper:getGuildNo(), guildMark)
          else
            isSet = setGuildTextureByGuildNo(siegeWrapper:getGuildNo(), guildMark)
          end
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
function FromClient_CreateNodeIcon(nodeBtn)
  if false == _ContentsGroup_RenewUI then
    worldmapNodeIcon_GuildWarSet(nodeBtn)
  end
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
function FGlobal_handleOpenItemMarket(territoryKey)
  FGlobal_ItemMarket_Open_ForWorldMap(1)
end
function FromClient_StartMinorSiege(nodeBtn)
  local warStateIcon = nodeBtn:FromClient_getWarStateIcon()
  warStateIcon:setUpdateTextureAni(true)
  warStateIcon:SetShow(true)
  local guildMark = nodeBtn:FromClient_getGuildMark()
  local guildMarkBG = nodeBtn:FromClient_getGuildMarkBG()
  guildMark:SetShow(false)
  guildMarkBG:SetShow(false)
end
function FromClient_EndMinorSiege(nodeBtn)
  worldmapNodeIcon_GuildWarSet(nodeBtn)
end
function FromClient_OnVillageSiegeBuildingNodeGroup(nodeBtn)
  nodeBtn:EraseAllEffect()
  nodeBtn:AddEffect("UI_WorldMap_Ping01", true, 0, 0)
end
function FromClient_OutVillageSiegeBuildingNodeGroup(nodeBtn)
  nodeBtn:EraseAllEffect()
end
local dayType = {
  [0] = "0Sunday",
  "1Monday",
  "2Tuesday",
  "3wednesday",
  "4Thursday",
  "5Friday",
  "6Saturday"
}
function FromClient_SetGuildModeeWorldMapNodeIcon(nodeBtn)
  if FGlobal_isGuildWarMode() then
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
    worldmapNodeIcon_GuildWarSet(nodeBtn)
  end
end
function FGlobal_WayPointKey_Return()
  return _wayPointKey
end
function FGlobal_LoadWorldMap_WarehouseOpen()
  if nil ~= _wayPointKey then
    local regionInfoWrapper = ToClient_getRegionInfoWrapperByWaypoint(_wayPointKey)
    if nil ~= regionInfoWrapper and regionInfoWrapper:get():isMainOrMinorTown() and regionInfoWrapper:get():hasWareHouseNpc() then
      Warehouse_OpenPanelFromWorldmap(_wayPointKey, CppEnums.WarehoouseFromType.eWarehoouseFromType_Worldmap)
    end
  end
end
function FGlobal_WorldMapGrand_NodeExplorePoint_Update()
  update_ExplorePoint()
end
function HandleOnout_GrandWorldMap_NodeMenu_explorePointHelp(isShow, buttonType)
  if isShow then
    local control
    local name = ""
    local desc
    if 0 == buttonType then
      local currentNodeBuffPercent = ToClient_getNodeIncreaseItemDropPercent() * PaGlobal_NodeMenu_GetCurrentNodeLv()
      currentNodeBuffPercent = currentNodeBuffPercent / 10000
      control = NodeLevelGroup.Btn_NodeLevHelp
      name = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_HELPICON_NODELEVEL")
      if currentNodeBuffPercent > 0 then
        desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_HELPICON_NODELEVEL_DESC_WITH_BUFF", "percent", tostring(currentNodeBuffPercent))
      else
        desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_HELPICON_NODELEVEL_DESC")
      end
    else
      control = SelfExplorePointGroup.Btn_ExplorePoint_Help
      name = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_HELPICON_EXPLORERPOINT")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_HELPICON_EXPLORERPOINT_DESC")
    end
    registTooltipControl(control, Panel_Tooltip_SimpleText)
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function nodeMenu_OnScreenResize()
  Panel_NodeMenu:SetSize(getScreenSizeX(), getScreenSizeY())
end
local guildVehicleActorKeyRawForDestroy
function FomClient_Worldmap_GuildVehicleIcon_Clicked(actorKeyRaw)
  guildVehicleActorKeyRawForDestroy = actorKeyRaw
  local function ApplyDistroy()
    ToClient_Worldmap_GuildVehicleDestroy(guildVehicleActorKeyRawForDestroy)
  end
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_VEHICLEDISTROY_CONTENT")
  messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_VEHICLEDISTROY_TITLE"),
    content = desc,
    functionYes = ApplyDistroy,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobal_NodeMenu_GetCurrentNodeLv()
  if nil == _currentNodeLv then
    return 0
  end
  return _currentNodeLv
end
function nodeMenu_SimpleTooltips(isShow)
  local name, desc, uiControl
  name = Txt_NodeManager_Name:GetText()
  desc = ""
  uiControl = Txt_NodeManager_Name
  if true == isShow then
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
registerEvent("FromClient_CreateWorldMapNodeIcon", "FromClient_CreateNodeIcon")
registerEvent("FromClient_FillNodeInfo", "FGlobal_ShowInfoNodeMenuPanel")
registerEvent("FromClient_RClickedWorldMapNode", "FromClient_RClickedWorldMapNode")
registerEvent("FromClient_ShowBuildingInfo", "FGlobal_ShowBuildingInfo")
registerEvent("FromClient_BuildingNodeRClick", "FromClient_BuildingNodeRClick")
registerEvent("WorldMap_NodeWithdraw", "FGlobal_ShowInfoNodeMenuPanel")
registerEvent("FromClint_EventIncreaseExperienceExplorationNode", "FGlobal_ExplorationNode")
registerEvent("FromClient_StartMinorSiege", "FromClient_StartMinorSiege")
registerEvent("FromClient_EndMinorSiege", "FromClient_EndMinorSiege")
if false == _ContentsGroup_RenewUI then
  registerEvent("FromClient_SetGuildModeeWorldMapNodeIcon", "FromClient_SetGuildModeeWorldMapNodeIcon")
end
registerEvent("FromClient_OnVillageSiegeBuildingNodeGroup", "FromClient_OnVillageSiegeBuildingNodeGroup")
registerEvent("FromClient_OutVillageSiegeBuildingNodeGroup", "FromClient_OutVillageSiegeBuildingNodeGroup")
registerEvent("onScreenResize", "nodeMenu_OnScreenResize")
nodeMenu_init()

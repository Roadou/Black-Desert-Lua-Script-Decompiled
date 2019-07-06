local IM = CppEnums.EProcessorInputMode
local UI_color = Defines.Color
local UI_ST = CppEnums.SpawnType
local UI_TM = CppEnums.TextMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_AV = CppEnums.PA_UI_ALIGNVERTICAL
local UI_TT = CppEnums.PAUI_TEXTURE_TYPE
local UI_VT = CppEnums.VillageSiegeType
local currentTownMode = false
local eWorldmapState = CppEnums.WorldMapState
local eCheckState = CppEnums.WorldMapCheckState
local isEnableBattle = ToClient_IsContentsGroupOpen("21")
local isEnablePlunderGame = ToClient_IsContentsGroupOpen("360")
local worldmapGrand = {
  ui = {
    ModeBG = UI.getChildControl(Instance_WorldMap_Main, "Mode_Bg"),
    TitleBG = UI.getChildControl(Instance_WorldMap_Main, "Static_TitleBG"),
    TopIconBG = UI.getChildControl(Instance_WorldMap_Main, "Static_TopIconBG"),
    filterBg = UI.getChildControl(Instance_WorldMap_Main, "Static_FilterBg"),
    filterArrow = UI.getChildControl(Instance_WorldMap_Main, "Static_FilterArrow"),
    filterTitle = UI.getChildControl(Instance_WorldMap_Main, "StaticText_FilterTitle"),
    buttonBlackSpirit = UI.getChildControl(Instance_WorldMap_Main, "Button_BlackSpirit"),
    buttonTutorial_1 = UI.getChildControl(Instance_WorldMap_Main, "Button_Tutorial_1"),
    buttonTutorial_2 = UI.getChildControl(Instance_WorldMap_Main, "Button_Tutorial_2"),
    buttonTutorial_3 = UI.getChildControl(Instance_WorldMap_Main, "Button_Tutorial_3"),
    MainMenuBG = UI.getChildControl(Instance_WorldMap_Main, "MainMenu_Bg"),
    edit_NodeName = UI.getChildControl(Instance_WorldMap_Main, "MainMenu_Edit_NodeName"),
    btn_SearchNodeName = UI.getChildControl(Instance_WorldMap_Main, "MainMenu_Button_NodeSearch"),
    edit_ItemName = UI.getChildControl(Instance_WorldMap_Main, "MainMenu_Edit_ItemName"),
    btn_SearchItemName = UI.getChildControl(Instance_WorldMap_Main, "MainMenu_Button_ItemSearch"),
    edit_UseType = UI.getChildControl(Instance_WorldMap_Main, "MainMenu_Edit_UseType"),
    btn_SearchUseType = UI.getChildControl(Instance_WorldMap_Main, "MainMenu_Button_UseTypeSearch"),
    edit_GuildName = UI.getChildControl(Instance_WorldMap_Main, "MainMenu_Edit_GuildType"),
    btn_SearchGuildName = UI.getChildControl(Instance_WorldMap_Main, "MainMenu_Button_GuildTypeSearch"),
    searchPartLine = UI.getChildControl(Instance_WorldMap_Main, "MainMenu_Static_Partline"),
    explorePointBG = UI.getChildControl(Instance_WorldMap_Main, "MainMenu_Static_ExplorePoint_Bg"),
    ListBG = UI.getChildControl(Instance_WorldMap_Main, "List_Bg"),
    list_Title = UI.getChildControl(Instance_WorldMap_Main, "List_Title"),
    list_KeyWord = UI.getChildControl(Instance_WorldMap_Main, "List_KeyWord"),
    list_SearchBG = UI.getChildControl(Instance_WorldMap_Main, "List_SearchListBG"),
    list_scroll = UI.getChildControl(Instance_WorldMap_Main, "Scroll_List"),
    daySelectBg = UI.getChildControl(Instance_WorldMap_Main, "Static_SelectDayBg"),
    daySelectTitle = UI.getChildControl(Instance_WorldMap_Main, "StaticText_SelectDayTitle"),
    comboBox_DaySelect = UI.getChildControl(Instance_WorldMap_Main, "Combobox_SelectDay"),
    comboBox_TaxGrade = UI.getChildControl(Instance_WorldMap_Main, "Combobox_SelectTaxGrade"),
    comboBox_MaxMember = UI.getChildControl(Instance_WorldMap_Main, "Combobox_SelectMaxMember"),
    nodeSelectBg = UI.getChildControl(Instance_WorldMap_Main, "Static_SelectTerritoryBg"),
    nodeSelectTitle = UI.getChildControl(Instance_WorldMap_Main, "StaticText_SelectTerritoryTitle"),
    comboBox_TerritorySelect = UI.getChildControl(Instance_WorldMap_Main, "Combobox_SelectTerritory"),
    comboBox_NodeType = UI.getChildControl(Instance_WorldMap_Main, "Combobox_SelectNodeType")
  },
  searchResultUiPool = {},
  template = {
    templateButton = UI.getChildControl(Instance_WorldMap_Main, "Mode_Button"),
    templateCheck = UI.getChildControl(Instance_WorldMap_Main, "Mode_ToggleButton"),
    templateRadio = UI.getChildControl(Instance_WorldMap_Main, "MainMenu_Button_1")
  },
  config = {
    searchingResultMaxCount = 6,
    searchingResultCount = 0,
    searchType = 0,
    selectNodeType = 0,
    scrollStartIdx = 0,
    searchDefaultNodeName = PAGetString(Defines.StringSheet_GAME, "LUA_GRANDWORLDMAP_SEARCHDEFAULT_NODENAME"),
    searchDefaultItemName = PAGetString(Defines.StringSheet_GAME, "LUA_GRANDWORLDMAP_SEARCHDEFAULT_ITEMNAME"),
    searchDefaultGuildName = PAGetString(Defines.StringSheet_GAME, "LUA_GRANDWORLDMAP_SEARCHDEFAULT_GUILDTYPE"),
    searchDefaultUseType = PAGetString(Defines.StringSheet_GAME, "LUA_GRANDWORLDMAP_SEARCHDEFAULT_USETYPE")
  },
  _isAllowTutorialPanelShow = false
}
worldmapGrand.ui.list_scrollBtn = UI.getChildControl(worldmapGrand.ui.list_scroll, "Scroll_CtrlButton")
worldmapGrand.ui.daySelectBg:SetShow(false)
worldmapGrand.ui.daySelectTitle:SetShow(false)
worldmapGrand.ui.comboBox_DaySelect:SetShow(false)
worldmapGrand.ui.comboBox_TaxGrade:SetShow(false)
worldmapGrand.ui.comboBox_MaxMember:SetShow(false)
worldmapGrand.ui.daySelectTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_GUILDWARFILTER"))
worldmapGrand.ui.comboBox_DaySelect:addInputEvent("Mouse_LUp", "WorldMap_GuildWar_DayFilterShow()")
worldmapGrand.ui.comboBox_DaySelect:GetListControl():addInputEvent("Mouse_LUp", "GuildWar_SetDay()")
worldmapGrand.ui.comboBox_TaxGrade:addInputEvent("Mouse_LUp", "WorldMap_GuildWar_TaxGradeFilterShow()")
worldmapGrand.ui.comboBox_TaxGrade:GetListControl():addInputEvent("Mouse_LUp", "GuildWar_SetGrade()")
worldmapGrand.ui.comboBox_MaxMember:addInputEvent("Mouse_LUp", "WorldMap_GuildWar_MaxMemberFilterShow()")
worldmapGrand.ui.comboBox_MaxMember:GetListControl():addInputEvent("Mouse_LUp", "GuildWar_SetMaxMember()")
worldmapGrand.ui.comboBox_DaySelect:setListTextHorizonCenter()
worldmapGrand.ui.comboBox_TaxGrade:setListTextHorizonCenter()
worldmapGrand.ui.comboBox_MaxMember:setListTextHorizonCenter()
worldmapGrand.ui.nodeSelectBg:SetShow(false)
worldmapGrand.ui.nodeSelectTitle:SetShow(false)
worldmapGrand.ui.comboBox_TerritorySelect:setListTextHorizonCenter()
worldmapGrand.ui.comboBox_NodeType:setListTextHorizonCenter()
worldmapGrand.ui.comboBox_TerritorySelect:SetShow(false)
worldmapGrand.ui.comboBox_NodeType:SetShow(false)
worldmapGrand.ui.nodeSelectTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_PRODUCTNODEFILTER"))
worldmapGrand.ui.comboBox_TerritorySelect:addInputEvent("Mouse_LUp", "WorldMap_TerritorySelect_Show()")
worldmapGrand.ui.comboBox_TerritorySelect:GetListControl():addInputEvent("Mouse_LUp", "TerritorySelect_Set()")
worldmapGrand.ui.comboBox_NodeType:addInputEvent("Mouse_LUp", "WorldMap_ProductNodeType_Show()")
worldmapGrand.ui.comboBox_NodeType:GetListControl():addInputEvent("Mouse_LUp", "ProductNodeType_Set()")
local dayString = {
  [UI_VT.eVillageSiegeType_Sunday] = PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_SUNDAY_COLOR"),
  [UI_VT.eVillageSiegeType_Monday] = PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_MONDAY_COLOR"),
  [UI_VT.eVillageSiegeType_Tuesday] = PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_TUESDAY_COLOR"),
  [UI_VT.eVillageSiegeType_Wednesday] = PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_WEDNESDAY_COLOR"),
  [UI_VT.eVillageSiegeType_Thursday] = PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_THUSDAY_COLOR"),
  [UI_VT.eVillageSiegeType_Friday] = PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_FRIDAY_COLOR"),
  [UI_VT.eVillageSiegeType_Saturday] = PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_SATURDAY_COLOR")
}
local maxMemberData = {
  [0] = 0,
  25,
  30,
  40,
  45,
  55,
  60,
  100
}
function WorldMap_ContributorPoint_Init()
  local self = worldmapGrand
  self.ui.explorePointBG = UI.getChildControl(Instance_WorldMap_Main, "MainMenu_Static_ExplorePoint_Bg")
  self.ui.explorePointIcon = UI.getChildControl(self.ui.explorePointBG, "MainMenu_ExplorePoint_Icon")
  self.ui.explorePointValue = UI.getChildControl(self.ui.explorePointBG, "MainMenu_StaticText_ExplorePoint_Value")
end
WorldMap_ContributorPoint_Init()
function WorldMap_GuildWar_DayFilterShow()
  worldmapGrand.ui.comboBox_DaySelect:DeleteAllItem()
  local count = 0
  for index = 0, UI_VT.eVillageSiegeType_Count do
    if 0 == index then
      worldmapGrand.ui.comboBox_DaySelect:AddItem(PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_SELECTDEFALUT"), index)
    else
      worldmapGrand.ui.comboBox_DaySelect:AddItem(dayString[index - 1], index)
    end
    count = count + 1
  end
  worldmapGrand.ui.comboBox_DaySelect:GetListControl():SetSize(worldmapGrand.ui.comboBox_DaySelect:GetSizeX(), count * 17)
  worldmapGrand.ui.comboBox_DaySelect:ToggleListbox()
end
function GuildWar_SetDay()
  local selectIndex = worldmapGrand.ui.comboBox_DaySelect:GetSelectIndex()
  if 0 == selectIndex then
    ToClient_resetVisibleVillageSiegeType()
    worldmapGrand.ui.comboBox_DaySelect:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_SELECTDEFALUT"))
  else
    ToClient_setVisibleVillageSiegeType(selectIndex - 1)
    worldmapGrand.ui.comboBox_DaySelect:SetText(dayString[selectIndex - 1])
  end
  worldmapGrand.ui.comboBox_DaySelect:ToggleListbox()
end
local maxTaxGrade = 4
function WorldMap_GuildWar_TaxGradeFilterShow()
  if false == _ContentsGroup_SeigeSeason5 then
    maxTaxGrade = 3
  end
  worldmapGrand.ui.comboBox_TaxGrade:DeleteAllItem()
  local count = 0
  for index = 0, maxTaxGrade do
    if 0 == index then
      worldmapGrand.ui.comboBox_TaxGrade:AddItem(PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_SELECTDEFALUT"), index)
    else
      local tempString = ""
      local taxGrade = index - 1
      if true == _ContentsGroup_SeigeSeason5 then
        if _ContentsGroup_NewSiegeRule then
          tempString = "LUA_NODEGRADE_"
        else
          tempString = "LUA_NODEGRADE2_"
        end
        tempString = PAGetString(Defines.StringSheet_GAME, tempString .. tostring(taxGrade))
        worldmapGrand.ui.comboBox_TaxGrade:AddItem(tempString)
      else
        if 0 == taxGrade then
          tempString = "I"
        elseif 1 == taxGrade then
          tempString = "II"
        elseif 2 == taxGrade then
          tempString = "III"
        end
        worldmapGrand.ui.comboBox_TaxGrade:AddItem(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDALLIANCE_CHALLENGE_POINT_GRADE", "index", tempString))
      end
    end
    count = count + 1
  end
  worldmapGrand.ui.comboBox_TaxGrade:GetListControl():SetSize(worldmapGrand.ui.comboBox_TaxGrade:GetSizeX(), count * 16)
  worldmapGrand.ui.comboBox_TaxGrade:ToggleListbox()
end
function GuildWar_SetGrade()
  if worldmapGrand.ui.comboBox_TaxGrade:GetSelectIndex() == -1 then
    return
  end
  local selectIndex = worldmapGrand.ui.comboBox_TaxGrade:GetSelectIndex() - 1
  if -1 == selectIndex then
    ToClient_resetVisibleVillageSiegeTaxLevel()
    worldmapGrand.ui.comboBox_TaxGrade:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_SELECTDEFALUT"))
  else
    if false == _ContentsGroup_SeigeSeason5 then
      selectIndex = selectIndex + 1
    end
    ToClient_setVisibleVillageSiegeTaxLevel(selectIndex)
    local taxGrade = selectIndex
    if true == _ContentsGroup_SeigeSeason5 then
      if _ContentsGroup_NewSiegeRule then
        tempString = "LUA_NODEGRADE_"
      else
        tempString = "LUA_NODEGRADE2_"
      end
      tempString = PAGetString(Defines.StringSheet_GAME, tempString .. tostring(taxGrade))
      worldmapGrand.ui.comboBox_TaxGrade:SetText(tempString)
    else
      if 1 == taxGrade then
        tempString = "I"
      elseif 2 == taxGrade then
        tempString = "II"
      elseif 3 == taxGrade then
        tempString = "III"
      end
      worldmapGrand.ui.comboBox_TaxGrade:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_GUILDALLIANCE_CHALLENGE_POINT_GRADE", "index", tempString))
    end
  end
  worldmapGrand.ui.comboBox_TaxGrade:ToggleListbox()
end
function WorldMap_GuildWar_MaxMemberFilterShow()
  local maxItemCount = 8
  worldmapGrand.ui.comboBox_MaxMember:DeleteAllItem()
  for index = 0, maxItemCount - 1 do
    if 0 == index then
      worldmapGrand.ui.comboBox_MaxMember:AddItem("\236\160\132\236\178\180 \235\179\180\234\184\176")
    else
      worldmapGrand.ui.comboBox_MaxMember:AddItem(maxMemberData[index] .. "\235\170\133")
    end
  end
  worldmapGrand.ui.comboBox_MaxMember:GetListControl():SetSize(worldmapGrand.ui.comboBox_MaxMember:GetSizeX(), maxItemCount * 16)
  worldmapGrand.ui.comboBox_MaxMember:ToggleListbox()
end
function GuildWar_SetMaxMember()
  if worldmapGrand.ui.comboBox_MaxMember:GetSelectIndex() == -1 then
    return
  end
  local selectIndex = worldmapGrand.ui.comboBox_MaxMember:GetSelectIndex() - 1
  if -1 == selectIndex then
    worldmapGrand.ui.comboBox_MaxMember:SetText("\236\181\156\235\140\128 \236\157\184\236\155\144 \236\132\164\236\160\149")
  elseif 0 == index then
    worldmapGrand.ui.comboBox_MaxMember:AddItem("\236\160\132\236\178\180 \235\179\180\234\184\176")
  else
    worldmapGrand.ui.comboBox_MaxMember:SetText(maxMemberData[index] .. "\235\170\133")
  end
  worldmapGrand.ui.comboBox_MaxMember:ToggleListbox()
end
function FGlobal_WorldmapMain_IsAllowTutorialPanelShow()
  return worldmapGrand._isAllowTutorialPanelShow
end
function FGlobal_WorldmapMain_SetAllowTutorialPanelShow(bAllow)
  worldmapGrand._isAllowTutorialPanelShow = bAllow
end
function FGlobal_WorldmapMain_InitTutorialButton()
  if 20 <= getSelfPlayer():get():getLevel() or true == questList_isClearQuest(654, 4) then
    FGlobal_WorldmapMain_SetShowBlackSpiritButton(true)
  else
    FGlobal_WorldmapMain_SetShowBlackSpiritButton(false)
  end
  local wui = worldmapGrand.ui
  local blackSpiritButtonPosX = getScreenSizeX() - wui.buttonBlackSpirit:GetSizeX() - 20
  local blackSpiritButtonPosY = worldmapGrand.ui.nodeSelectBg:GetPosY() + worldmapGrand.ui.nodeSelectBg:GetSizeY() + 30
  wui.buttonBlackSpirit:SetPosX(blackSpiritButtonPosX)
  wui.buttonBlackSpirit:SetPosY(blackSpiritButtonPosY)
  wui.buttonTutorial_1:SetShow(false, false)
  wui.buttonTutorial_2:SetShow(false, false)
  wui.buttonTutorial_3:SetShow(false, false)
  wui.buttonTutorial_1:SetPosX(getScreenSizeX() - wui.buttonTutorial_1:GetSizeX() - 10)
  wui.buttonTutorial_1:SetPosY(wui.buttonBlackSpirit:GetPosY() + wui.buttonBlackSpirit:GetSizeY() + 5)
  wui.buttonTutorial_2:SetPosX(getScreenSizeX() - wui.buttonTutorial_2:GetSizeX() - 10)
  wui.buttonTutorial_2:SetPosY(wui.buttonTutorial_1:GetPosY() + wui.buttonTutorial_1:GetSizeY() + 5)
  wui.buttonTutorial_3:SetPosX(getScreenSizeX() - wui.buttonTutorial_3:GetSizeX() - 10)
  wui.buttonTutorial_3:SetPosY(wui.buttonTutorial_2:GetPosY() + wui.buttonTutorial_2:GetSizeY() + 5)
end
function HandleClicked_GrandWorldMap_TutorialButton(buttonNum)
  PaGlobal_TutorialManager:handleClickWorldmapTutorialButton(buttonNum)
end
function FGlobal_WorldmapMain_SetShowBlackSpiritButton(bShow)
  worldmapGrand.ui.buttonBlackSpirit:SetShow(bShow, true)
end
function HandleClicked_GrandWorldMap_BlackSpiritButton()
  local wui = worldmapGrand.ui
  wui.buttonBlackSpirit:AddEffect("fUI_Light", false, 0, 0)
  if true == wui.buttonTutorial_1:GetShow() or true == wui.buttonTutorial_1:GetShow() or true == wui.buttonTutorial_1:GetShow() then
    FGlobal_GrandWorldmap_SetShowTutorialButton(false)
  else
    FGlobal_GrandWorldmap_SetShowTutorialButton(true)
  end
end
function FGlobal_GrandWorldmap_SetShowTutorialButton(bshow)
  local wui = worldmapGrand.ui
  wui.buttonTutorial_1:SetShow(bshow, true)
  wui.buttonTutorial_2:SetShow(bshow, true)
  wui.buttonTutorial_3:SetShow(bshow, true)
end
function FGlobal_SetShow_WorldmapSearchUi(bShow)
  FGlobal_SetShow_WorldmapSearchMenu(bShow)
  FGlobal_SetShow_WorldmapExplorePoint(bShow)
end
function FGlobal_SetShow_WorldmapExplorePoint(bShow)
  worldmapGrand.ui.explorePointBG:SetShow(bShow)
  worldmapGrand.ui.explorePointIcon:SetShow(bShow)
  worldmapGrand.ui.explorePointValue:SetShow(false)
end
function FGlobal_SetShow_WorldmapSearchMenu(bShow)
  worldmapGrand.ui.MainMenuBG:SetShow(bShow)
  worldmapGrand.ui.edit_NodeName:SetShow(bShow)
  worldmapGrand.ui.btn_SearchNodeName:SetShow(bShow)
  worldmapGrand.ui.edit_ItemName:SetShow(bShow)
  worldmapGrand.ui.btn_SearchItemName:SetShow(bShow)
  worldmapGrand.ui.edit_UseType:SetShow(bShow)
  worldmapGrand.ui.btn_SearchUseType:SetShow(bShow)
  worldmapGrand.ui.edit_GuildName:SetShow(bShow)
  worldmapGrand.ui.btn_SearchGuildName:SetShow(bShow)
  worldmapGrand.ui.ListBG:SetShow(bShow)
  worldmapGrand.ui.list_Title:SetShow(bShow)
  worldmapGrand.ui.list_KeyWord:SetShow(bShow)
  worldmapGrand.ui.list_SearchBG:SetShow(bShow)
  worldmapGrand.ui.list_scroll:SetShow(bShow)
end
function FGlobal_WorldmapMain_AddEffectUiNodeButtonByWaypointKey(waypointKey, effectName, isLoop, offsetX, offsetY)
  local uiNodeButton = ToClient_FindNodeButtonByWaypointKey(waypointKey)
  if nil ~= uiNodeButton then
    uiNodeButton:AddEffect(effectName, isLoop, offsetX, offsetY)
  end
end
function FGlobal_WorldmapMain_EraseAllEffectUiNodeButtonByWaypointKey(waypointKey)
  local uiNodeButton = ToClient_FindNodeButtonByWaypointKey(waypointKey)
  if nil ~= uiNodeButton then
    uiNodeButton:EraseAllEffect()
  end
end
local eventTempControl
function FGlobal_WorldmapMain_GetOrCreateEventTempControl(eventName, targetUi, parentPanel, color)
  eventTempControl = UI.getChildControl(parentPanel, "Static_Temp_MouseOn")
  if nil ~= eventTempControl then
    return eventTempControl
  end
  eventTempControl = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, parentPanel, "Static_Temp_MouseOn")
  eventTempControl:addInputEvent(eventName, "FGlobal_WorldmapMain_HandleEventTempControl()")
  eventTempControl:ChangeTextureInfoName("new_ui_common_forlua/default/Default_Etc_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(eventTempControl, 111, 60, 112, 61)
  eventTempControl:getBaseTexture():setUV(x1, y1, x2, y2)
  eventTempControl:setRenderTexture(eventTempControl:getBaseTexture())
  eventTempControl:SetPosX(targetUi:GetPosX())
  eventTempControl:SetPosY(targetUi:GetPosY())
  eventTempControl:SetSize(targetUi:GetSizeX(), targetUi:GetSizeY())
  local decidedColor = Defines.Color.C_FFFFCE22
  if nil ~= color then
    decidedColor = color
  end
  eventTempControl:SetColor(decidedColor)
  eventTempControl:SetShow(true)
  return eventTempControl
end
function FGlobal_WorldmapMain_GetEventTempControl()
  return eventTempControl
end
function FGlobal_WorldmapMain_HandleEventTempControl()
  PaGlobal_TutorialManager:handleWorldmapMainEventTempControl()
end
local toAlpha = 0
local currAlpha = 0
function FGlobal_WorldmapMain_PerFrameAlphaAnimationEventTempControl(minAlpha, maxAlpha, RateWithDeltaTime)
  if nil ~= eventTempControl then
    currAlpha = eventTempControl:GetAlpha()
    if maxAlpha <= currAlpha + 0.01 then
      toAlpha = minAlpha
    elseif minAlpha >= currAlpha - 0.01 then
      toAlpha = maxAlpha
    end
    UIAni.perFrameAlphaAnimation(toAlpha, eventTempControl, RateWithDeltaTime)
  end
end
Instance_WorldMap_Main:SetShow(false, false)
worldmapGrand.template.templateButton:SetShow(false)
worldmapGrand.template.templateCheck:SetShow(false)
worldmapGrand.template.templateRadio:SetShow(false)
local worldMapState = {}
local worldMapCheckState = {}
local worldMapNodeListType = {}
function FGlobal_WorldmapMain_GetWorldmapModeButtonList()
  return worldMapState
end
function FGlobal_WorldmapMain_GetWorldmapCheckButtonList()
  return worldMapCheckState
end
local worldMapCheckStateInMode = {
  [eWorldmapState.eWMS_EXPLORE_PLANT] = {},
  [eWorldmapState.eWMS_REGION] = {},
  [eWorldmapState.eWMS_LOCATION_INFO_WATER] = {},
  [eWorldmapState.eWMS_LOCATION_INFO_CELCIUS] = {},
  [eWorldmapState.eWMS_LOCATION_INFO_HUMIDITY] = {},
  [eWorldmapState.eWMS_GUILD_WAR] = {},
  [eWorldmapState.eWMS_PRODUCT_NODE] = {}
}
local modeTexture = {
  [eWorldmapState.eWMS_EXPLORE_PLANT] = {
    [0] = {
      1,
      34,
      53,
      86
    },
    [1] = {
      1,
      87,
      53,
      139
    },
    [2] = {
      1,
      140,
      53,
      192
    }
  },
  [eWorldmapState.eWMS_REGION] = {
    [0] = {
      54,
      34,
      106,
      86
    },
    [1] = {
      54,
      87,
      106,
      139
    },
    [2] = {
      54,
      140,
      106,
      192
    }
  },
  [eWorldmapState.eWMS_LOCATION_INFO_WATER] = {
    [0] = {
      107,
      34,
      159,
      86
    },
    [1] = {
      107,
      87,
      159,
      139
    },
    [2] = {
      107,
      140,
      159,
      192
    }
  },
  [eWorldmapState.eWMS_LOCATION_INFO_CELCIUS] = {
    [0] = {
      160,
      34,
      212,
      86
    },
    [1] = {
      160,
      87,
      212,
      139
    },
    [2] = {
      160,
      140,
      212,
      192
    }
  },
  [eWorldmapState.eWMS_LOCATION_INFO_HUMIDITY] = {
    [0] = {
      213,
      34,
      265,
      86
    },
    [1] = {
      213,
      87,
      265,
      139
    },
    [2] = {
      213,
      140,
      265,
      192
    }
  },
  [eWorldmapState.eWMS_GUILD_WAR] = {
    [0] = {
      266,
      34,
      318,
      86
    },
    [1] = {
      266,
      87,
      318,
      139
    },
    [2] = {
      266,
      140,
      318,
      192
    }
  },
  [eWorldmapState.eWMS_PRODUCT_NODE] = {
    [0] = {
      319,
      34,
      371,
      86
    },
    [1] = {
      319,
      87,
      371,
      139
    },
    [2] = {
      319,
      140,
      371,
      192
    }
  }
}
local function changeModeTexture(modeType)
  local control = worldMapState[modeType]
  local posArray = modeTexture[modeType]
  control:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_Btn_01.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, posArray[0][1], posArray[0][2], posArray[0][3], posArray[0][4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:ChangeOnTextureInfoName("Renewal/PcRemaster/Remaster_Btn_01.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, posArray[1][1], posArray[1][2], posArray[1][3], posArray[1][4])
  control:getOnTexture():setUV(x1, y1, x2, y2)
  control:ChangeClickTextureInfoName("Renewal/PcRemaster/Remaster_Btn_01.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, posArray[2][1], posArray[2][2], posArray[2][3], posArray[2][4])
  control:getClickTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
local modeFilterTexture = {
  [eCheckState.eCheck_Quest] = {
    [0] = {
      32,
      1,
      62,
      31
    },
    [1] = {
      32,
      63,
      62,
      93
    },
    [2] = {
      32,
      125,
      62,
      155
    }
  },
  [eCheckState.eCheck_Knowledge] = {
    [0] = {
      1,
      1,
      31,
      31
    },
    [1] = {
      1,
      63,
      31,
      93
    },
    [2] = {
      1,
      125,
      31,
      155
    }
  },
  [eCheckState.eCheck_FishnChip] = {
    [0] = {
      63,
      32,
      93,
      62
    },
    [1] = {
      63,
      94,
      93,
      124
    },
    [2] = {
      63,
      156,
      93,
      186
    }
  },
  [eCheckState.eCheck_Node] = {
    [0] = {
      32,
      32,
      62,
      62
    },
    [1] = {
      32,
      94,
      62,
      124
    },
    [2] = {
      32,
      156,
      62,
      186
    }
  },
  [eCheckState.eCheck_Way] = {
    [0] = {
      94,
      1,
      124,
      31
    },
    [1] = {
      94,
      63,
      124,
      93
    },
    [2] = {
      94,
      125,
      124,
      155
    }
  },
  [eCheckState.eCheck_Postions] = {
    [0] = {
      1,
      32,
      31,
      62
    },
    [1] = {
      1,
      94,
      31,
      124
    },
    [2] = {
      1,
      156,
      31,
      186
    }
  },
  [eCheckState.eCheck_Trade] = {
    [0] = {
      94,
      32,
      124,
      62
    },
    [1] = {
      94,
      94,
      124,
      124
    },
    [2] = {
      94,
      156,
      124,
      186
    }
  },
  [eCheckState.eCheck_Wagon] = {
    [0] = {
      125,
      1,
      155,
      31
    },
    [1] = {
      125,
      63,
      155,
      93
    },
    [2] = {
      125,
      125,
      155,
      155
    }
  },
  [eCheckState.eCheck_Monster] = {
    [0] = {
      63,
      1,
      93,
      31
    },
    [1] = {
      63,
      63,
      93,
      93
    },
    [2] = {
      63,
      125,
      93,
      155
    }
  }
}
local function changeModeFilterTexture(modeFilterType)
  local control = worldMapCheckState[modeFilterType]
  local posArray = modeFilterTexture[modeFilterType]
  control:ChangeTextureInfoName("Renewal/PcRemaster/Remaster_WorldMap_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, posArray[0][1], posArray[0][2], posArray[0][3], posArray[0][4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:ChangeOnTextureInfoName("Renewal/PcRemaster/Remaster_WorldMap_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, posArray[1][1], posArray[1][2], posArray[1][3], posArray[1][4])
  control:getOnTexture():setUV(x1, y1, x2, y2)
  control:ChangeClickTextureInfoName("Renewal/PcRemaster/Remaster_WorldMap_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, posArray[2][1], posArray[2][2], posArray[2][3], posArray[2][4])
  control:getClickTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
local worldMapNodeType = {
  normal = 0,
  viliage = 1,
  city = 2,
  gate = 3,
  trade = 5,
  dangerous = 9
}
function FGlobal_WorldmapMain_GetWorldmapNodeType()
  return worldMapNodeType
end
local nodeList = {
  [0] = worldMapNodeType.normal,
  [1] = worldMapNodeType.viliage,
  [2] = worldMapNodeType.city,
  [3] = worldMapNodeType.gate,
  [4] = worldMapNodeType.trade,
  [5] = worldMapNodeType.dangerous
}
local nodeListCount = 6
local nodeTexture = {
  [worldMapNodeType.normal] = {
    [0] = {
      2,
      2,
      42,
      42
    },
    [1] = {
      2,
      2,
      42,
      42
    },
    [2] = {
      2,
      43,
      42,
      83
    }
  },
  [worldMapNodeType.viliage] = {
    [0] = {
      43,
      2,
      83,
      42
    },
    [1] = {
      43,
      2,
      83,
      42
    },
    [2] = {
      43,
      43,
      83,
      83
    }
  },
  [worldMapNodeType.city] = {
    [0] = {
      84,
      2,
      124,
      42
    },
    [1] = {
      84,
      2,
      124,
      42
    },
    [2] = {
      84,
      43,
      124,
      83
    }
  },
  [worldMapNodeType.gate] = {
    [0] = {
      125,
      2,
      165,
      42
    },
    [1] = {
      125,
      2,
      165,
      42
    },
    [2] = {
      125,
      43,
      165,
      83
    }
  },
  [worldMapNodeType.trade] = {
    [0] = {
      166,
      2,
      206,
      42
    },
    [1] = {
      166,
      2,
      206,
      42
    },
    [2] = {
      166,
      43,
      206,
      83
    }
  },
  [worldMapNodeType.dangerous] = {
    [0] = {
      207,
      2,
      247,
      42
    },
    [1] = {
      207,
      2,
      247,
      42
    },
    [2] = {
      207,
      43,
      247,
      83
    }
  }
}
local worldMapNodeType_String = {
  [worldMapNodeType.normal] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_NODETYPE_NORMAL"),
  [worldMapNodeType.viliage] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_NODETYPE_VILIAGE"),
  [worldMapNodeType.city] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_NODETYPE_CITY"),
  [worldMapNodeType.gate] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_NODETYPE_GATE"),
  [worldMapNodeType.trade] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_NODETYPE_TRADE"),
  [worldMapNodeType.dangerous] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_NODETYPE_DANGEROUS")
}
local worldMapNodeTypeString = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODETYPE_0"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODETYPE_1"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODETYPE_2"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODETYPE_3"),
  [4] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODETYPE_4"),
  [5] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODETYPE_5"),
  [6] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODETYPE_6"),
  [7] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODETYPE_7")
}
local worldMapNodeTypeIndex = {
  [0] = -1,
  [1] = CppEnums.ExplorationNodeType.eExplorationNodeType_Farm,
  [2] = CppEnums.ExplorationNodeType.eExplorationNodeType_Collect,
  [3] = CppEnums.ExplorationNodeType.eExplorationNodeType_Quarry,
  [4] = CppEnums.ExplorationNodeType.eExplorationNodeType_Logging,
  [5] = CppEnums.ExplorationNodeType.eExplorationNodeType_Craft,
  [6] = CppEnums.ExplorationNodeType.eExplorationNodeType_Excavation,
  [7] = CppEnums.ExplorationNodeType.eExplorationNodeType_MonopolyFarm
}
local btnArray = {}
local _selectNodeType = -1
local _selectTerritory = -1
function WorldMap_ProductNodeType_Show()
  worldmapGrand.ui.comboBox_NodeType:DeleteAllItem()
  local count = 0
  for index = 0, #worldMapNodeTypeString do
    worldmapGrand.ui.comboBox_NodeType:AddItem(worldMapNodeTypeString[index])
    count = count + 1
  end
  worldmapGrand.ui.comboBox_NodeType:GetListControl():SetSize(worldmapGrand.ui.comboBox_NodeType:GetSizeX(), count * 17)
  worldmapGrand.ui.comboBox_NodeType:ToggleListbox()
end
function ProductNodeType_Set()
  local selectIndex = worldmapGrand.ui.comboBox_NodeType:GetSelectIndex()
  worldmapGrand.ui.comboBox_NodeType:SetText(worldMapNodeTypeString[selectIndex])
  _selectNodeType = selectIndex
  WorldMapArrowEffectErase()
  if -1 ~= worldMapNodeTypeIndex[selectIndex] then
    ToClient_FilterNodeType(_selectTerritory, worldMapNodeTypeIndex[selectIndex])
  end
  worldmapGrand.ui.comboBox_NodeType:ToggleListbox()
end
function PrevNodeType_Set()
  WorldMapArrowEffectErase()
  if -1 ~= _selectNodeType then
    ToClient_FilterNodeType(_selectTerritory, worldMapNodeTypeIndex[_selectNodeType])
  end
end
local territoryString = {
  [-1] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYSTRING_ALL"),
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYSTRING_0"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYSTRING_1"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYSTRING_2"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYSTRING_3"),
  [4] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYSTRING_4"),
  [5] = "\235\158\143 \237\149\173\234\181\172",
  [6] = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_6"),
  [7] = PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYNAME_7")
}
function WorldMap_TerritorySelect_Show()
  worldmapGrand.ui.comboBox_TerritorySelect:DeleteAllItem()
  local count = 0
  for index = -1, #territoryString do
    if 5 ~= index then
      worldmapGrand.ui.comboBox_TerritorySelect:AddItem(territoryString[index])
      count = count + 1
    end
  end
  worldmapGrand.ui.comboBox_TerritorySelect:GetListControl():SetSize(worldmapGrand.ui.comboBox_TerritorySelect:GetSizeX(), count * 18)
  worldmapGrand.ui.comboBox_TerritorySelect:ToggleListbox()
end
function TerritorySelect_Set()
  local selectIndex = worldmapGrand.ui.comboBox_TerritorySelect:GetSelectIndex()
  if selectIndex > 5 then
    selectIndex = selectIndex + 1
  end
  worldmapGrand.ui.comboBox_TerritorySelect:SetText(territoryString[selectIndex - 1])
  _selectTerritory = selectIndex - 1
  if _selectNodeType > -1 then
    WorldMapArrowEffectErase()
    ToClient_FilterNodeType(_selectTerritory, worldMapNodeTypeIndex[_selectNodeType])
  end
  worldmapGrand.ui.comboBox_TerritorySelect:ToggleListbox()
end
local worldmapGrand_SearchType = {
  nodeName = 0,
  itemName = 1,
  nodeType = 2,
  UseType = 3,
  GuildName = 4
}
local _isGuildWarMode = false
local _isBlackFog = false
local _currentRenderMode = eWorldmapState.eWMS_EXPLORE_PLANT
local function MakeModeButton()
  local radioControl = CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON
  worldMapState[eWorldmapState.eWMS_EXPLORE_PLANT] = UI.createControl(radioControl, Instance_WorldMap_Main, "Mode_Button_Explore")
  worldMapState[eWorldmapState.eWMS_REGION] = UI.createControl(radioControl, Instance_WorldMap_Main, "Mode_Button_Region")
  worldMapState[eWorldmapState.eWMS_LOCATION_INFO_WATER] = UI.createControl(radioControl, Instance_WorldMap_Main, "Mode_Button_Water")
  worldMapState[eWorldmapState.eWMS_LOCATION_INFO_CELCIUS] = UI.createControl(radioControl, Instance_WorldMap_Main, "Mode_Button_Celcius")
  worldMapState[eWorldmapState.eWMS_LOCATION_INFO_HUMIDITY] = UI.createControl(radioControl, Instance_WorldMap_Main, "Mode_Button_Humidity")
  worldMapState[eWorldmapState.eWMS_GUILD_WAR] = UI.createControl(radioControl, Instance_WorldMap_Main, "Mode_Button_Guildwar")
  worldMapState[eWorldmapState.eWMS_PRODUCT_NODE] = UI.createControl(radioControl, Instance_WorldMap_Main, "Mode_Button_ProductNode")
  for modeIndex, value in pairs(worldMapState) do
    CopyBaseProperty(worldmapGrand.template.templateButton, value)
    value:addInputEvent("Mouse_LUp", "WorldMapStateChange(" .. modeIndex .. ")")
    value:addInputEvent("Mouse_On", "WorldMapStateChange_SimpleTooltips(true," .. modeIndex .. ")")
    value:addInputEvent("Mouse_Out", "WorldMapStateChange_SimpleTooltips( false )")
    value:setTooltipEventRegistFunc("WorldMapStateChange_SimpleTooltips(true," .. modeIndex .. ")")
    value:SetShow(true)
    value:SetEnable(true)
    value:SetGroup(0)
    changeModeTexture(modeIndex)
  end
end
local function MakeModeChekcState()
  worldMapCheckState[eCheckState.eCheck_Quest] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CHECKBUTTON, Instance_WorldMap_Main, "CheckButton_Quest")
  worldMapCheckState[eCheckState.eCheck_Knowledge] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CHECKBUTTON, Instance_WorldMap_Main, "CheckButton_Knowledge")
  worldMapCheckState[eCheckState.eCheck_FishnChip] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CHECKBUTTON, Instance_WorldMap_Main, "CheckButton_Fishnchip")
  worldMapCheckState[eCheckState.eCheck_Node] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CHECKBUTTON, Instance_WorldMap_Main, "CheckButton_Node")
  worldMapCheckState[eCheckState.eCheck_Trade] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CHECKBUTTON, Instance_WorldMap_Main, "CheckButton_Trade")
  worldMapCheckState[eCheckState.eCheck_Way] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CHECKBUTTON, Instance_WorldMap_Main, "CheckButton_WayGuide")
  worldMapCheckState[eCheckState.eCheck_Postions] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CHECKBUTTON, Instance_WorldMap_Main, "CheckButton_Positions")
  worldMapCheckState[eCheckState.eCheck_Wagon] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CHECKBUTTON, Instance_WorldMap_Main, "CheckButton_Carriage")
  worldMapCheckState[eCheckState.eCheck_Monster] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_CHECKBUTTON, Instance_WorldMap_Main, "CheckButton_Monster")
  for checkIndex, value in pairs(worldMapCheckState) do
    CopyBaseProperty(worldmapGrand.template.templateCheck, worldMapCheckState[checkIndex])
    worldMapCheckState[checkIndex]:addInputEvent("Mouse_LUp", "WorldMapCheckListChange(" .. checkIndex .. ")")
    worldMapCheckState[checkIndex]:addInputEvent("Mouse_On", "WorldMapCheckListToolTips( true," .. checkIndex .. ")")
    worldMapCheckState[checkIndex]:addInputEvent("Mouse_Out", "WorldMapCheckListToolTips( false )")
    worldMapCheckState[checkIndex]:SetShow(true)
    worldMapCheckState[checkIndex]:SetEnable(true)
    changeModeFilterTexture(checkIndex)
  end
end
local function changeNodeTexture(nodeType)
  local control = worldMapNodeListType[nodeType]
  local posArray = nodeTexture[nodeType]
  control:ChangeTextureInfoName("Renewal/UI_Icon/Console_Icon_WorldMap_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, posArray[0][1], posArray[0][2], posArray[0][3], posArray[0][4])
  control:getBaseTexture():setUV(x1, y1, x2, y2)
  control:ChangeOnTextureInfoName("Renewal/UI_Icon/Console_Icon_WorldMap_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, posArray[1][1], posArray[1][2], posArray[1][3], posArray[1][4])
  control:getOnTexture():setUV(x1, y1, x2, y2)
  control:ChangeClickTextureInfoName("Renewal/UI_Icon/Console_Icon_WorldMap_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(control, posArray[2][1], posArray[2][2], posArray[2][3], posArray[2][4])
  control:getClickTexture():setUV(x1, y1, x2, y2)
  control:setRenderTexture(control:getBaseTexture())
end
local function MakeNodeListType()
  worldMapNodeListType[worldMapNodeType.normal] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, worldmapGrand.ui.MainMenuBG, "GrandWorldMap_NodeType_RadioButton_Normal")
  worldMapNodeListType[worldMapNodeType.viliage] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, worldmapGrand.ui.MainMenuBG, "GrandWorldMap_NodeType_RadioButton_Viliage")
  worldMapNodeListType[worldMapNodeType.city] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, worldmapGrand.ui.MainMenuBG, "GrandWorldMap_NodeType_RadioButton_City")
  worldMapNodeListType[worldMapNodeType.gate] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, worldmapGrand.ui.MainMenuBG, "GrandWorldMap_NodeType_RadioButton_Gate")
  worldMapNodeListType[worldMapNodeType.trade] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, worldmapGrand.ui.MainMenuBG, "GrandWorldMap_NodeType_RadioButton_Trade")
  worldMapNodeListType[worldMapNodeType.dangerous] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, worldmapGrand.ui.MainMenuBG, "GrandWorldMap_NodeType_RadioButton_Dangerous")
  for checkIndex, value in pairs(worldMapNodeListType) do
    CopyBaseProperty(worldmapGrand.template.templateRadio, worldMapNodeListType[checkIndex])
    worldMapNodeListType[checkIndex]:addInputEvent("Mouse_LUp", "HandleClicked_GrandWorldMap_SearchNodeType(" .. checkIndex .. ")")
    worldMapNodeListType[checkIndex]:addInputEvent("Mouse_On", "worldmapGrand_nodeTypeTooltip( true," .. checkIndex .. ")")
    worldMapNodeListType[checkIndex]:addInputEvent("Mouse_Out", "worldmapGrand_nodeTypeTooltip( false )")
    worldMapNodeListType[checkIndex]:setTooltipEventRegistFunc("worldmapGrand_nodeTypeTooltip( true," .. checkIndex .. ")")
    worldMapNodeListType[checkIndex]:SetShow(true)
    worldMapNodeListType[checkIndex]:SetEnable(true)
  end
end
function FGlobal_WorldmapMain_GetNodeTypeRadioButton(nodeType)
  return worldMapNodeListType[nodeType]
end
function FGlobal_WorldmapMain_AddEffectNodeTypeRadioButton(nodeType, effectName, isLoop, offsetX, offsetY)
  worldMapNodeListType[nodeType]:AddEffect(effectName, isLoop, offsetX, offsetY)
end
function FGlobal_WorldmapMain_EraseAllEffectNodeTypeRadioButton(nodeType)
  worldMapNodeListType[nodeType]:EraseAllEffect()
end
local function nodeControl_SetTexture()
  for checkIndex = 0, nodeListCount - 1 do
    local value = nodeList[checkIndex]
    changeNodeTexture(value)
  end
end
local function MakeSearchResultPool()
  for idx = 0, worldmapGrand.config.searchingResultMaxCount - 1 do
    worldmapGrand.searchResultUiPool[idx] = UI.createAndCopyBasePropertyControl(Instance_WorldMap_Main, "List_itemName", worldmapGrand.ui.list_SearchBG, "WorldmapGrand_SearchResultList_" .. idx)
    worldmapGrand.searchResultUiPool[idx]:SetPosX(4)
    worldmapGrand.searchResultUiPool[idx]:SetPosY(5 + (worldmapGrand.searchResultUiPool[idx]:GetSizeY() + 3) * idx)
    worldmapGrand.searchResultUiPool[idx]:SetText("")
    worldmapGrand.searchResultUiPool[idx]:SetShow(false)
  end
end
function FGlobal_WorldmapMain_GetSearchResultUiPool(index)
  return worldmapGrand.searchResultUiPool[index]
end
function FGlobal_WorldmapMain_GetSearchingResultCount()
  return worldmapGrand.config.searchingResultCount
end
local function AlignButtonPosition()
  local offsetX = getScreenSizeX() - 450
  for modeIndex, value in pairs(worldMapState) do
    value:SetPosX(offsetX + (value:GetSizeX() + 7) * (modeIndex - 1))
    value:SetPosY(15)
  end
  for checkIndex, value in pairs(worldMapCheckState) do
    worldMapCheckState[checkIndex]:SetPosX(offsetX + 40 + (worldMapCheckState[checkIndex]:GetSizeX() + 10) * checkIndex)
    worldMapCheckState[checkIndex]:SetPosY(76)
  end
  worldmapGrand.ui.filterBg:SetPosX(worldMapCheckState[0]:GetPosX() - 30)
  worldmapGrand.ui.filterBg:SetPosY(worldMapCheckState[0]:GetPosY() - 2)
  worldmapGrand.ui.filterArrow:SetPosX(worldMapState[_currentRenderMode]:GetPosX() + worldMapState[_currentRenderMode]:GetSizeX() / 2 - worldmapGrand.ui.filterArrow:GetSizeX() / 2)
  worldmapGrand.ui.filterArrow:SetPosY(worldMapCheckState[0]:GetPosY() - worldmapGrand.ui.filterArrow:GetSizeY() - 3)
  worldmapGrand.ui.daySelectBg:SetPosX(worldmapGrand.ui.filterBg:GetPosX() + worldmapGrand.ui.filterBg:GetSizeX() - worldmapGrand.ui.daySelectBg:GetSizeX())
  worldmapGrand.ui.daySelectBg:SetPosY(worldmapGrand.ui.filterBg:GetPosY() + worldmapGrand.ui.filterBg:GetSizeY() + 10)
  worldmapGrand.ui.daySelectTitle:SetPosX(worldmapGrand.ui.daySelectBg:GetPosX() + worldmapGrand.ui.daySelectBg:GetSizeX() / 2 - worldmapGrand.ui.daySelectTitle:GetSizeX() / 2)
  worldmapGrand.ui.daySelectTitle:SetPosY(worldmapGrand.ui.daySelectBg:GetPosY() + 5)
  worldmapGrand.ui.comboBox_DaySelect:SetPosX(worldmapGrand.ui.daySelectBg:GetPosX() + worldmapGrand.ui.daySelectBg:GetSizeX() - worldmapGrand.ui.comboBox_DaySelect:GetSizeX())
  worldmapGrand.ui.comboBox_DaySelect:SetPosY(worldmapGrand.ui.daySelectBg:GetPosY() + 35)
  worldmapGrand.ui.comboBox_TaxGrade:SetPosX(worldmapGrand.ui.daySelectBg:GetPosX())
  worldmapGrand.ui.comboBox_TaxGrade:SetPosY(worldmapGrand.ui.daySelectBg:GetPosY() + 35)
  worldmapGrand.ui.nodeSelectBg:SetPosX(worldmapGrand.ui.filterBg:GetPosX() + worldmapGrand.ui.filterBg:GetSizeX() - worldmapGrand.ui.nodeSelectBg:GetSizeX())
  worldmapGrand.ui.nodeSelectBg:SetPosY(worldmapGrand.ui.filterBg:GetPosY() + worldmapGrand.ui.filterBg:GetSizeY() + 10)
  worldmapGrand.ui.nodeSelectTitle:SetPosX(worldmapGrand.ui.nodeSelectBg:GetPosX() + worldmapGrand.ui.nodeSelectBg:GetSizeX() / 2 - worldmapGrand.ui.nodeSelectTitle:GetSizeX() / 2)
  worldmapGrand.ui.nodeSelectTitle:SetPosY(worldmapGrand.ui.nodeSelectBg:GetPosY() + 5)
  worldmapGrand.ui.comboBox_NodeType:SetPosX(worldmapGrand.ui.nodeSelectBg:GetPosX() + worldmapGrand.ui.nodeSelectBg:GetSizeX() - worldmapGrand.ui.comboBox_NodeType:GetSizeX())
  worldmapGrand.ui.comboBox_NodeType:SetPosY(worldmapGrand.ui.nodeSelectBg:GetPosY() + 35)
  worldmapGrand.ui.comboBox_TerritorySelect:SetPosX(worldmapGrand.ui.nodeSelectBg:GetPosX())
  worldmapGrand.ui.comboBox_TerritorySelect:SetPosY(worldmapGrand.ui.nodeSelectBg:GetPosY() + 35)
  local colsCount = 6
  local xGap = 10
  local yGap = 37
  for checkIndex = 0, nodeListCount - 1 do
    local value = nodeList[checkIndex]
    worldMapNodeListType[value]:SetPosX(xGap + checkIndex % colsCount * worldMapNodeListType[value]:GetSizeX() + (checkIndex - 1) * 7)
    worldMapNodeListType[value]:SetPosY(yGap + worldMapNodeListType[value]:GetSizeY() * math.floor(checkIndex / colsCount) + 10)
  end
  local uiControl = worldmapGrand.ui
  local seachBoxStartPosY = worldMapNodeListType[nodeList[nodeListCount - 1]]:GetPosY() + worldMapNodeListType[nodeList[nodeListCount - 1]]:GetSizeY() + 22
  uiControl.edit_NodeName:SetPosY(seachBoxStartPosY)
  uiControl.btn_SearchNodeName:SetPosY(seachBoxStartPosY)
  uiControl.edit_ItemName:SetPosY(uiControl.edit_NodeName:GetPosY() + uiControl.edit_NodeName:GetSizeY() + 4)
  uiControl.btn_SearchItemName:SetPosY(uiControl.edit_NodeName:GetPosY() + uiControl.edit_NodeName:GetSizeY() + 4)
  uiControl.edit_UseType:SetPosY(uiControl.edit_ItemName:GetPosY() + uiControl.edit_ItemName:GetSizeY() + 4)
  uiControl.btn_SearchUseType:SetPosY(uiControl.edit_ItemName:GetPosY() + uiControl.edit_ItemName:GetSizeY() + 4)
  uiControl.edit_GuildName:SetPosY(uiControl.edit_UseType:GetPosY() + uiControl.edit_UseType:GetSizeY() + 4)
  uiControl.btn_SearchGuildName:SetPosY(uiControl.edit_UseType:GetPosY() + uiControl.edit_UseType:GetSizeY() + 4)
end
local function worldmapGrand_OpenSet()
  local uiControl = worldmapGrand.ui
  if isEnableBattle then
    worldmapGrand.ui.edit_GuildName:SetShow(true)
    worldmapGrand.ui.btn_SearchGuildName:SetShow(true)
  else
    worldmapGrand.ui.edit_GuildName:SetShow(false)
    worldmapGrand.ui.btn_SearchGuildName:SetShow(false)
  end
  worldmapGrand.ui.TitleBG:SetSize(getScreenSizeX(), worldmapGrand.ui.TitleBG:GetSizeY())
  worldmapGrand.ui.TopIconBG:ComputePos()
  worldmapGrand.ui.TitleBG:ComputePos()
  uiControl.edit_NodeName:SetEditText(worldmapGrand.config.searchDefaultNodeName, true)
  uiControl.edit_ItemName:SetEditText(worldmapGrand.config.searchDefaultItemName, true)
  uiControl.edit_UseType:SetEditText(worldmapGrand.config.searchDefaultUseType, true)
  uiControl.edit_GuildName:SetEditText(worldmapGrand.config.searchDefaultGuildName, true)
end
function WorldMapCheckListChange(checkState)
  local withSave = _currentRenderMode == eWorldmapState.eWMS_EXPLORE_PLANT
  ToClient_WorldmapCheckState(checkState, worldMapCheckState[checkState]:IsCheck(), withSave)
  if withSave then
    worldMapCheckStateInMode[_currentRenderMode][checkState] = worldMapCheckState[checkState]:IsCheck()
  end
  if CppEnums.WorldMapCheckState.eCheck_Postions == checkState and true == worldMapCheckState[checkState]:IsCheck() then
    if eWorldmapState.eWMS_EXPLORE_PLANT == _currentRenderMode then
      FGlobal_ActorTooltip_SetShowPartyMemberIcon(true)
    end
  else
    FGlobal_ActorTooltip_SetShowPartyMemberIcon(false)
  end
end
local function CheckStateByChangeMode()
  for checkIndex, value in pairs(worldMapCheckStateInMode[_currentRenderMode]) do
    worldMapCheckState[checkIndex]:SetCheck(value)
    ToClient_WorldmapCheckState(checkIndex, worldMapCheckState[checkIndex]:IsCheck(), false)
  end
end
function worldmapGrand:UpdateList()
  if worldmapGrand_SearchType.nodeName == self.config.searchType then
    self.ui.list_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_SEARCHTITLE_NODE"))
    self.ui.list_KeyWord:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_SEARCHKEYWORD", "keyword", self.ui.edit_NodeName:GetEditText(), "count", self.config.searchingResultCount))
  elseif worldmapGrand_SearchType.nodeType == self.config.searchType then
    self.ui.list_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_SEARCHTITLE_NODE"))
    self.ui.list_KeyWord:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_NODETYPEKEYWORD", "keyword", worldMapNodeType_String[self.config.selectNodeType], "count", self.config.searchingResultCount))
  elseif worldmapGrand_SearchType.itemName == self.config.searchType then
    self.ui.list_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_SEARCHTITLE_HOUSE"))
    self.ui.list_KeyWord:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_SEARCHKEYWORD", "keyword", self.ui.edit_ItemName:GetEditText(), "count", self.config.searchingResultCount))
  elseif worldmapGrand_SearchType.GuildName == self.config.searchType then
    self.ui.list_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_SEARCHTITLE_NODE"))
    self.ui.list_KeyWord:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_SEARCHKEYWORD", "keyword", self.ui.edit_GuildName:GetEditText(), "count", self.config.searchingResultCount))
  else
    self.ui.list_Title:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_SEARCHTITLE_USETYPE"))
    self.ui.list_KeyWord:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_SEARCHKEYWORD", "keyword", self.ui.edit_UseType:GetEditText(), "count", self.config.searchingResultCount))
  end
  for idx = 0, self.config.searchingResultMaxCount - 1 do
    self.searchResultUiPool[idx]:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
    self.searchResultUiPool[idx]:SetText("")
    self.searchResultUiPool[idx]:SetShow(false)
    self.searchResultUiPool[idx]:addInputEvent("Mouse_LUp", "")
  end
  local resultUiCount = 0
  for resultIdx = self.config.scrollStartIdx, self.config.searchingResultCount - 1 do
    if resultUiCount >= self.config.searchingResultMaxCount then
      break
    end
    local resultString = ""
    if worldmapGrand_SearchType.nodeName == self.config.searchType then
      resultString = ToClient_getFindResultNameByIndex(resultIdx)
    elseif worldmapGrand_SearchType.nodeType == self.config.searchType then
      resultString = ToClient_getFindResultNameByIndex(resultIdx)
    elseif worldmapGrand_SearchType.itemName == self.config.searchType then
      local HouseInfoStaticStatusWrapper = ToClient_getHouseInfoWrapperByIndex(resultIdx)
      resultString = HouseInfoStaticStatusWrapper:getName()
    elseif worldmapGrand_SearchType.GuildName == self.config.searchType then
      resultString = ToClient_getFindResultNameByIndex(resultIdx)
    else
      local HouseInfoStaticStatusWrapper = ToClient_getHouseInfoWrapperByHouseUseTypeNameIndex(resultIdx)
      resultString = HouseInfoStaticStatusWrapper:getName()
    end
    local slot = self.searchResultUiPool[resultUiCount]
    slot:addInputEvent("Mouse_LUp", "HandleClicked_GrandWorldMap_GotoNodeFocus( " .. resultIdx .. " )")
    slot:addInputEvent("Mouse_UpScroll", "GrandWorldMap_Scroll( true )")
    slot:addInputEvent("Mouse_DownScroll", "GrandWorldMap_Scroll( false )")
    slot:SetText(resultString)
    slot:SetShow(true)
    resultUiCount = resultUiCount + 1
  end
  UIScroll.SetButtonSize(self.ui.list_scroll, self.config.searchingResultMaxCount, self.config.searchingResultCount)
end
function WorldmapNodeList_UpScrollEvent()
  GrandWorldMap_Scroll(true)
end
function WorldmapNodeList_DownScrollEvent()
  GrandWorldMap_Scroll(false)
end
function worldmapGrand:UpdateExplorePoint()
  local territoryKeyRaw = ToClient_getDefaultTerritoryKey()
  local explorePoint = ToClient_getExplorePointByTerritoryRaw(territoryKeyRaw)
  local cont_expRate = Int64toInt32(explorePoint:getExperience_s64()) / Int64toInt32(getRequireExplorationExperience_s64())
  self.ui.explorePointIcon:SetText(PAGetString(Defines.StringSheet_RESOURCE, "CHARACTERINFO_TEXT_CONTRIBUTION"))
  self.ui.explorePointValue:SetText(tostring(explorePoint:getRemainedPoint()) .. " / " .. tostring(explorePoint:getAquiredPoint()))
  if isGameTypeEnglish() or isGameTypeSA() or isGameTypeTH() or isGameTypeID() or isGameTypeTR() then
    worldmapGrand.ui.explorePointIcon:SetVerticalTop()
    worldmapGrand.ui.explorePointValue:SetPosY(worldmapGrand.ui.explorePointIcon:GetPosY() + worldmapGrand.ui.explorePointIcon:GetTextSizeY() + 10)
    worldmapGrand.ui.explorePointBG:SetSize(229, worldmapGrand.ui.explorePointIcon:GetTextSizeY() + worldmapGrand.ui.explorePointValue:GetTextSizeY() + 25)
  else
    worldmapGrand.ui.explorePointBG:SetSize(229, 40)
    worldmapGrand.ui.explorePointIcon:SetVerticalTop()
    worldmapGrand.ui.explorePointValue:SetTextVerticalTop()
    worldmapGrand.ui.explorePointValue:SetSpanSize(10, 12)
  end
end
local function guildWar_Filter_Init()
  worldmapGrand.ui.daySelectBg:SetShow(false)
  worldmapGrand.ui.daySelectTitle:SetShow(false)
  worldmapGrand.ui.comboBox_DaySelect:SetShow(false)
  worldmapGrand.ui.comboBox_TaxGrade:SetShow(false)
  worldmapGrand.ui.comboBox_DaySelect:SetSelectItemIndex(-1)
  worldmapGrand.ui.comboBox_DaySelect:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_SELECTDAY"))
  worldmapGrand.ui.comboBox_TaxGrade:SetSelectItemIndex(-1)
  worldmapGrand.ui.comboBox_TaxGrade:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_VILLAGETENT_SELECTTAXGRADE"))
  ToClient_resetVisibleVillageSiegeType()
  ToClient_resetVisibleVillageSiegeTaxLevel()
  FGlobal_ApprovalRating_SetShow(false)
end
local function productNode_Filter_Init()
  _selectNodeType = -1
  _selectTerritory = -1
  worldmapGrand.ui.nodeSelectBg:SetShow(false)
  worldmapGrand.ui.nodeSelectTitle:SetShow(false)
  worldmapGrand.ui.comboBox_TerritorySelect:SetShow(false)
  worldmapGrand.ui.comboBox_NodeType:SetShow(false)
  worldmapGrand.ui.comboBox_TerritorySelect:SetSelectItemIndex(-1)
  worldmapGrand.ui.comboBox_TerritorySelect:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TERRITORYSTRING_ALL"))
  worldmapGrand.ui.comboBox_NodeType:SetSelectItemIndex(-1)
  worldmapGrand.ui.comboBox_NodeType:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_NODESELECT"))
  WorldMapArrowEffectErase()
end
function FGlobal_WorldMapOpenForMain()
  AlignButtonPosition()
  worldmapGrand_OpenSet()
  Instance_WorldMap_Main:SetShow(true, false)
  for index, checkArray in pairs(worldMapCheckStateInMode) do
    for checkIndex, value in pairs(worldMapCheckState) do
      if index == eWorldmapState.eWMS_EXPLORE_PLANT then
        checkArray[checkIndex] = ToClient_isWorldmapCheckState(checkIndex)
      elseif index == eWorldmapState.eWMS_GUILD_WAR then
        if checkIndex == eCheckState.eCheck_Node or checkIndex == eCheckState.eCheck_Postions then
          checkArray[checkIndex] = true
        else
          checkArray[checkIndex] = false
        end
      elseif index == eWorldmapState.eWMS_PRODUCT_NODE then
        if checkIndex == eCheckState.eCheck_Node then
          checkArray[checkIndex] = true
        else
          checkArray[checkIndex] = false
        end
      else
        checkArray[checkIndex] = false
      end
    end
  end
  for checkIndex, value in pairs(worldMapCheckState) do
    value:SetCheck(worldMapCheckStateInMode[_currentRenderMode][checkIndex])
    ToClient_WorldmapCheckState(checkIndex, value:IsCheck(), false)
  end
  for idx, value in pairs(worldMapNodeListType) do
    worldMapNodeListType[idx]:SetCheck(false)
  end
  local defaultSelectFilter = worldMapNodeType.city
  HandleClicked_GrandWorldMap_SearchNodeType(defaultSelectFilter)
  worldMapNodeListType[defaultSelectFilter]:SetCheck(true)
  CheckStateByChangeMode()
  worldMapState[_currentRenderMode]:SetCheck(true)
  worldmapGrand:UpdateExplorePoint()
  FGlobal_WorldmapGrand_Bottom_MenuSet()
  worldmapGrand.ui.list_scroll:SetControlPos(0)
  worldmapGrand.config.scrollStartIdx = 0
  guildWar_Filter_Init()
  productNode_Filter_Init()
  ToClient_setDoTerrainHide(_currentRenderMode == eWorldmapState.eWMS_PRODUCT_NODE)
  if _currentRenderMode == eWorldmapState.eWMS_GUILD_WAR then
    worldmapGrand.ui.daySelectBg:SetShow(true)
    worldmapGrand.ui.daySelectTitle:SetShow(true)
    worldmapGrand.ui.comboBox_DaySelect:SetShow(true)
    worldmapGrand.ui.comboBox_TaxGrade:SetShow(true)
    if true == isEnablePlunderGame then
      FGlobal_ApprovalRating_SetShow(true)
    end
  elseif _currentRenderMode == eWorldmapState.eWMS_PRODUCT_NODE then
    worldmapGrand.ui.nodeSelectBg:SetShow(true)
    worldmapGrand.ui.nodeSelectTitle:SetShow(true)
    worldmapGrand.ui.comboBox_TerritorySelect:SetShow(true)
    worldmapGrand.ui.comboBox_NodeType:SetShow(true)
  end
  if state == eWorldmapState.eWMS_EXPLORE_PLANT then
    if true == worldMapCheckState[CppEnums.WorldMapCheckState.eCheck_Postions]:IsCheck() then
      FGlobal_ActorTooltip_SetShowPartyMemberIcon(true)
    else
      FGlobal_ActorTooltip_SetShowPartyMemberIcon(false)
    end
  else
    FGlobal_ActorTooltip_SetShowPartyMemberIcon(false)
  end
  FGlobal_WorldmapMain_InitTutorialButton()
  FGlobal_Hide_Tooltip_Work(nil, true)
end
function FGlobal_WorldmapGrand_Main_UpdateExplorePoint()
  worldmapGrand:UpdateExplorePoint()
end
function FGlobal_resetGuildWarMode()
  _isGuildWarMode = false
  ToClient_SetGuildMode(false)
end
function FGlobal_isGuildWarMode()
  return _isGuildWarMode
end
function FGlobal_WorldMapStateMaintain()
  CheckStateByChangeMode()
end
function WorldMapStateChange(state)
  guildWar_Filter_Init()
  productNode_Filter_Init()
  _currentRenderMode = state
  local renderState = state
  _isBlackFog = false
  if eWorldmapState.eWMS_EXPLORE_PLANT == state then
    _isGuildWarMode = false
  elseif eWorldmapState.eWMS_GUILD_WAR == state then
    renderState = eWorldmapState.eWMS_EXPLORE_PLANT
    worldmapGrand.ui.daySelectBg:SetShow(true)
    worldmapGrand.ui.daySelectTitle:SetShow(true)
    worldmapGrand.ui.comboBox_DaySelect:SetShow(true)
    worldmapGrand.ui.comboBox_TaxGrade:SetShow(true)
    if true == isEnablePlunderGame then
      FGlobal_ApprovalRating_SetShow(true)
    end
    _isGuildWarMode = true
  elseif eWorldmapState.eWMS_PRODUCT_NODE == state then
    worldmapGrand.ui.nodeSelectBg:SetShow(true)
    worldmapGrand.ui.nodeSelectTitle:SetShow(true)
    worldmapGrand.ui.comboBox_TerritorySelect:SetShow(true)
    worldmapGrand.ui.comboBox_NodeType:SetShow(true)
    _isBlackFog = true
    _isGuildWarMode = false
    renderState = eWorldmapState.eWMS_EXPLORE_PLANT
  else
    _isGuildWarMode = false
  end
  ToClient_SetGuildMode(_isGuildWarMode)
  handleGuildModeChange(_isGuildWarMode)
  ToClient_WorldmapStateChange(renderState)
  CheckStateByChangeMode()
  ToClient_setDoTerrainHide(_isBlackFog)
  worldmapGrand.ui.filterArrow:SetPosX(worldMapState[state]:GetPosX() + worldMapState[state]:GetSizeX() / 2 - worldmapGrand.ui.filterArrow:GetSizeX() / 2)
  if state == eWorldmapState.eWMS_EXPLORE_PLANT then
    if true == worldMapCheckState[CppEnums.WorldMapCheckState.eCheck_Postions]:IsCheck() then
      FGlobal_ActorTooltip_SetShowPartyMemberIcon(true)
    else
      FGlobal_ActorTooltip_SetShowPartyMemberIcon(false)
    end
  else
    FGlobal_ActorTooltip_SetShowPartyMemberIcon(false)
  end
end
function WorldMapArrowEffectEraseClear()
  btnArray = {}
end
function WorldMapArrowEffectErase()
  if nil == btnArray then
    return
  end
  for v, btn in pairs(btnArray) do
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
  btnArray = {}
end
function FromClient_NodeFilterOn(house_btn)
  local btn = house_btn
  table.insert(btnArray, btn)
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
registerEvent("FromClient_NodeFilterOn", "FromClient_NodeFilterOn")
function FGlobal_SetNodeFilter()
  if worldmapGrand.ui.nodeSelectBg:GetShow() then
    PrevNodeType_Set()
  end
end
function handleGuildModeChange(isGuildMode)
  ToClient_reloadNodeLine(isGuildMode, CppEnums.WaypointKeyUndefined)
end
function WorldMapStateChange_SimpleTooltips(isShow, tipType)
  local name, desc, control
  if eWorldmapState.eWMS_EXPLORE_PLANT == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_PLANT_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_PLANT_DESC")
  elseif eWorldmapState.eWMS_REGION == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_REGION_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_REGION_DESC")
  elseif eWorldmapState.eWMS_LOCATION_INFO_WATER == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_WATER_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_WATER_DESC")
  elseif eWorldmapState.eWMS_LOCATION_INFO_CELCIUS == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_CELCIUS_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_CELCIUS_DESC")
  elseif eWorldmapState.eWMS_LOCATION_INFO_HUMIDITY == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_HUMIDITY_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_HUMIDITY_DESC")
  elseif eWorldmapState.eWMS_GUILD_WAR == tipType then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_GUILDWAR_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_GUILDWAR_DESC")
  else
    if eWorldmapState.eWMS_PRODUCT_NODE == tipType then
      name = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TOOLTIP_NODEFILTER")
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_TOOLTIP_NODEFILTERDESC")
    else
    end
  end
  control = worldMapState[tipType]
  if isShow == true and nil ~= control then
    registTooltipControl(control, Instance_Tooltip_SimpleText)
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function WorldMapCheckListToolTips(isShow, checkType)
  if checkType == eCheckState.eCheck_Quest then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_QUEST_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_QUEST_DESC")
    uiControl = worldMapCheckState[eCheckState.eCheck_Quest]
  elseif checkType == eCheckState.eCheck_Knowledge then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_KNOWLEDGE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_KNOWLEDGE_DESC")
    uiControl = worldMapCheckState[eCheckState.eCheck_Knowledge]
  elseif checkType == eCheckState.eCheck_FishnChip then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_FISH_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_FISH_DESC")
    uiControl = worldMapCheckState[eCheckState.eCheck_FishnChip]
  elseif checkType == eCheckState.eCheck_Node then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_NODE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_NODE_DESC")
    uiControl = worldMapCheckState[eCheckState.eCheck_Node]
  elseif checkType == eCheckState.eCheck_Trade then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_TRADE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_TRADE_DESC")
    uiControl = worldMapCheckState[eCheckState.eCheck_Trade]
  elseif checkType == eCheckState.eCheck_Way then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_DIRECTION_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_DIRECTION_DESC")
    uiControl = worldMapCheckState[eCheckState.eCheck_Way]
  elseif checkType == eCheckState.eCheck_Postions then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_WHERE_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_NEW_WORLDMAP_PANEL_TOOLTIP_WHERE_DESC")
    uiControl = worldMapCheckState[eCheckState.eCheck_Postions]
  elseif checkType == eCheckState.eCheck_Wagon then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_PANEL_TOOLTIP_WAGON")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_PANEL_TOOLTIP_WAGON_DESC")
    uiControl = worldMapCheckState[eCheckState.eCheck_Wagon]
  elseif checkType == eCheckState.eCheck_Monster then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_PANEL_TOOLTIP_MONSTERINFO_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_PANEL_TOOLTIP_MONSTERINFO_DESC")
    uiControl = worldMapCheckState[eCheckState.eCheck_Monster]
  end
  if true == isShow then
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function worldmapGrand_nodeTypeTooltip(isShow, typeIdx)
  local uiControl = worldMapNodeListType[typeIdx]
  local name = worldMapNodeType_String[typeIdx]
  local desc
  if true == isShow then
    registTooltipControl(uiControl, Instance_Tooltip_SimpleText)
    TooltipSimple_Show(uiControl, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function HandleClicked_GrandWorldMap_SearchNode()
  worldmapGrand.ui.edit_ItemName:SetEditText(worldmapGrand.config.searchDefaultItemName, true)
  worldmapGrand.ui.edit_UseType:SetEditText(worldmapGrand.config.searchDefaultUseType, true)
  local searchString = worldmapGrand.ui.edit_NodeName:GetEditText()
  worldmapGrand.config.searchType = worldmapGrand_SearchType.nodeName
  ClearFocusEdit()
  SetUIMode(Defines.UIMode.eUIMode_WorldMap)
  worldmapGrand.config.searchingResultCount = ToClient_FindNodeByName(tostring(searchString))
  worldmapGrand.ui.list_scroll:SetControlPos(0)
  worldmapGrand.config.scrollStartIdx = 0
  worldmapGrand:UpdateList()
end
function HandleClicked_GrandWorldMap_SearchGuild()
  worldmapGrand.ui.edit_ItemName:SetEditText(worldmapGrand.config.searchDefaultItemName, true)
  worldmapGrand.ui.edit_UseType:SetEditText(worldmapGrand.config.searchDefaultUseType, true)
  local searchString = worldmapGrand.ui.edit_GuildName:GetEditText()
  worldmapGrand.config.searchType = worldmapGrand_SearchType.GuildName
  ClearFocusEdit()
  SetUIMode(Defines.UIMode.eUIMode_WorldMap)
  worldmapGrand.config.searchingResultCount = ToClient_findNodebyGuildName(tostring(searchString))
  worldmapGrand.ui.list_scroll:SetControlPos(0)
  worldmapGrand.config.scrollStartIdx = 0
  worldmapGrand:UpdateList()
end
function HandleClicked_GrandWorldMap_SearchItem()
  worldmapGrand.ui.edit_NodeName:SetEditText(worldmapGrand.config.searchDefaultNodeName, true)
  worldmapGrand.ui.edit_UseType:SetEditText(worldmapGrand.config.searchDefaultUseType, true)
  local searchString = worldmapGrand.ui.edit_ItemName:GetEditText()
  worldmapGrand.config.searchType = worldmapGrand_SearchType.itemName
  ClearFocusEdit()
  SetUIMode(Defines.UIMode.eUIMode_WorldMap)
  worldmapGrand.config.searchingResultCount = ToCleint_findHouseByItemName(tostring(searchString))
  worldmapGrand.ui.list_scroll:SetControlPos(0)
  worldmapGrand.config.scrollStartIdx = 0
  worldmapGrand:UpdateList()
end
function HandleClicked_GrandWorldMap_SearchUseType()
  worldmapGrand.ui.edit_ItemName:SetEditText(worldmapGrand.config.searchDefaultItemName, true)
  worldmapGrand.ui.edit_NodeName:SetEditText(worldmapGrand.config.searchDefaultNodeName, true)
  local searchString = worldmapGrand.ui.edit_UseType:GetEditText()
  worldmapGrand.config.searchType = worldmapGrand_SearchType.UseType
  ClearFocusEdit()
  SetUIMode(Defines.UIMode.eUIMode_WorldMap)
  worldmapGrand.config.searchingResultCount = ToClient_findHouseByHouseUseTypeName(tostring(searchString))
  worldmapGrand.ui.list_scroll:SetControlPos(0)
  worldmapGrand.config.scrollStartIdx = 0
  worldmapGrand:UpdateList()
end
function HandleClicked_GrandWorldMap_SearchNode_ResetString()
  worldmapGrand.ui.edit_ItemName:SetEditText(worldmapGrand.config.searchDefaultItemName, true)
  worldmapGrand.ui.edit_UseType:SetEditText(worldmapGrand.config.searchDefaultUseType, true)
  worldmapGrand.ui.edit_NodeName:SetEditText("", true)
  SetUIMode(Defines.UIMode.eUIMode_WoldMapSearch)
end
function HandleClicked_GrandWorldMap_SearchGuild_ResetString()
  worldmapGrand.ui.edit_NodeName:SetEditText(worldmapGrand.config.searchDefaultNodeName, true)
  worldmapGrand.ui.edit_UseType:SetEditText(worldmapGrand.config.searchDefaultUseType, true)
  worldmapGrand.ui.edit_ItemName:SetEditText(worldmapGrand.config.searchDefaultItemName, true)
  worldmapGrand.ui.edit_GuildName:SetEditText("", true)
  SetUIMode(Defines.UIMode.eUIMode_WoldMapSearch)
end
function HandleClicked_GrandWorldMap_SearchItem_ResetString()
  worldmapGrand.ui.edit_NodeName:SetEditText(worldmapGrand.config.searchDefaultNodeName, true)
  worldmapGrand.ui.edit_UseType:SetEditText(worldmapGrand.config.searchDefaultUseType, true)
  worldmapGrand.ui.edit_GuildName:SetEditText(worldmapGrand.config.searchDefaultGuildName, true)
  worldmapGrand.ui.edit_ItemName:SetEditText("", true)
  SetUIMode(Defines.UIMode.eUIMode_WoldMapSearch)
end
function HandleClicked_GrandWorldMap_SearchUseType_ResetString()
  worldmapGrand.ui.edit_NodeName:SetEditText(worldmapGrand.config.searchDefaultNodeName, true)
  worldmapGrand.ui.edit_ItemName:SetEditText(worldmapGrand.config.searchDefaultItemName, true)
  worldmapGrand.ui.edit_GuildName:SetEditText(worldmapGrand.config.searchDefaultGuildName, true)
  worldmapGrand.ui.edit_UseType:SetEditText("", true)
  SetUIMode(Defines.UIMode.eUIMode_WoldMapSearch)
end
function HandleClicked_GrandWorldMap_SearchNodeType(typeIndex)
  if worldMapNodeType.note == typeIndex then
    return
  end
  worldmapGrand.ui.edit_NodeName:SetEditText(worldmapGrand.config.searchDefaultNodeName, true)
  worldmapGrand.ui.edit_ItemName:SetEditText(worldmapGrand.config.searchDefaultItemName, true)
  worldmapGrand.ui.edit_UseType:SetEditText(worldmapGrand.config.searchDefaultUseType, true)
  worldmapGrand.config.searchType = worldmapGrand_SearchType.nodeType
  worldmapGrand.config.selectNodeType = typeIndex
  worldmapGrand.config.searchingResultCount = ToClient_FindNodeByType(typeIndex)
  worldmapGrand.ui.list_scroll:SetControlPos(0)
  worldmapGrand.config.scrollStartIdx = 0
  worldmapGrand:UpdateList()
  PaGlobal_TutorialManager:handleClickedGrandWorldMapSearchNodeType(typeIndex)
end
function HandleClicked_GrandWorldMap_GotoNodeFocus(resultIdx)
  if worldmapGrand_SearchType.nodeName == worldmapGrand.config.searchType or worldmapGrand_SearchType.nodeType == worldmapGrand.config.searchType then
    ToCleint_gotoFindTown(resultIdx)
  elseif worldmapGrand_SearchType.itemName == worldmapGrand.config.searchType then
    ToClient_gotoHouseNode(resultIdx)
  elseif worldmapGrand_SearchType.GuildName == worldmapGrand.config.searchType then
    ToCleint_gotoFindTown(resultIdx)
  else
    ToClient_gotoHouseNodeHouseUseType(resultIdx)
  end
  PaGlobal_TutorialManager:handleClickedGrandWorldmapGotoNodeFocus(resultIdx)
end
function FGlobal_WorldmapMain_GotoBuildingMostRemainExpiredTime()
  if false == Instance_WorldMap_Main:GetShow() then
    return
  end
  local buildingInfo = ToClient_getBuildingInfoMostRemainExpiredTime()
  if nil == buildingInfo then
    return
  end
  local buildingPosition = buildingInfo:getPosition()
  ToCleint_gotoWorldmapPosition(buildingPosition)
end
function GrandWorldMap_Scroll(isUp)
  worldmapGrand.config.scrollStartIdx = UIScroll.ScrollEvent(worldmapGrand.ui.list_scroll, isUp, worldmapGrand.config.searchingResultMaxCount, worldmapGrand.config.searchingResultCount, worldmapGrand.config.scrollStartIdx, 1)
  worldmapGrand:UpdateList()
end
function HandleClicked_GrandWorldMap_ScrollPress()
  local config = worldmapGrand.config
  local scrollPos = worldmapGrand.ui.list_scroll:GetControlPos()
  local resultCount = config.searchingResultCount
  local maxViewCount = config.searchingResultMaxCount
  config.scrollStartIdx = math.ceil((resultCount - maxViewCount) * scrollPos)
  worldmapGrand:UpdateList()
end
function HandleOnout_GrandWorldMap_explorePointHelp(isShow)
  local control = worldmapGrand.ui.explorePointHelp
  if isShow then
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_HELPICON_EXPLORERPOINT")
    local desc
    registTooltipControl(control, Instance_Tooltip_SimpleText)
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function FGlobal_GrandWorldMap_SearchToWorldMapMode()
  ClearFocusEdit()
  SetUIMode(Defines.UIMode.eUIMode_WorldMap)
end
function worldmapGrand_OnScreenResize()
  Instance_WorldMap_Main:SetSize(getScreenSizeX(), getScreenSizeY())
  worldmapGrand.ui.ModeBG:ComputePos()
end
function FromClient_RenderStateChange(state)
  for checkIndex, value in pairs(worldMapCheckState) do
    worldMapCheckState[checkIndex]:SetCheck(ToClient_isWorldmapCheckState(checkIndex))
  end
end
function worldmapGrand:registEventHandler()
  local ui = self.ui
  ui.ListBG:addInputEvent("Mouse_UpScroll", "GrandWorldMap_Scroll( true )")
  ui.ListBG:addInputEvent("Mouse_DownScroll", "GrandWorldMap_Scroll( false )")
  ui.buttonBlackSpirit:addInputEvent("Mouse_LUp", "HandleClicked_GrandWorldMap_BlackSpiritButton()")
  ui.buttonTutorial_1:addInputEvent("Mouse_LUp", "HandleClicked_GrandWorldMap_TutorialButton( 1 )")
  ui.buttonTutorial_2:addInputEvent("Mouse_LUp", "HandleClicked_GrandWorldMap_TutorialButton( 2 )")
  ui.buttonTutorial_3:addInputEvent("Mouse_LUp", "HandleClicked_GrandWorldMap_TutorialButton( 3 )")
  ui.btn_SearchNodeName:addInputEvent("Mouse_LUp", "HandleClicked_GrandWorldMap_SearchNode()")
  ui.btn_SearchItemName:addInputEvent("Mouse_LUp", "HandleClicked_GrandWorldMap_SearchItem()")
  ui.btn_SearchUseType:addInputEvent("Mouse_LUp", "HandleClicked_GrandWorldMap_SearchUseType()")
  ui.btn_SearchGuildName:addInputEvent("Mouse_LUp", "HandleClicked_GrandWorldMap_SearchGuild()")
  ui.edit_NodeName:addInputEvent("Mouse_LUp", "HandleClicked_GrandWorldMap_SearchNode_ResetString()")
  ui.edit_NodeName:RegistReturnKeyEvent("HandleClicked_GrandWorldMap_SearchNode()")
  ui.edit_GuildName:addInputEvent("Mouse_LUp", "HandleClicked_GrandWorldMap_SearchGuild_ResetString()")
  ui.edit_GuildName:RegistReturnKeyEvent("HandleClicked_GrandWorldMap_SearchGuild()")
  ui.edit_ItemName:addInputEvent("Mouse_LUp", "HandleClicked_GrandWorldMap_SearchItem_ResetString()")
  ui.edit_ItemName:RegistReturnKeyEvent("HandleClicked_GrandWorldMap_SearchItem()")
  ui.edit_UseType:addInputEvent("Mouse_LUp", "HandleClicked_GrandWorldMap_SearchUseType_ResetString()")
  ui.edit_UseType:RegistReturnKeyEvent("HandleClicked_GrandWorldMap_SearchUseType()")
  ui.list_scrollBtn:addInputEvent("Mouse_LPress", "HandleClicked_GrandWorldMap_ScrollPress()")
  ui.list_scroll:addInputEvent("Mouse_LUp", "HandleClicked_GrandWorldMap_ScrollPress()")
end
MakeModeButton()
MakeModeChekcState()
MakeSearchResultPool()
MakeNodeListType()
nodeControl_SetTexture()
worldmapGrand:registEventHandler()
registerEvent("onScreenResize", "worldmapGrand_OnScreenResize")
registerEvent("FromClient_RenderStateChange", "FromClient_RenderStateChange")
registerEvent("FromClient_MouseOnWorldmapMonsterInfo", "FromClient_MouseOnWorldmapMonsterInfo")
registerEvent("FromClient_MouseOutWorldmapMonsterInfo", "FromClient_MouseOutWorldmapMonsterInfo")
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_WorldmapMain")
function FromClient_luaLoadComplete_WorldmapMain()
  FGlobal_WorldmapMain_InitTutorialButton()
end
function maptest(scale, minScale, maxScale, yGap)
  ToClient_SetScalerWorldmapMonsterInfo(scale, minScale, maxScale, yGap)
end

local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_CCC = CppEnums.CashProductCategory
local UI_CIT = CppEnums.InstallationType
local IM = CppEnums.EProcessorInputMode
local mainTitle = {}
mainTitle = {
  [0] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTALLATIONMODE_FARMINFO_BASEINFOTITLE"),
  [1] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTALLATIONMODE_FARMINFO_FARMMANAGEMENTINFOTITLE"),
  [2] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTALLATIONMODE_FARMINFO_HAVESTINFOTITLE")
}
local farmGuideTitle = {
  [0] = {},
  [1] = {},
  [2] = {}
}
local farmGuideDesc = {
  [0] = {},
  [1] = {},
  [2] = {}
}
local animalGuideTitle = {
  [0] = {},
  [1] = {},
  [2] = {}
}
local animalGuideDesc = {
  [0] = {},
  [1] = {},
  [2] = {}
}
farmGuideTitle[0] = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_0"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_1"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_2"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_3"),
  [4] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_4"),
  [5] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_5")
}
farmGuideTitle[1] = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_0"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_1"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_2"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_3")
}
farmGuideTitle[2] = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC2_0"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC2_1")
}
farmGuideDesc[0] = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_10"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_11"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_12"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_13"),
  [4] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_14"),
  [5] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_15")
}
farmGuideDesc[1] = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_10"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_11"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_12"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_13")
}
farmGuideDesc[2] = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC2_10"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC2_11")
}
animalGuideTitle[0] = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_6"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_1"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_2"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_3"),
  [4] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_4"),
  [5] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_5")
}
animalGuideTitle[1] = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_0"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_1"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_4"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_5")
}
animalGuideTitle[2] = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC2_2"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC2_1")
}
animalGuideDesc[0] = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_20"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_21"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_22"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_23"),
  [4] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_24"),
  [5] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC0_25")
}
animalGuideDesc[1] = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_10"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_14"),
  [2] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_15"),
  [3] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC1_16")
}
animalGuideDesc[2] = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC2_12"),
  [1] = PAGetString(Defines.StringSheet_GAME, "LUA_INSTALLATIONMODE_FARMGUIDE_DESC2_13")
}
local Panel_Window_InstallationMode_Farm_info = {
  _ui = {
    static_Farm_InstallationMode_Right = nil,
    static_TitleBg = nil,
    staticText_Title_Top = nil,
    static_TabMenuBG = nil,
    radioButton_Main = nil,
    radioButton_Plantation = nil,
    radioButton_Animal = nil,
    staticText_ToolTip = nil,
    static_Faming_MainBG = nil,
    static_Faming_Info = nil,
    staticText_GardenUsedPoint = nil,
    staticText_TempeaturePoint = nil,
    progress2_TempeatureBar = nil,
    staticText_HumidityPoint = nil,
    progress2_HumidityBar = nil,
    staticText_UndergroundWaterPoint = nil,
    progress2_UndergroundWaterBar = nil,
    staticText_ManurePoint = nil,
    progress2_ManureBar = nil,
    static_Icon_WaterWay = nil,
    staticText_WaterwayTitle = nil,
    staticText_WaterwayDec = nil,
    static_Icon_Scarecrow = nil,
    staticText_ScarecrowTitle = nil,
    staticText_ScarecrowDec = nil,
    static_PlantListBG = nil,
    static_PlantItemTemplete = nil,
    static_Item_Focus = nil,
    scroll_Plant = nil,
    frame_1_PlantInfoList = nil,
    frame_1_Content = nil,
    staticText_MainTitleTemplete1 = nil,
    staticText_SubTitleTemplete1 = nil,
    staticText_DecTemplete1 = nil,
    frame_2_AnimalInfoList = nil,
    frame_2_Content = nil,
    staticText_MainTitleTemplete2 = nil,
    staticText_SubTitleTemplete2 = nil,
    staticText_DecTemplete2 = nil,
    static_BottomBg = nil,
    staticText_A_Select_ConsoleUI = nil,
    staticText_B_Close_ConsoleUI = nil,
    static_KeyGuide_ConsoleBG = nil,
    staticText_RS_Click_ConsoleUI = nil,
    staticText_RS_UpDown_ConsoleUI = nil,
    staticText_RS_LeftRight_ConsoleUI = nil,
    staticText_LS_ConsoleUI = nil,
    staticText_RS_ConsoleUI = nil,
    staticText_LB_RB_ConsoleUI = nil,
    staticText_LT_RT_ConsoleUI = nil,
    staticText_Y_ConsoleUI = nil,
    staticText_X_ConsoleUI = nil,
    staticText_A_ConsoleUI = nil,
    staticText_B_ConsoleUI = nil,
    static_Move = nil
  },
  _value = {
    currentTabIndex = 0,
    currentItemIndex = 0,
    startItemIndex = 0,
    lastStartItemIndex = -1,
    itemDataCount = 0,
    focusIndex = 0,
    currentMode = 0,
    isCanMove = false,
    isCanDelete = false
  },
  _pos = {
    itemSlotStartX = 0,
    itemSlotStartY = 0,
    itemSlotSpace = 15,
    itemSlotSizeX = 0,
    itemSlotSizeY = 0,
    startPosY = 0,
    textSpace = 10,
    titleSpace = 20
  },
  _config = {
    itemMaxIndex = 28,
    itemSlotRow = 4,
    itemSlotCol = 7,
    guidTitleCount = 3,
    guideCount = {
      [0] = 6,
      [1] = 4,
      [2] = 2
    },
    guideTotalCount = 12
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createCash = true
  },
  _menu_Top_Enum = {
    Base = 0,
    PlantGuide = 1,
    AnimalGuide = 2,
    Count = 1
  },
  _menu_Top_String = {
    [0] = nil,
    [1] = nil,
    [2] = nil
  },
  _panelKeyGuideEnum = {Select = 0, CollectDelete = 1},
  _panelKeyGuideString = {
    [0] = nil,
    [1] = nil
  },
  _mode_Type_Enum = {
    InstallMode_None = 0,
    InstallMode_Translation = 1,
    InstallMode_Detail = 2,
    InstallMode_WatingConfirm = 3,
    InstallMode_Count = 4
  },
  _keyGuideString = {build = nil, install = nil},
  _texture = {
    path = "renewal/ui_icon/console_icon_02.dds",
    existWater = {
      297,
      1,
      360,
      64
    },
    noneWater = {
      233,
      1,
      296,
      64
    },
    existScarecrow = {
      297,
      65,
      360,
      128
    },
    noneScarecrow = {
      233,
      65,
      296,
      128
    }
  },
  _keyGuideBottom = {},
  _keyGuide = {},
  _tabSlot = {},
  _tabPage = {},
  _plantTitle = {},
  _plantSubTitle = {},
  _plantDesc = {},
  _animalTitle = {},
  _animalSubTitle = {},
  _animalDesc = {},
  _itemSlotBG = {},
  _itemSlot = {},
  _screenGapSize = {x = 0, y = 0}
}
function Panel_Window_InstallationMode_Farm_info:registEventHandler()
end
function Panel_Window_InstallationMode_Farm_info:registerMessageHandler()
  registerEvent("EventHousingShowInstallationMenu", "FromClient_ShowInstallationMenu_Farm_Renew")
  registerEvent("EventHousingUpdateInstallationInven", "FromClient_InstallationMode_UpdateInventory_Farm_Renew")
  registerEvent("EventUpdateInstallationActor", "FromClient_InstallationMode_UpdateInstallationActor_Farm_Renew")
  registerEvent("onScreenResize", "FromClient_InstallationMode_Resize_Farm_Renew")
  registerEvent("FromClient_ChangeHousingInstallMode", "FromClient_ChangeHousingInstallMode_Farm_Renew")
  registerEvent("FromClient_changePadCameraControlMode", "FromClient_changePadCameraControlMode_Farm_Renew")
  Panel_House_InstallationMode_Farm:RegisterUpdateFunc("PaGlobalFunc_InstallationMode_Farm_UpdatePerFrame")
end
function Panel_Window_InstallationMode_Farm_info:initialize()
  self:childControl()
  self:initValue()
  self:initString()
  self:resize()
  self:createItemSlot()
  self:createGuideAndSetData()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Window_InstallationMode_Farm_info:initString()
  self._panelKeyGuideString[0] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORLDMAP_GUILDHOUSE_CHANGEWORKER_SELECTBTN")
  self._panelKeyGuideString[1] = PAGetString(Defines.StringSheet_GAME, "LUA_CAMP_REMOTERESET_TITLE") .. "/" .. PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GENERIC_KEYGUIDE_XBOX_REMOVE")
  self._menu_Top_String[0] = PAGetString(Defines.StringSheet_RESOURCE, "HOUSING_BTN_SEARCH_ALL")
  self._menu_Top_String[1] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTALLATIONMODE_FARMINFO_CROP_BTN")
  self._menu_Top_String[2] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTALLATIONMODE_FARMINFO_DOMESTICANIMAL_BTN")
  self._keyGuideString.build = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTALLMODE_KEYGUIDE_BUILD")
  self._keyGuideString.install = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTALLMODE_KEYGUIDE_INSTALL")
end
function Panel_Window_InstallationMode_Farm_info:initValue()
  self:initTabValue()
  self:initItemValue()
  self._screenGapSize.x = (getOriginScreenSizeX() - getScreenSizeX()) / 2
  self._screenGapSize.y = (getOriginScreenSizeY() - getScreenSizeY()) / 2
end
function Panel_Window_InstallationMode_Farm_info:initTabValue()
  self._value.currentTabIndex = self._menu_Top_Enum.Base
end
function Panel_Window_InstallationMode_Farm_info:initItemValue()
  self._value.currentItemIndex = 0
  self._value.startItemIndex = 0
  self._value.lastStartItemIndex = -1
  self._value.itemDataCount = 0
  self._value.focusIndex = 0
end
function Panel_Window_InstallationMode_Farm_info:resize()
  local sizeX = getScreenSizeX()
  local sizeY = getScreenSizeY()
  Panel_House_InstallationMode_Farm:SetSize(sizeX, sizeY)
  Panel_House_InstallationMode_Farm:SetPosXY(0, 0)
  self._ui.static_Farm_InstallationMode_Right:ComputePos()
  self._ui.static_Farm_InstallationMode_Right:SetSize(self._ui.static_Farm_InstallationMode_Right:GetSizeX(), sizeY)
  self._screenGapSize.x = (getOriginScreenSizeX() - getScreenSizeX()) / 2
  self._screenGapSize.y = (getOriginScreenSizeY() - getScreenSizeY()) / 2
end
function Panel_Window_InstallationMode_Farm_info:childControl()
  self._ui.static_Farm_InstallationMode_Right = UI.getChildControl(Panel_House_InstallationMode_Farm, "Static_Farm_InstallationMode_Right")
  self._ui.static_TitleBg = UI.getChildControl(self._ui.static_Farm_InstallationMode_Right, "Static_TitleBg")
  self._ui.staticText_Title_Top = UI.getChildControl(self._ui.static_TitleBg, "StaticText_Title_Top")
  self._ui.static_TabMenuBG = UI.getChildControl(self._ui.static_Farm_InstallationMode_Right, "Static_TabMenuBG")
  self._ui.radioButton_Main = UI.getChildControl(self._ui.static_TabMenuBG, "RadioButton_Main")
  self._ui.radioButton_Plantation = UI.getChildControl(self._ui.static_TabMenuBG, "RadioButton_Plantation")
  self._ui.radioButton_Animal = UI.getChildControl(self._ui.static_TabMenuBG, "RadioButton_Animal")
  self._ui.staticText_ToolTip = UI.getChildControl(self._ui.static_TabMenuBG, "StaticText_ToolTip")
  self._tabSlot[self._menu_Top_Enum.Base] = self._ui.radioButton_Main
  self._tabSlot[self._menu_Top_Enum.PlantGuide] = self._ui.radioButton_Plantation
  self._tabSlot[self._menu_Top_Enum.AnimalGuide] = self._ui.radioButton_Animal
  self._tabSlot[self._menu_Top_Enum.PlantGuide]:SetShow(false)
  self._tabSlot[self._menu_Top_Enum.AnimalGuide]:SetShow(false)
  self._ui.static_Faming_MainBG = UI.getChildControl(self._ui.static_Farm_InstallationMode_Right, "Static_Faming_MainBG")
  self._ui.static_Faming_Info = UI.getChildControl(self._ui.static_Faming_MainBG, "Static_Faming_Info")
  self._ui.staticText_GardenUsedPoint = UI.getChildControl(self._ui.static_Faming_Info, "StaticText_GardenUsedPoint")
  self._ui.staticText_TempeaturePoint = UI.getChildControl(self._ui.static_Faming_Info, "StaticText_TempeaturePoint")
  self._ui.progress2_TempeatureBar = UI.getChildControl(self._ui.static_Faming_Info, "Progress2_TempeatureBar")
  self._ui.staticText_HumidityPoint = UI.getChildControl(self._ui.static_Faming_Info, "StaticText_HumidityPoint")
  self._ui.progress2_HumidityBar = UI.getChildControl(self._ui.static_Faming_Info, "Progress2_HumidityBar")
  self._ui.staticText_UndergroundWaterPoint = UI.getChildControl(self._ui.static_Faming_Info, "StaticText_UndergroundWaterPoint")
  self._ui.progress2_UndergroundWaterBar = UI.getChildControl(self._ui.static_Faming_Info, "Progress2_UndergroundWaterBar")
  self._ui.staticText_ManurePoint = UI.getChildControl(self._ui.static_Faming_Info, "StaticText_ManurePoint")
  self._ui.progress2_ManureBar = UI.getChildControl(self._ui.static_Faming_Info, "Progress2_ManureBar")
  self._ui.static_Icon_WaterWay = UI.getChildControl(self._ui.static_Faming_Info, "Static_Icon_WaterWay")
  self._ui.staticText_WaterwayTitle = UI.getChildControl(self._ui.static_Faming_Info, "StaticText_WaterwayTitle")
  self._ui.staticText_WaterwayDec = UI.getChildControl(self._ui.static_Faming_Info, "StaticText_WaterwayDec")
  self._ui.staticText_WaterwayDec:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.static_Icon_Scarecrow = UI.getChildControl(self._ui.static_Faming_Info, "Static_Icon_Scarecrow")
  self._ui.staticText_ScarecrowTitle = UI.getChildControl(self._ui.static_Faming_Info, "StaticText_ScarecrowTitle")
  self._ui.staticText_ScarecrowDec = UI.getChildControl(self._ui.static_Faming_Info, "StaticText_ScarecrowDec")
  self._ui.staticText_ScarecrowDec:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.static_PlantListBG = UI.getChildControl(self._ui.static_Faming_MainBG, "Static_PlantListBG")
  self._ui.static_PlantItemTemplete = UI.getChildControl(self._ui.static_PlantListBG, "Static_PlantItemTemplete")
  self._ui.static_Item_Focus = UI.getChildControl(self._ui.static_PlantListBG, "Static_Item_Focus")
  self._ui.scroll_Plant = UI.getChildControl(self._ui.static_PlantListBG, "Scroll_Plant")
  self._pos.itemSlotStartX = self._ui.static_PlantItemTemplete:GetPosX()
  self._pos.itemSlotStartY = self._ui.static_PlantItemTemplete:GetPosY()
  self._pos.itemSlotSizeX = self._ui.static_PlantItemTemplete:GetSizeX()
  self._pos.itemSlotSizeY = self._ui.static_PlantItemTemplete:GetSizeY()
  UIScroll.InputEvent(self._ui.scroll_Plant, "PaGlobalFunc_InstallationMode_Farm_ScrollItem")
  self._ui.frame_1_PlantInfoList = UI.getChildControl(self._ui.static_Farm_InstallationMode_Right, "Frame_1_PlantInfoList")
  self._ui.frame_1_Content = UI.getChildControl(self._ui.frame_1_PlantInfoList, "Frame_1_Content")
  self._ui.staticText_MainTitleTemplete1 = UI.getChildControl(self._ui.frame_1_Content, "StaticText_MainTitleTemplete1")
  self._ui.staticText_SubTitleTemplete1 = UI.getChildControl(self._ui.frame_1_Content, "StaticText_SubTitleTemplete1")
  self._ui.staticText_DecTemplete1 = UI.getChildControl(self._ui.frame_1_Content, "StaticText_DecTemplete1")
  self._pos.startPosY = self._ui.staticText_MainTitleTemplete1:GetPosY()
  self._ui.staticText_MainTitleTemplete1:SetShow(false)
  self._ui.staticText_SubTitleTemplete1:SetShow(false)
  self._ui.staticText_DecTemplete1:SetShow(false)
  self._ui.frame_2_AnimalInfoList = UI.getChildControl(self._ui.static_Farm_InstallationMode_Right, "Frame_2_AnimalInfoList")
  self._ui.frame_2_Content = UI.getChildControl(self._ui.frame_2_AnimalInfoList, "Frame_2_Content")
  self._ui.staticText_MainTitleTemplete2 = UI.getChildControl(self._ui.frame_2_Content, "StaticText_MainTitleTemplete2")
  self._ui.staticText_SubTitleTemplete2 = UI.getChildControl(self._ui.frame_2_Content, "StaticText_SubTitleTemplete2")
  self._ui.staticText_DecTemplete2 = UI.getChildControl(self._ui.frame_2_Content, "StaticText_DecTemplete2")
  self._ui.staticText_MainTitleTemplete2:SetShow(false)
  self._ui.staticText_SubTitleTemplete2:SetShow(false)
  self._ui.staticText_DecTemplete2:SetShow(false)
  self._tabPage[self._menu_Top_Enum.Base] = self._ui.static_Faming_MainBG
  self._tabPage[self._menu_Top_Enum.PlantGuide] = self._ui.frame_1_PlantInfoList
  self._tabPage[self._menu_Top_Enum.AnimalGuide] = self._ui.frame_2_AnimalInfoList
  self._ui.static_BottomBg = UI.getChildControl(self._ui.static_Farm_InstallationMode_Right, "Static_BottomBg")
  self._ui.staticText_A_Select_ConsoleUI = UI.getChildControl(self._ui.static_BottomBg, "StaticText_A_Select_ConsoleUI")
  self._ui.staticText_B_Close_ConsoleUI = UI.getChildControl(self._ui.static_BottomBg, "StaticText_B_Close_ConsoleUI")
  self._keyGuideBottom = {
    self._ui.staticText_A_Select_ConsoleUI,
    self._ui.staticText_B_Close_ConsoleUI
  }
  self._ui.static_KeyGuide_ConsoleBG = UI.getChildControl(self._ui.static_Farm_InstallationMode_Right, "Static_KeyGuide_ConsoleBG")
  self._ui.staticText_RS_Click_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_RS_Click_ConsoleUI")
  self._ui.staticText_RS_UpDown_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_RS_UpDown_ConsoleUI")
  self._ui.staticText_RS_LeftRight_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_RS_LeftRight_ConsoleUI")
  self._ui.staticText_LS_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_LS_ConsoleUI")
  self._ui.staticText_RS_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_RS_ConsoleUI")
  self._ui.staticText_LB_RB_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_LB_RB_ConsoleUI")
  self._ui.staticText_LT_RT_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_LT_RT_ConsoleUI")
  self._ui.staticText_Y_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_Y_ConsoleUI")
  self._ui.staticText_X_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_X_ConsoleUI")
  self._ui.staticText_A_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_A_ConsoleUI")
  self._ui.staticText_B_ConsoleUI = UI.getChildControl(self._ui.static_KeyGuide_ConsoleBG, "StaticText_B_ConsoleUI")
  self._keyGuide = {
    self._ui.staticText_RS_Click_ConsoleUI,
    self._ui.staticText_RS_UpDown_ConsoleUI,
    self._ui.staticText_RS_LeftRight_ConsoleUI,
    self._ui.staticText_LS_ConsoleUI,
    self._ui.staticText_RS_ConsoleUI,
    self._ui.staticText_LB_RB_ConsoleUI,
    self._ui.staticText_LT_RT_ConsoleUI,
    self._ui.staticText_Y_ConsoleUI,
    self._ui.staticText_X_ConsoleUI,
    self._ui.staticText_A_ConsoleUI,
    self._ui.staticText_B_ConsoleUI
  }
  self._ui.static_Move = UI.getChildControl(Panel_House_InstallationMode_Farm, "Static_Move")
end
function Panel_Window_InstallationMode_Farm_info:createGuideAndSetData()
  local calculateIndex = 0
  for index = 0, self._config.guidTitleCount - 1 do
    local titlePlant = UI.createAndCopyBasePropertyControl(self._ui.frame_1_Content, "StaticText_MainTitleTemplete1", self._ui.frame_1_Content, "StaticText_MainTitleTemplete1_" .. index)
    local titleAnimal = UI.createAndCopyBasePropertyControl(self._ui.frame_2_Content, "StaticText_MainTitleTemplete2", self._ui.frame_2_Content, "StaticText_MainTitleTemplete2_" .. index)
    self._plantTitle[index] = titlePlant
    self._animalTitle[index] = titleAnimal
    self._plantTitle[index]:SetAutoResize(true)
    self._plantTitle[index]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._animalTitle[index]:SetAutoResize(true)
    self._animalTitle[index]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    self._plantTitle[index]:SetText(mainTitle[index])
    self._animalTitle[index]:SetText(mainTitle[index])
    for index2 = 0, self._config.guideCount[index] - 1 do
      local subTitlePlant = UI.createAndCopyBasePropertyControl(self._ui.frame_1_Content, "StaticText_SubTitleTemplete1", self._ui.frame_1_Content, "StaticText_SubTitleTemplete1_" .. calculateIndex + index2)
      local subTtitleAnimal = UI.createAndCopyBasePropertyControl(self._ui.frame_2_Content, "StaticText_SubTitleTemplete2", self._ui.frame_2_Content, "StaticText_SubTitleTemplete2_" .. calculateIndex + index2)
      self._plantSubTitle[calculateIndex + index2] = subTitlePlant
      self._animalSubTitle[calculateIndex + index2] = subTtitleAnimal
      self._plantSubTitle[calculateIndex + index2]:SetAutoResize(true)
      self._plantSubTitle[calculateIndex + index2]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      self._animalSubTitle[calculateIndex + index2]:SetAutoResize(true)
      self._animalSubTitle[calculateIndex + index2]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      self._plantSubTitle[calculateIndex + index2]:SetText(farmGuideTitle[index][index2])
      self._animalSubTitle[calculateIndex + index2]:SetText(animalGuideTitle[index][index2])
      local descPlant = UI.createAndCopyBasePropertyControl(self._ui.frame_1_Content, "StaticText_DecTemplete1", self._ui.frame_1_Content, "StaticText_DecTemplete1_" .. calculateIndex + index2)
      local descAnimal = UI.createAndCopyBasePropertyControl(self._ui.frame_2_Content, "StaticText_DecTemplete2", self._ui.frame_2_Content, "StaticText_DecTemplete2_" .. calculateIndex + index2)
      self._plantDesc[calculateIndex + index2] = descPlant
      self._animalDesc[calculateIndex + index2] = descAnimal
      self._plantDesc[calculateIndex + index2]:SetAutoResize(true)
      self._plantDesc[calculateIndex + index2]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      self._animalDesc[calculateIndex + index2]:SetAutoResize(true)
      self._animalDesc[calculateIndex + index2]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
      self._plantDesc[calculateIndex + index2]:SetText(farmGuideDesc[index][index2])
      self._animalDesc[calculateIndex + index2]:SetText(animalGuideDesc[index][index2])
    end
    calculateIndex = calculateIndex + self._config.guideCount[index]
  end
  self:setPosGuideDesc()
end
function Panel_Window_InstallationMode_Farm_info:setPosGuideDesc()
  local plantPosY = self._pos.startPosY
  local animalPosY = self._pos.startPosY
  local calculateIndex = 0
  for index = 0, self._config.guidTitleCount - 1 do
    self._plantTitle[index]:SetPosY(plantPosY)
    plantPosY = plantPosY + self._pos.textSpace + self._plantTitle[index]:GetSizeY()
    self._animalTitle[index]:SetPosY(animalPosY)
    animalPosY = animalPosY + self._pos.textSpace + self._animalTitle[index]:GetSizeY()
    for index2 = 0, self._config.guideCount[index] - 1 do
      self._plantSubTitle[calculateIndex + index2]:SetPosY(plantPosY)
      plantPosY = plantPosY + self._pos.textSpace + self._plantSubTitle[calculateIndex + index2]:GetSizeY()
      self._plantDesc[calculateIndex + index2]:SetPosY(plantPosY)
      plantPosY = plantPosY + self._pos.textSpace + self._plantDesc[calculateIndex + index2]:GetSizeY()
      self._animalSubTitle[calculateIndex + index2]:SetPosY(animalPosY)
      animalPosY = animalPosY + self._pos.textSpace + self._animalSubTitle[calculateIndex + index2]:GetSizeY()
      self._animalDesc[calculateIndex + index2]:SetPosY(animalPosY)
      animalPosY = animalPosY + self._pos.textSpace + self._animalDesc[calculateIndex + index2]:GetSizeY()
    end
    calculateIndex = calculateIndex + self._config.guideCount[index]
    plantPosY = plantPosY + self._pos.titleSpace
    animalPosY = animalPosY + self._pos.titleSpace
  end
  self._ui.frame_1_Content:SetSize(self._ui.frame_1_Content:GetSizeX(), plantPosY)
  self._ui.frame_2_Content:SetSize(self._ui.frame_2_Content:GetSizeX(), animalPosY)
end
function Panel_Window_InstallationMode_Farm_info:createItemSlot()
  for index = 0, self._config.itemMaxIndex - 1 do
    local slotBG = {}
    slotBG.bg = UI.createAndCopyBasePropertyControl(self._ui.static_PlantListBG, "Static_PlantItemTemplete", self._ui.static_PlantListBG, "Static_PlantItemTemplete_" .. index)
    slotBG.check = UI.createAndCopyBasePropertyControl(self._ui.static_PlantItemTemplete, "Static_CheckMarkTemplete", slotBG.bg, "Static_CheckMarkTemplete_" .. index)
    local row = math.floor(index / self._config.itemSlotCol)
    local col = index % self._config.itemSlotCol
    slotBG.bg:SetShow(true)
    slotBG.bg:SetPosX(self._pos.itemSlotStartX + (self._pos.itemSlotSizeX + self._pos.itemSlotSpace) * col)
    slotBG.bg:SetPosY(self._pos.itemSlotStartY + (self._pos.itemSlotSizeY + self._pos.itemSlotSpace) * row)
    if 0 == row then
      slotBG.bg:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "PaGlobalFunc_InstallationMode_Farm_ScrollItem(true)")
    end
    if self._config.itemSlotRow - 1 == row then
      slotBG.bg:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "PaGlobalFunc_InstallationMode_Farm_ScrollItem(false)")
    end
    local slot = {}
    SlotItem.new(slot, "Static_Item_" .. index, index, slotBG.bg, self._slotConfig)
    slot:createChild()
    slot.icon:SetPosX(slot.icon:GetPosX() + 2)
    slot.icon:SetPosY(slot.icon:GetPosY() + 2)
    slotBG.bg:SetChildOrder(slot.icon:GetKey(), slotBG.check:GetKey())
    slotBG.bg:SetChildOrder(slot.icon:GetKey(), self._ui.static_Item_Focus:GetKey())
    self._ui.static_PlantListBG:SetChildOrder(slotBG.bg:GetKey(), self._ui.static_Item_Focus:GetKey())
    self._itemSlotBG[index] = slotBG
    self._itemSlot[index] = slot
    self._itemSlotBG[index].bg:addInputEvent("Mouse_On", "PaGlobalFunc_InstallationMode_Farm_FocusSlot(true,false," .. index .. ")")
    self._itemSlotBG[index].bg:addInputEvent("Mouse_Out", "PaGlobalFunc_InstallationMode_Farm_FocusSlot(false,false," .. index .. ")")
  end
end
function Panel_Window_InstallationMode_Farm_info:clearTab()
  self._tabSlot[self._menu_Top_Enum.Base]:SetCheck(false)
  self._tabSlot[self._menu_Top_Enum.PlantGuide]:SetCheck(false)
  self._tabSlot[self._menu_Top_Enum.AnimalGuide]:SetCheck(false)
end
function Panel_Window_InstallationMode_Farm_info:setTab()
  self:clearTab()
  self._tabPage[self._menu_Top_Enum.Base]:SetShow(false)
  self._tabPage[self._menu_Top_Enum.PlantGuide]:SetShow(false)
  self._tabPage[self._menu_Top_Enum.AnimalGuide]:SetShow(false)
  self._ui.staticText_ToolTip:SetPosX(self._tabSlot[self._value.currentTabIndex]:GetPosX() - 22)
  self._ui.staticText_ToolTip:SetText(self._menu_Top_String[self._value.currentTabIndex])
  self._tabSlot[self._value.currentTabIndex]:SetCheck(true)
  self._tabPage[self._value.currentTabIndex]:SetShow(true)
  self._tabPage[self._menu_Top_Enum.PlantGuide] = self._ui.frame_1_PlantInfoList
  self._tabPage[self._menu_Top_Enum.AnimalGuide] = self._ui.frame_2_AnimalInfoList
  ToClient_Housing_List_ClearFilter()
  if self._menu_Top_Enum.Base == self._value.currentTabIndex then
    self:initItemValue()
    self:updateItemContent(true)
    self._tabSlot[self._menu_Top_Enum.Base]:SetCheck(true)
    self._tabSlot[self._menu_Top_Enum.PlantGuide]:SetCheck(false)
    self._tabSlot[self._menu_Top_Enum.AnimalGuide]:SetCheck(false)
  elseif self._menu_Top_Enum.PlantGuide == self._value.currentTabIndex then
    self._tabSlot[self._menu_Top_Enum.Base]:SetCheck(false)
    self._tabSlot[self._menu_Top_Enum.PlantGuide]:SetCheck(true)
    self._tabSlot[self._menu_Top_Enum.AnimalGuide]:SetCheck(false)
  elseif self._menu_Top_Enum.AnimalGuide == self._value.currentTabIndex then
    self._tabSlot[self._menu_Top_Enum.Base]:SetCheck(false)
    self._tabSlot[self._menu_Top_Enum.PlantGuide]:SetCheck(false)
    self._tabSlot[self._menu_Top_Enum.AnimalGuide]:SetCheck(true)
  end
end
function Panel_Window_InstallationMode_Farm_info:setKeyPosX(parantControl, keyList)
  local space = 44
  local maxLength = 0
  for key, value in ipairs(keyList) do
    if true == value:GetShow() then
      local spaceFromRight = value:GetTextSizeX() + space
      maxLength = math.max(maxLength, spaceFromRight)
    end
  end
  local parantControlSizeX = parantControl:GetSizeX()
  for key, value in ipairs(keyList) do
    if true == value:GetShow() then
      value:SetPosX(parantControlSizeX - maxLength)
    end
  end
end
function Panel_Window_InstallationMode_Farm_info:setKeyGuide(modeType, isShowMove, isShowFix, isShowDelete, isShowCancel)
  for key, value in pairs(self._keyGuide) do
    value:SetShow(false)
  end
  local isRotatePossible = housing_isAvailableRotateSelectedObject()
  local characterStaticWrapper = housing_getCreatedCharacterStaticWrapper()
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  local isFixed, installationType, isPersonalTent
  if nil ~= houseWrapper then
    isFixed = houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isFixedHouse() or houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isInnRoom()
  end
  if nil ~= characterStaticWrapper then
    installationType = characterStaticWrapper:getObjectStaticStatus():getInstallationType()
    local objectStaticWrapper = characterStaticWrapper:getObjectStaticStatus()
    isPersonalTent = objectStaticWrapper:isPersonalTent()
  end
  if self._mode_Type_Enum.InstallMode_None == self._value.currentMode then
    local keyList = {
      self._ui.staticText_RS_Click_ConsoleUI,
      self._ui.staticText_RS_UpDown_ConsoleUI,
      self._ui.staticText_RS_ConsoleUI,
      self._ui.staticText_RS_LeftRight_ConsoleUI
    }
    self._ui.staticText_RS_Click_ConsoleUI:SetShow(true)
    if false == ToClient_isCameraControlModeForConsole() then
      self._ui.staticText_RS_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(false)
    else
      self._ui.staticText_RS_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(true)
    end
    self:setKeyPosX(self._ui.static_KeyGuide_ConsoleBG, keyList)
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyList, self._ui.static_KeyGuide_ConsoleBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_BOTTOM, nil, 10)
  elseif self._mode_Type_Enum.InstallMode_Translation == self._value.currentMode then
    local keyList = {
      self._ui.staticText_RS_Click_ConsoleUI,
      self._ui.staticText_RS_UpDown_ConsoleUI,
      self._ui.staticText_RS_LeftRight_ConsoleUI,
      self._ui.staticText_RS_ConsoleUI,
      self._ui.staticText_LS_ConsoleUI,
      self._ui.staticText_LB_RB_ConsoleUI,
      self._ui.staticText_LT_RT_ConsoleUI,
      self._ui.staticText_A_ConsoleUI,
      self._ui.staticText_B_ConsoleUI
    }
    self._ui.staticText_RS_Click_ConsoleUI:SetShow(true)
    if false == ToClient_isCameraControlModeForConsole() then
      self._ui.staticText_RS_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(false)
    else
      self._ui.staticText_RS_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(true)
    end
    if true == isFixed then
      self._ui.staticText_LS_ConsoleUI:SetShow(true)
    end
    if true == isRotatePossible then
      self._ui.staticText_LB_RB_ConsoleUI:SetShow(true)
      self._ui.staticText_LT_RT_ConsoleUI:SetShow(true)
    end
    self._ui.staticText_A_ConsoleUI:SetText(self._keyGuideString.build)
    self._ui.staticText_A_ConsoleUI:SetShow(true)
    Panel_House_InstallationMode:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_InstallationMode_House_ClickConfirm()")
    self._ui.staticText_B_ConsoleUI:SetShow(true)
    self:setKeyPosX(self._ui.static_KeyGuide_ConsoleBG, keyList)
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyList, self._ui.static_KeyGuide_ConsoleBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_BOTTOM, 44, 10)
  elseif self._mode_Type_Enum.InstallMode_Detail == self._value.currentMode then
    local keyList = {
      self._ui.staticText_RS_Click_ConsoleUI,
      self._ui.staticText_RS_UpDown_ConsoleUI,
      self._ui.staticText_RS_ConsoleUI,
      self._ui.staticText_RS_LeftRight_ConsoleUI,
      self._ui.staticText_LS_ConsoleUI,
      self._ui.staticText_LB_RB_ConsoleUI,
      self._ui.staticText_LT_RT_ConsoleUI,
      self._ui.staticText_A_ConsoleUI,
      self._ui.staticText_B_ConsoleUI
    }
    self._ui.staticText_RS_Click_ConsoleUI:SetShow(true)
    if false == ToClient_isCameraControlModeForConsole() then
      self._ui.staticText_RS_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(false)
    else
      self._ui.staticText_RS_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(true)
    end
    if true == isRotatePossible then
      self._ui.staticText_LB_RB_ConsoleUI:SetShow(true)
      self._ui.staticText_LT_RT_ConsoleUI:SetShow(true)
    else
      self._ui.staticText_LB_RB_ConsoleUI:SetShow(false)
      self._ui.staticText_LT_RT_ConsoleUI:SetShow(false)
    end
    self._ui.staticText_A_ConsoleUI:SetText(self._keyGuideString.build)
    self._ui.staticText_A_ConsoleUI:SetShow(true)
    Panel_House_InstallationMode:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_InstallationMode_House_ClickConfirm()")
    self._ui.staticText_B_ConsoleUI:SetShow(true)
    self:setKeyPosX(self._ui.static_KeyGuide_ConsoleBG, keyList)
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyList, self._ui.static_KeyGuide_ConsoleBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_BOTTOM, nil, 10)
  elseif self._mode_Type_Enum.InstallMode_WatingConfirm == self._value.currentMode then
    local keyList = {
      self._ui.staticText_RS_Click_ConsoleUI,
      self._ui.staticText_RS_UpDown_ConsoleUI,
      self._ui.staticText_RS_LeftRight_ConsoleUI,
      self._ui.staticText_RS_ConsoleUI,
      self._ui.staticText_LB_RB_ConsoleUI,
      self._ui.staticText_LT_RT_ConsoleUI,
      self._ui.staticText_A_ConsoleUI,
      self._ui.staticText_Y_ConsoleUI,
      self._ui.staticText_X_ConsoleUI,
      self._ui.staticText_B_ConsoleUI
    }
    self._ui.staticText_RS_Click_ConsoleUI:SetShow(true)
    if false == ToClient_isCameraControlModeForConsole() then
      self._ui.staticText_RS_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(false)
    else
      self._ui.staticText_RS_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(true)
    end
    if true == isRotatePossible then
      self._ui.staticText_LB_RB_ConsoleUI:SetShow(true)
      self._ui.staticText_LT_RT_ConsoleUI:SetShow(true)
    end
    self._ui.staticText_A_ConsoleUI:SetText(self._keyGuideString.install)
    self._ui.staticText_A_ConsoleUI:SetShow(true)
    if true == self._value.isCanDelete then
      self._ui.staticText_X_ConsoleUI:SetShow(true)
    end
    if true == self._value.isCanMove then
      self._ui.staticText_Y_ConsoleUI:SetShow(true)
    end
    self._ui.staticText_B_ConsoleUI:SetShow(true)
    self:setKeyPosX(self._ui.static_KeyGuide_ConsoleBG, keyList)
    PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyList, self._ui.static_KeyGuide_ConsoleBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_BOTTOM, nil, 10)
  end
end
function Panel_Window_InstallationMode_Farm_info:setItemData(initflag)
  ToClient_Furniture_Setdata(initflag)
  self._value.itemDataCount = ToClient_GetFurnitureListSize()
end
function Panel_Window_InstallationMode_Farm_info:updateItemScroll(isUpScroll)
  local beforeSlotIndex = self._value.startItemIndex
  self._value.startItemIndex = UIScroll.ScrollEvent(self._ui.scroll_Plant, isUpScroll, self._config.itemSlotRow, self._value.itemDataCount, self._value.startItemIndex, self._config.itemSlotCol)
  self._value.lastStartItemIndex = beforeSlotIndex
  if (ToClient_isConsole() or ToClient_IsDevelopment()) and beforeSlotIndex ~= self._value.startItemIndex then
    ToClient_padSnapIgnoreGroupMove()
  end
  self:setItemSlot()
end
function Panel_Window_InstallationMode_Farm_info:setItemScroll()
  UIScroll.SetButtonSize(self._ui.scroll_Plant, self._config.itemMaxIndex, self._value.itemDataCount)
  self._ui.scroll_Plant:SetControlPos(0)
  if self._value.itemDataCount == self._value.startItemIndex + self._config.itemSlotRow then
    self._ui.scroll_Plant:SetControlBottom()
  end
end
function Panel_Window_InstallationMode_Farm_info:setItemSlot()
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  if nil == houseWrapper then
    _PA_ASSERT(false, "housing_getHouseholdActor_CurrentPosition()\234\176\128 nullptr \236\157\180\235\169\180 \236\149\136\235\144\169\235\139\136\235\139\164.")
    return
  end
  local css = houseWrapper:getStaticStatusWrapper():get()
  self._ui.staticText_GardenUsedPoint:SetText(houseWrapper:getInstallationCountSum() .. "/" .. css:getInstallationMaxCount())
  if self._value.itemDataCount <= 0 then
    for index = 0, self._config.itemMaxIndex - 1 do
      self._itemSlot[index].icon:addInputEvent("Mouse_On", "")
      self._itemSlot[index].icon:addInputEvent("Mouse_Out", "")
      self._itemSlot[index].icon:addInputEvent("Mouse_LUp", "")
      self._itemSlot[index]:clearItem()
      self._itemSlotBG[index].bg:SetShow(true)
      self._itemSlot[index].isCash:SetShow(false)
      self._itemSlotBG[index].check:SetShow(false)
    end
  end
  if self._config.itemMaxIndex - 1 < self._value.itemDataCount then
    self._ui.scroll_Plant:SetShow(true)
  else
    self._ui.scroll_Plant:SetShow(false)
  end
  for index = 0, self._config.itemMaxIndex - 1 do
    local slotIndex = self._value.startItemIndex + index
    local Data = ToClient_GetFurniture(slotIndex)
    if nil ~= Data then
      self._itemSlotBG[index].bg:SetShow(true)
      if true == Data._isInstalled then
        if index == self._value.focusIndex then
          PaGlobalFunc_InstallationMode_Farm_showInstalledItemToolTip(true, Data._invenSlotNo, index)
        end
        self._itemSlot[index].icon:addInputEvent("Mouse_On", "PaGlobalFunc_InstallationMode_Farm_showInstalledItemToolTip(true, " .. Data._invenSlotNo .. ", " .. index .. " )")
        self._itemSlot[index].icon:addInputEvent("Mouse_LUp", "PaGlobalFunc_InstallationMode_Farm_DeleteInstalledObject( " .. Data._invenSlotNo .. " )")
        self._itemSlot[index].isCash:SetShow(false)
        self._itemSlotBG[index].bg:registerPadEvent(__eConsoleUIPadEvent_X, "PaGlobalFunc_InstallationMode_Farm_showInstalledItemToolTip(false, " .. Data._invenSlotNo .. ", " .. index .. " )")
        self._itemSlotBG[index].check:SetShow(true)
      elseif not Data._isCashProduct then
        if index == self._value.focusIndex then
          PaGlobalFunc_InstallationMode_Farm_showToolTip(true, Data._invenType, Data._invenSlotNo, index)
        end
        self._itemSlot[index].icon:addInputEvent("Mouse_On", "PaGlobalFunc_InstallationMode_Farm_showToolTip(true, " .. Data._invenType .. ", " .. Data._invenSlotNo .. ", " .. index .. ")")
        self._itemSlot[index].icon:addInputEvent("Mouse_LUp", "PaGlobalFunc_InstallationMode_Farm_installFurniture( " .. Data._invenType .. ", " .. Data._invenSlotNo .. ", false, " .. 0 .. ")")
        self._itemSlot[index].isCash:SetShow(false)
        self._itemSlotBG[index].bg:registerPadEvent(__eConsoleUIPadEvent_X, "PaGlobalFunc_InstallationMode_Farm_showToolTip(false, " .. Data._invenType .. ", " .. Data._invenSlotNo .. ", " .. index .. ")")
        self._itemSlotBG[index].check:SetShow(false)
      else
        if index == self._value.focusIndex then
          PaGlobalFunc_InstallationMode_Farm_CashItemShowToolTip(true, Data._productNoRaw, index)
        end
        self._itemSlot[index].icon:addInputEvent("Mouse_On", "PaGlobalFunc_InstallationMode_Farm_CashItemShowToolTip(true, " .. Data._productNoRaw .. ", " .. index .. " )")
        self._itemSlot[index].icon:addInputEvent("Mouse_LUp", "PaGlobalFunc_InstallationMode_Farm_installFurniture( " .. Data._invenType .. ", " .. Data._invenSlotNo .. ", true, " .. Data._productNoRaw .. ")")
        self._itemSlot[index].isCash:SetShow(true)
        self._itemSlotBG[index].bg:registerPadEvent(__eConsoleUIPadEvent_X, "PaGlobalFunc_InstallationMode_Farm_CashItemShowToolTip(false, " .. Data._productNoRaw .. ", " .. index .. " )")
        self._itemSlotBG[index].check:SetShow(false)
      end
      self._itemSlot[index]:setItemByStaticStatus(Data:getItemStaticStatusWrapper(), 0)
      self._itemSlot[index].icon:SetAlpha(1)
      self._itemSlot[index].icon:SetShow(true)
      self._itemSlot[index].icon:addInputEvent("Mouse_Out", "PaGlobalFunc_InstallationMode_Farm_HideTooltip()")
    else
      self._itemSlot[index].icon:addInputEvent("Mouse_LUp", "")
      self._itemSlot[index].icon:addInputEvent("Mouse_Out", "PaGlobalFunc_InstallationMode_Farm_HideTooltip()")
      self._itemSlotBG[index].bg:registerPadEvent(__eConsoleUIPadEvent_X, "")
      self._itemSlotBG[index].check:SetShow(false)
    end
    if slotIndex >= self._value.itemDataCount then
      self._itemSlot[index].icon:addInputEvent("Mouse_LUp", "")
      self._itemSlot[index].icon:addInputEvent("Mouse_Out", "PaGlobalFunc_InstallationMode_Farm_HideTooltip()")
      self._itemSlot[index].icon:SetShow(false)
      self._itemSlotBG[index].bg:registerPadEvent(__eConsoleUIPadEvent_X, "")
    end
  end
end
function Panel_Window_InstallationMode_Farm_info:setFarmInfo()
  local ownerHouseHoldNo = housing_getInstallmodeHouseHoldNo()
  local temperature = housing_getInstallationMenuHarvestTempRate(ownerHouseHoldNo)
  self._ui.staticText_TempeaturePoint:SetText(string.format("%.2f%%", temperature))
  self._ui.progress2_TempeatureBar:SetProgressRate(temperature)
  local humidity = housing_getInstallationMenuHarvestHumidity(ownerHouseHoldNo)
  self._ui.staticText_HumidityPoint:SetText(string.format("%.2f%%", humidity))
  self._ui.progress2_HumidityBar:SetProgressRate(humidity)
  local groundWaterRate = housing_getInstallationMenuHarvestWaterRate(ownerHouseHoldNo)
  local farmWaterRate = housing_getGrowingRateValue(ownerHouseHoldNo, CppEnums.HarvestGrowRateKind.HarvestGrowRateKind_Water) / 10000
  local totalWaterRate = math.max(math.min(groundWaterRate + farmWaterRate, 100), 0)
  self._ui.staticText_UndergroundWaterPoint:SetText(string.format("%.2f%%", totalWaterRate))
  self._ui.progress2_UndergroundWaterBar:SetProgressRate(totalWaterRate)
  local manure = housing_getGrowingRateValue(ownerHouseHoldNo, CppEnums.HarvestGrowRateKind.HarvestGrowRateKind_Nutrient) / 10000
  self._ui.staticText_ManurePoint:SetText(string.format("%.2f%%", manure))
  self._ui.progress2_ManureBar:SetProgressRate(manure)
  local isInstalledWaterWay = housing_hasInstallationByType(ownerHouseHoldNo, CppEnums.InstallationType.eType_Waterway)
  if true == isInstalledWaterWay then
    self._ui.static_Icon_WaterWay:ChangeTextureInfoName(self._texture.path)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Icon_WaterWay, self._texture.existWater[1], self._texture.existWater[2], self._texture.existWater[3], self._texture.existWater[4])
    self._ui.static_Icon_WaterWay:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.static_Icon_WaterWay:setRenderTexture(self._ui.static_Icon_WaterWay:getBaseTexture())
    self._ui.staticText_WaterwayTitle:SetMonoTone(false)
    self._ui.staticText_WaterwayDec:SetMonoTone(false)
  else
    self._ui.static_Icon_WaterWay:ChangeTextureInfoName(self._texture.path)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Icon_WaterWay, self._texture.noneWater[1], self._texture.noneWater[2], self._texture.noneWater[3], self._texture.noneWater[4])
    self._ui.static_Icon_WaterWay:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.static_Icon_WaterWay:setRenderTexture(self._ui.static_Icon_WaterWay:getBaseTexture())
    self._ui.staticText_WaterwayTitle:SetMonoTone(true)
    self._ui.staticText_WaterwayDec:SetMonoTone(true)
  end
  local isInstalledScarecrow = housing_hasInstallationByType(ownerHouseHoldNo, CppEnums.InstallationType.eType_Scarecrow)
  if true == isInstalledScarecrow then
    self._ui.static_Icon_Scarecrow:ChangeTextureInfoName(self._texture.path)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Icon_Scarecrow, self._texture.existScarecrow[1], self._texture.existScarecrow[2], self._texture.existScarecrow[3], self._texture.existScarecrow[4])
    self._ui.static_Icon_Scarecrow:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.static_Icon_Scarecrow:setRenderTexture(self._ui.static_Icon_Scarecrow:getBaseTexture())
    self._ui.staticText_ScarecrowTitle:SetMonoTone(false)
    self._ui.staticText_ScarecrowDec:SetMonoTone(false)
  else
    self._ui.static_Icon_Scarecrow:ChangeTextureInfoName(self._texture.path)
    local x1, y1, x2, y2 = setTextureUV_Func(self._ui.static_Icon_Scarecrow, self._texture.noneScarecrow[1], self._texture.noneScarecrow[2], self._texture.noneScarecrow[3], self._texture.noneScarecrow[4])
    self._ui.static_Icon_Scarecrow:getBaseTexture():setUV(x1, y1, x2, y2)
    self._ui.static_Icon_Scarecrow:setRenderTexture(self._ui.static_Icon_Scarecrow:getBaseTexture())
    self._ui.staticText_ScarecrowTitle:SetMonoTone(true)
    self._ui.staticText_ScarecrowDec:SetMonoTone(true)
  end
end
function Panel_Window_InstallationMode_Farm_info:updateItemContent(initflag)
  self:setItemData(initflag)
  self:setItemScroll()
  self:setItemSlot()
  self:setFarmInfo()
end
function Panel_Window_InstallationMode_Farm_info:setKeyGuideBottom(stringNum)
  if nil == stringNum then
    self._ui.staticText_A_Select_ConsoleUI:SetShow(false)
  else
    self._ui.staticText_A_Select_ConsoleUI:SetShow(true)
    self._ui.staticText_A_Select_ConsoleUI:SetText(self._panelKeyGuideString[stringNum])
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideBottom, self._ui.static_Farm_InstallationMode_Right, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, nil, 20)
end
function Panel_Window_InstallationMode_Farm_info:readyToExit()
end
function Panel_Window_InstallationMode_Farm_info:open()
  Panel_House_InstallationMode_Farm:SetShow(true)
end
function Panel_Window_InstallationMode_Farm_info:close()
  Panel_House_InstallationMode_Farm:SetShow(false)
end
function Panel_Window_InstallationMode_Farm_info:focusItem(isOn, index)
  if nil == self._itemSlotBG[index].bg then
    return
  end
  local posX = self._itemSlotBG[index].bg:GetPosX()
  local posY = self._itemSlotBG[index].bg:GetPosY()
  if isOn then
    self._ui.static_Item_Focus:SetShow(true)
    self._ui.static_Item_Focus:SetPosXY(posX, posY)
  else
    self._ui.static_Item_Focus:SetShow(false)
  end
end
function PaGlobalFunc_InstallationMode_Farm_GetShow()
  return Panel_House_InstallationMode_Farm:GetShow()
end
function PaGlobalFunc_InstallationMode_Farm_Open()
  local self = Panel_Window_InstallationMode_Farm_info
  self:open()
end
function PaGlobalFunc_InstallationMode_Farm_Close()
  local self = Panel_Window_InstallationMode_Farm_info
  self:close()
end
function PaGlobalFunc_InstallationMode_Farm_Show()
  local self = Panel_Window_InstallationMode_Farm_info
  self:initValue()
  self:setTab()
  self:setKeyGuideBottom()
  self:setKeyGuide(self._mode_Type_Enum.InstallMode_None)
  self:updateItemContent(true)
  self:open()
end
function PaGlobalFunc_InstallationMode_Farm_Exit()
  local self = Panel_Window_InstallationMode_Farm_info
  self:readyToExit()
  self:close()
end
function PaGlobalFunc_InstallationMode_Farm_UpdatePerFrame(deltaTime)
  local self = Panel_Window_InstallationMode_Farm_info
  local x = ToClient_GetVirtualMousePosX()
  local y = ToClient_GetVirtualMousePosY()
  self._ui.static_Move:SetPosX(x - self._screenGapSize.x)
  self._ui.static_Move:SetPosY(y - self._screenGapSize.y)
  if self._mode_Type_Enum.InstallMode_None == self._value.currentMode then
    if true == self._ui.static_Move:GetShow() then
      self._ui.static_Move:SetShow(false)
    end
  elseif false == self._ui.static_Move:GetShow() then
    self._ui.static_Move:SetShow(true)
  else
    return
  end
end
function PaGlobalFunc_InstallationMode_Farm_UpdateItem()
  local self = Panel_Window_InstallationMode_Farm_info
  self:updateItemContent(false)
end
function PaGlobalFunc_InstallationMode_Farm_ToogleTab(value)
  local self = Panel_Window_InstallationMode_Farm_info
  local newTabIndex = self._value.currentTabIndex + self._menu_Top_Enum.Count + value
  newTabIndex = newTabIndex % self._menu_Top_Enum.Count
  self._value.currentTabIndex = newTabIndex
  self:setTab(newTabIndex)
  PaGlobalFunc_InstallationMode_Farm_HideTooltip()
end
function PaGlobalFunc_InstallationMode_Farm_showToolTip(showFlating, invenType, invenSlotNo, slot_Idx)
  local itemWrapper = getInventoryItemByType(invenType, invenSlotNo)
  local self = Panel_Window_InstallationMode_Farm_info
  local slot = self._itemSlot[slot_Idx]
  local slotBGControl = self._itemSlot[slot_Idx].icon
  if false == showFlating then
    PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemWrapper, itemWrapper, Defines.TooltipTargetType.ItemWithoutCompare, self._ui.static_Farm_InstallationMode_Right:GetPosX())
    PaGlobalFunc_FloatingTooltip_Close()
    return
  end
  PaGlobalFunc_FloatingTooltip_Open(Defines.TooltipDataType.ItemWrapper, itemWrapper, Defines.TooltipTargetType.Item, slotBGControl)
  self:setKeyGuideBottom(self._panelKeyGuideEnum.Select)
end
function PaGlobalFunc_InstallationMode_Farm_CashItemShowToolTip(showFlating, showFlating, productNoRaw, slot_Idx)
  local cPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(productNoRaw)
  local itemSSW = cPSSW:getItemByIndex(0)
  local self = Panel_Window_InstallationMode_Farm_info
  local slot = self._itemSlot[slot_Idx]
  local slotBGControl = self._itemSlot[slot_Idx].icon
  if nil == itemSSW then
    return
  end
  if false == showFlating then
    PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemSSWrapper, itemSSW, Defines.TooltipTargetType.ItemWithoutCompare, self._ui.static_Farm_InstallationMode_Right:GetPosX())
    PaGlobalFunc_FloatingTooltip_Close()
    return
  end
  PaGlobalFunc_FloatingTooltip_Open(Defines.TooltipDataType.ItemSSWrapper, itemSSW, Defines.TooltipTargetType.Item, slotBGControl)
  self:setKeyGuideBottom(self._panelKeyGuideEnum.Select)
end
function PaGlobalFunc_InstallationMode_Farm_showInstalledItemToolTip(showFlating, invenSlotNo, slot_Idx)
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  local itemSSW = houseWrapper:getCurrentItemEnchantStatStaticWrapper(invenSlotNo)
  if nil == itemSSW then
    return
  end
  local self = Panel_Window_InstallationMode_Farm_info
  local slot = self._itemSlot[slot_Idx]
  local slotBGControl = self._itemSlot[slot_Idx].icon
  if false == showFlating then
    PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemSSWrapper, itemSSW, Defines.TooltipTargetType.ItemWithoutCompare, self._ui.static_Farm_InstallationMode_Right:GetPosX())
    PaGlobalFunc_FloatingTooltip_Close()
    return
  end
  PaGlobalFunc_FloatingTooltip_Open(Defines.TooltipDataType.ItemSSWrapper, itemSSW, Defines.TooltipTargetType.Item, slotBGControl)
  self:setKeyGuideBottom(self._panelKeyGuideEnum.CollectDelete)
end
function PaGlobalFunc_InstallationMode_Farm_DeleteInstalledObject(idx)
  if Panel_Win_System:GetShow() then
    return
  end
  if housing_isTemporaryObject() or Is_Show_HouseInstallationControl() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_DELETEOBJECT_ACK"))
    return
  end
  local itemName = ""
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  local itemSSW = houseWrapper:getCurrentItemEnchantStatStaticWrapper(idx)
  local installationType
  if nil ~= itemSSW then
    installationType = itemSSW:getCharacterStaticStatus():getObjectStaticStatus():getInstallationType()
    itemName = itemSSW:getName()
  end
  local messageTitle = PAGetString(Defines.StringSheet_GAME, "LUA_MESSAGEBOX_NOTIFY")
  local messageContent = ""
  if UI_CIT.eType_LivestockHarvest == installationType or UI_CIT.eType_Havest == installationType then
    messageContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_CONFIRM_ITEMDELETE", "itemName", itemName)
  else
    messageContent = PAGetString(Defines.StringSheet_GAME, "INSTALLATION_DELETE_MESSAGEBOX_MEMO")
  end
  local function messageBox_HouseInstallation_Delete_InstalledObjectDo()
    _AudioPostEvent_SystemUiForXBOX(50, 1)
    housing_deleteObject_InstalledObjectList(idx)
  end
  local messageBoxData = {
    title = messageTitle,
    content = messageContent,
    functionYes = messageBox_HouseInstallation_Delete_InstalledObjectDo,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobalFunc_InstallationMode_Farm_ScrollItem(isUpScroll)
  local self = Panel_Window_InstallationMode_Farm_info
  _AudioPostEvent_SystemUiForXBOX(51, 4)
  self:updateItemScroll(isUpScroll)
end
function PaGlobalFunc_InstallationMode_Farm_ClickConfirm()
  local self = Panel_Window_InstallationMode_Farm_info
  if housing_isInstallMode() then
    local doit = function()
      housing_InstallObject()
      PaGlobalFunc_InstallationMode_Farm_UpdateItem()
      PaGlobalFunc_InstallationMode_PlantInfo_Exit()
      PaGlobalFunc_InstallationMode_Manager_InitInput()
    end
    local doCancel = function()
    end
    local installationType = UI_CIT.TypeCount
    local characterStaticWrapper = housing_getCreatedCharacterStaticWrapper()
    if nil ~= characterStaticWrapper then
      installationType = characterStaticWrapper:getObjectStaticStatus():getInstallationType()
      if installationType == UI_CIT.eType_WallPaper or installationType == UI_CIT.eType_FloorMaterial then
        local titleString = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_TITLE_WALLPAPERDONTCANCLE")
        local contentString = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSING_MEMO_WALLPAPERDONTCANCLE")
        local messageboxData = {
          title = titleString,
          content = contentString,
          functionYes = doit,
          functionCancel = doCancel,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData)
        return
      end
    end
    doit()
  else
    PaGlobalFunc_InstallationMode_Manager_Exit()
  end
end
function PaGlobalFunc_InstallationMode_Farm_ClickMove()
  housing_moveObject()
end
function PaGlobalFunc_InstallationMode_Farm_ClickDelete()
  housing_deleteObject()
end
function PaGlobalFunc_InstallationMode_Farm_ClickCancel()
  housing_CancelInstallObject()
end
function PaGlobalFunc_InstallationMode_Farm_FocusSlot(isOn, isWish, index)
  local self = Panel_Window_InstallationMode_Farm_info
  self:focusItem(isOn, index)
  self._value.focusIndex = index
  if nil ~= self._itemSlot[index] and nil ~= self._itemSlot[index].icon and false == self._itemSlot[index].icon:GetShow() then
    self._ui.staticText_A_Select_ConsoleUI:SetShow(false)
  end
end
function PaGlobalFunc_InstallationMode_Farm_installFurniture(invenType, invenSlotNo, iscash, productNo)
  PaGlobalFunc_InstallationMode_PlantInfo_Exit()
  if Panel_Win_System:GetShow() then
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  if false == iscash then
    housing_selectInstallationItem(invenType, invenSlotNo)
  else
    housing_selectInstallationItemForCashShop(productNo)
  end
end
function PaGlobalFunc_InstallationMode_Farm_HideTooltip()
  PaGlobalFunc_TooltipInfo_Close()
  PaGlobalFunc_FloatingTooltip_Close()
end
function FromClient_InstallationMode_Init()
  local self = Panel_Window_InstallationMode_Farm_info
  self:initialize()
end
function FromClient_InstallationMode_Resize_Farm_Renew()
  local self = Panel_Window_InstallationMode_Farm_info
  self:resize()
end
function FromClient_ShowInstallationMenu_Farm_Renew(installMode, isShow, isShowMove, isShowFix, isShowDelete, isShowCancel)
  local posX = housing_getInstallationMenuPosX()
  local posY = housing_getInstallationMenuPosY()
  local self = Panel_Window_InstallationMode_Farm_info
  self._value.isCanMove = isShowMove
  self._value.isCanDelete = isShowDelete
  if true == isShow then
    self:setKeyGuide(installMode, isShowMove, isShowFix, isShowDelete, isShowCancel)
  else
    self:setKeyGuide(installMode)
  end
end
function FromClient_InstallationMode_UpdateInventory_Farm_Renew()
  local self = Panel_Window_InstallationMode_Farm_info
  if false == PaGlobalFunc_InstallationMode_Farm_GetShow() then
    return
  end
  self:updateItemContent(true)
end
function FromClient_InstallationMode_UpdateInstallationActor_Farm_Renew(isAdd)
  local self = Panel_Window_InstallationMode_Farm_info
  if false == PaGlobalFunc_InstallationMode_Farm_GetShow() then
    return
  end
  self:updateItemContent(true)
end
function FromClient_ChangeHousingInstallMode_Farm_Renew(preMode, nowMode)
  local self = Panel_Window_InstallationMode_Farm_info
  self._value.currentMode = nowMode
  if self._mode_Type_Enum.InstallMode_None == self._value.currentMode then
    self:setKeyGuide(self._value.currentMode)
  elseif self._mode_Type_Enum.InstallMode_Translation == self._value.currentMode then
    self:setKeyGuide(self._value.currentMode)
  end
  if self._mode_Type_Enum.InstallMode_None == self._value.currentMode then
    Panel_House_InstallationMode_Farm:ignorePadSnapUpdate(false)
    self._ui.static_BottomBg:SetShow(true)
  else
    Panel_House_InstallationMode_Farm:ignorePadSnapUpdate(true)
    self._ui.static_BottomBg:SetShow(false)
  end
end
function FromClient_changePadCameraControlMode_Farm_Renew(canZoom)
  local self = Panel_Window_InstallationMode_Farm_info
  self:setKeyGuide(self._value.currentMode)
end
registerEvent("FromClient_luaLoadComplete", "FromClient_InstallationMode_Init")

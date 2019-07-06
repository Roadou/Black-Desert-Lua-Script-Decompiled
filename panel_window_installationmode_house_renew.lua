local UI_PUCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_CCC = CppEnums.CashProductCategory
local UI_CIT = CppEnums.InstallationType
local IM = CppEnums.EProcessorInputMode
local Panel_Window_InstallationMode_House_info = {
  _ui = {
    static_House_InstallationMode_Right = nil,
    static_TitleBg = nil,
    staticText_Title_Top = nil,
    static_TabMenuBG = nil,
    radioButton_AllIcon = nil,
    radioButton_ListIcon = nil,
    radioButton_TypeIcon = nil,
    radioButton_FurnitureIcon = nil,
    radioButton_MaterialIcon = nil,
    radioButton_ToolIcon = nil,
    staticText_ToolTip = nil,
    static_ToolTip_Arrow = nil,
    static_HousingItemListBG = nil,
    static_Item_Focus = nil,
    static_Item_Templete = nil,
    scroll_HousingItemList = nil,
    list2_HousingCategoryList = nil,
    static_WishListBG = nil,
    static_WishItemListBG = nil,
    static_WishListItemTemplete = nil,
    static_WishItem_Focus = nil,
    scroll_WishItemList = nil,
    staticText_HousingPointValue = nil,
    staticText_PearlPointValue = nil,
    staticText_PriceValue = nil,
    static_BottomBg = nil,
    staticText_A_Select_ConsoleUI = nil,
    staticText_Y_BuyAll_ConsoleUI = nil,
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
    isMyHouse = false,
    currentTabIndex = 0,
    currentItemIndex = 0,
    startItemIndex = 0,
    lastStartItemIndex = -1,
    itemDataCount = 0,
    currentWishIndex = 0,
    startWishIndex = 0,
    lastStartWishIndex = -1,
    wishDataCount = 0,
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
    wishSlotStartX = 0,
    wishSlotStartY = 0,
    wishSlotSpace = 15,
    wishSlotSizeX = 0,
    wishSlotSizeY = 0
  },
  _config = {
    itemMaxIndex = 56,
    itemSlotRow = 8,
    itemSlotCol = 7,
    wishMaxIndex = 14,
    wishSlotRow = 2,
    wishSlotCol = 7
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createCash = true
  },
  _menu_Top_Enum = {
    All = 0,
    CategoryList = 1,
    AllGoods = 2,
    AllFurniture = 3,
    AllBaseMaterial = 4,
    AllTools = 5,
    Count = 6
  },
  _menu_Top_String = {
    [0] = nil,
    [1] = nil,
    [2] = nil,
    [3] = nil,
    [4] = nil,
    [5] = nil
  },
  _menu_Category_Enum = {
    Dresser = 0,
    Wardrobe = 1,
    Table = 2,
    Chair = 3,
    Bookcase = 4,
    Bed = 5,
    OntheTable = 6,
    Floor = 7,
    Wall = 8,
    Ceiling = 9,
    WallPaper = 10,
    FloorMaterial = 11,
    Cooking = 12,
    Alchemy = 13,
    Count = 14
  },
  _menu_Category_String = {
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
    [11] = nil,
    [12] = nil,
    [13] = nil
  },
  _menu_Category_Texture = {
    [0] = {
      291,
      327,
      325,
      361
    },
    [1] = {
      256,
      327,
      290,
      361
    },
    [2] = {
      151,
      327,
      185,
      361
    },
    [3] = {
      221,
      257,
      255,
      291
    },
    [4] = {
      256,
      257,
      290,
      291
    },
    [5] = {
      291,
      257,
      325,
      291
    },
    [6] = {
      326,
      257,
      360,
      291
    },
    [7] = {
      256,
      292,
      290,
      326
    },
    [8] = {
      186,
      327,
      220,
      361
    },
    [9] = {
      221,
      292,
      255,
      326
    },
    [10] = {
      221,
      327,
      255,
      361
    },
    [11] = {
      326,
      327,
      360,
      361
    },
    [12] = {
      326,
      292,
      360,
      326
    },
    [13] = {
      291,
      292,
      325,
      326
    }
  },
  _categoryIndex = {
    [0] = CppEnums.InstallationType.eType_Carpenter,
    [1] = CppEnums.InstallationType.eType_Founding,
    [2] = CppEnums.InstallationType.eType_Treasure,
    [3] = CppEnums.InstallationType.eType_Smithing,
    [4] = CppEnums.InstallationType.eType_Bookcase,
    [5] = CppEnums.InstallationType.eType_Bed,
    [9] = CppEnums.InstallationType.eType_Chandelier,
    [10] = CppEnums.InstallationType.eType_WallPaper,
    [11] = CppEnums.InstallationType.eType_FloorMaterial,
    [12] = CppEnums.InstallationType.eType_Cooking,
    [13] = CppEnums.InstallationType.eType_Alchemy
  },
  _mode_Type_Enum = {
    InstallMode_None = 0,
    InstallMode_Translation = 1,
    InstallMode_Detail = 2,
    InstallMode_WatingConfirm = 3,
    InstallMode_Count = 4
  },
  _keyGuideString = {
    build = nil,
    install = nil,
    moveBuild = nil,
    changeWidthBuild = nil,
    changeHeightBuild = nil,
    zoomInOut = nil,
    changeCamMode = nil,
    zoomInOutAndHeight = nil
  },
  _panelKeyGuideEnum = {Select = 0, Collect = 1},
  _panelKeyGuideString = {
    [0] = nil,
    [1] = nil
  },
  _keyGuideBottom = {},
  _keyGuide = {},
  _tabSlot = {},
  _itemSlotBG = {},
  _itemSlot = {},
  _wishSlotBG = {},
  _wishSlot = {},
  _screenGapSize = {x = 0, y = 0}
}
function Panel_Window_InstallationMode_House_info:registEventHandler()
  Panel_House_InstallationMode:registerPadEvent(__eConsoleUIPadEvent_LB, "PaGlobalFunc_InstallationMode_House_ToogleTab(-1)")
  Panel_House_InstallationMode:registerPadEvent(__eConsoleUIPadEvent_RB, "PaGlobalFunc_InstallationMode_House_ToogleTab(1)")
  Panel_House_InstallationMode:registerPadEvent(__eConsoleUIPadEvent_Y, "PaGlobalFunc_InstallationMode_House_BuyItemAll()")
end
function Panel_Window_InstallationMode_House_info:registerMessageHandler()
  registerEvent("EventHousingShowInstallationMenu", "FromClient_ShowInstallationMenu_House_Renew")
  registerEvent("EventHousingUpdateInstallationInven", "FromClient_InstallationMode_UpdateInventory_House_Renew")
  registerEvent("EventUpdateInstallationActor", "FromClient_InstallationMode_UpdateInstallationActor_House_Renew")
  registerEvent("EventHousingShowVisitHouse", "FromClient_EventHousingPointUpdate_House_Renew")
  registerEvent("onScreenResize", "FromClient_InstallationMode_Resize_House_Renew")
  registerEvent("FromClient_ChangeHousingInstallMode", "FromClient_ChangeHousingInstallMode_House_Renew")
  registerEvent("FromClient_changePadCameraControlMode", "FromClient_changePadCameraControlMode_House_Renew")
  Panel_House_InstallationMode:RegisterUpdateFunc("PaGlobalFunc_InstallationMode_House_UpdatePerFrame")
end
function Panel_Window_InstallationMode_House_info:initialize()
  self:childControl()
  self:initValue()
  self:initString()
  self:resize()
  self:createItemSlot()
  self:createWishSlot()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Window_InstallationMode_House_info:initString()
  self._panelKeyGuideString[0] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORLDMAP_GUILDHOUSE_CHANGEWORKER_SELECTBTN")
  self._panelKeyGuideString[1] = PAGetString(Defines.StringSheet_GAME, "LUA_CAMP_REMOTERESET_TITLE")
  self._menu_Top_String[0] = PAGetString(Defines.StringSheet_RESOURCE, "HOUSING_BTN_SEARCH_ALL")
  self._menu_Top_String[1] = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_SUBFILTER_FURNITURE")
  self._menu_Top_String[2] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_HOUSE_INSTALLATIONMODE_SEARCH_BASEMATERIAL")
  self._menu_Top_String[3] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_HOUSE_INSTALLATIONMODE_SEARCH_FURNITURE")
  self._menu_Top_String[4] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_HOUSE_INSTALLATIONMODE_SEARCH_GOODS")
  self._menu_Top_String[5] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_HOUSE_INSTALLATIONMODE_SEARCH_TOOLS")
  self._menu_Category_String[0] = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_DRESSER")
  self._menu_Category_String[1] = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_WARDRODE")
  self._menu_Category_String[2] = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_TABLE")
  self._menu_Category_String[3] = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_CHAIR")
  self._menu_Category_String[4] = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_BOOKCASE")
  self._menu_Category_String[5] = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_BED")
  self._menu_Category_String[6] = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_ONTHETABLE")
  self._menu_Category_String[7] = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_FLOOR")
  self._menu_Category_String[8] = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_WALL")
  self._menu_Category_String[9] = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_CEILING")
  self._menu_Category_String[10] = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_WALLPAPER")
  self._menu_Category_String[11] = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_FLOORMATERIAL")
  self._menu_Category_String[12] = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_COOKING")
  self._menu_Category_String[13] = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TOOLTIP_CATEGORYICON_ALCHEMY")
  self._keyGuideString.build = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTALLMODE_KEYGUIDE_BUILD")
  self._keyGuideString.install = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTALLMODE_KEYGUIDE_INSTALL")
  self._keyGuideString.moveBuild = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTALLMODE_KEYGUIDE_OBJECT_MOVE")
  self._keyGuideString.changeWidthBuild = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTALLMODE_KEYGUIDE_OBJECT_CHANGE_WIDTH")
  self._keyGuideString.changeHeightBuild = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTALLMODE_KEYGUIDE_OBJECT_CHANGE_HEIGHT")
  self._keyGuideString.zoomInOut = PAGetString(Defines.StringSheet_RESOURCE, "HOUSING_TXT_HELPZOOM")
  self._keyGuideString.changeCamMode = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTALLMODE_KEYGUIDE_OBJECT_CHANGE_CAMMODE")
  self._keyGuideString.zoomInOutAndHeight = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_INSTALLMODE_KEYGUIDE_OBJECT_CHANGE_HEIGHTMODE")
end
function Panel_Window_InstallationMode_House_info:initValue()
  self:initTabValue()
  self:initItemValue()
  self:initWishValue()
  self._screenGapSize.x = (getOriginScreenSizeX() - getScreenSizeX()) / 2
  self._screenGapSize.y = (getOriginScreenSizeY() - getScreenSizeY()) / 2
end
function Panel_Window_InstallationMode_House_info:initTabValue()
  self._value.currentTabIndex = self._menu_Top_Enum.All
end
function Panel_Window_InstallationMode_House_info:initItemValue()
  self._value.currentItemIndex = -1
  self._value.startItemIndex = 0
  self._value.lastStartItemIndex = -1
  self._value.itemDataCount = 0
end
function Panel_Window_InstallationMode_House_info:initWishValue()
  self._value.currentWishIndex = -1
  self._value.startWishIndex = 0
  self._value.lastStartWishIndex = -1
  self._value.wishDataCount = 0
end
function Panel_Window_InstallationMode_House_info:resize()
  local sizeX = getScreenSizeX()
  local sizeY = getScreenSizeY()
  Panel_House_InstallationMode:SetSize(sizeX, sizeY)
  Panel_House_InstallationMode:SetPosXY(0, 0)
  self._ui.static_House_InstallationMode_Right:ComputePos()
  self._ui.static_House_InstallationMode_Right:SetSize(self._ui.static_House_InstallationMode_Right:GetSizeX(), sizeY)
  self._screenGapSize.x = (getOriginScreenSizeX() - getScreenSizeX()) / 2
  self._screenGapSize.y = (getOriginScreenSizeY() - getScreenSizeY()) / 2
end
function Panel_Window_InstallationMode_House_info:childControl()
  self._ui.static_House_InstallationMode_Right = UI.getChildControl(Panel_House_InstallationMode, "Static_House_InstallationMode_Right")
  self._ui.static_TitleBg = UI.getChildControl(self._ui.static_House_InstallationMode_Right, "Static_TitleBg")
  self._ui.staticText_Title_Top = UI.getChildControl(self._ui.static_TitleBg, "StaticText_Title_Top")
  self._ui.static_TabMenuBG = UI.getChildControl(self._ui.static_House_InstallationMode_Right, "Static_TabMenuBG")
  self._ui.radioButton_AllIcon = UI.getChildControl(self._ui.static_TabMenuBG, "RadioButton_AllIcon")
  self._ui.radioButton_ListIcon = UI.getChildControl(self._ui.static_TabMenuBG, "RadioButton_ListIcon")
  self._ui.radioButton_TypeIcon = UI.getChildControl(self._ui.static_TabMenuBG, "RadioButton_TypeIcon")
  self._ui.radioButton_FurnitureIcon = UI.getChildControl(self._ui.static_TabMenuBG, "RadioButton_FurnitureIcon")
  self._ui.radioButton_MaterialIcon = UI.getChildControl(self._ui.static_TabMenuBG, "RadioButton_MaterialIcon")
  self._ui.radioButton_ToolIcon = UI.getChildControl(self._ui.static_TabMenuBG, "RadioButton_ToolIcon")
  self._ui.staticText_ToolTip = UI.getChildControl(self._ui.static_TabMenuBG, "StaticText_ToolTip")
  self._ui.static_ToolTip_Arrow = UI.getChildControl(self._ui.staticText_ToolTip, "Static_ToolTip_Arrow")
  self._tabSlot[self._menu_Top_Enum.All] = self._ui.radioButton_AllIcon
  self._tabSlot[self._menu_Top_Enum.CategoryList] = self._ui.radioButton_ListIcon
  self._tabSlot[self._menu_Top_Enum.AllGoods] = self._ui.radioButton_TypeIcon
  self._tabSlot[self._menu_Top_Enum.AllFurniture] = self._ui.radioButton_FurnitureIcon
  self._tabSlot[self._menu_Top_Enum.AllBaseMaterial] = self._ui.radioButton_MaterialIcon
  self._tabSlot[self._menu_Top_Enum.AllTools] = self._ui.radioButton_ToolIcon
  self._ui.static_HousingItemListBG = UI.getChildControl(self._ui.static_House_InstallationMode_Right, "Static_HousingItemListBG")
  self._ui.static_Item_Focus = UI.getChildControl(self._ui.static_HousingItemListBG, "Static_Item_Focus")
  self._ui.static_Item_Focus:SetShow(false)
  self._ui.static_Item_Templete = UI.getChildControl(self._ui.static_HousingItemListBG, "Static_Item_Templete")
  self._ui.static_Item_Templete:SetShow(false)
  self._pos.itemSlotStartX = self._ui.static_Item_Templete:GetPosX()
  self._pos.itemSlotStartY = self._ui.static_Item_Templete:GetPosY()
  self._pos.itemSlotSizeX = self._ui.static_Item_Templete:GetSizeX()
  self._pos.itemSlotSizeY = self._ui.static_Item_Templete:GetSizeY()
  self._ui.scroll_HousingItemList = UI.getChildControl(self._ui.static_HousingItemListBG, "Scroll_HousingItemList")
  UIScroll.InputEvent(self._ui.scroll_HousingItemList, "PaGlobalFunc_InstallationMode_House_ScrollItem")
  self._ui.list2_HousingCategoryList = UI.getChildControl(self._ui.static_House_InstallationMode_Right, "List2_HousingCategoryList")
  self._ui.list2_HousingCategoryList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_InstallationMode_House_FilterList")
  self._ui.list2_HousingCategoryList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.list2_HousingCategoryList:SetShow(false)
  self._ui.static_WishListBG = UI.getChildControl(self._ui.static_House_InstallationMode_Right, "Static_WishListBG")
  self._ui.static_WishItemListBG = UI.getChildControl(self._ui.static_WishListBG, "Static_WishItemListBG")
  self._ui.static_WishListItemTemplete = UI.getChildControl(self._ui.static_WishItemListBG, "Static_WishListItemTemplete")
  self._ui.static_WishListItemTemplete:SetShow(false)
  self._pos.wishSlotStartX = self._ui.static_WishListItemTemplete:GetPosX()
  self._pos.wishSlotStartY = self._ui.static_WishListItemTemplete:GetPosY()
  self._pos.wishSlotSizeX = self._ui.static_WishListItemTemplete:GetSizeX()
  self._pos.wishSlotSizeY = self._ui.static_WishListItemTemplete:GetSizeY()
  self._ui.static_WishItem_Focus = UI.getChildControl(self._ui.static_WishItemListBG, "Static_WishItem_Focus")
  self._ui.static_WishItem_Focus:SetShow(false)
  self._ui.scroll_WishItemList = UI.getChildControl(self._ui.static_WishListBG, "Scroll_WishItemList")
  self._ui.staticText_HousingPointValue = UI.getChildControl(self._ui.static_WishListBG, "StaticText_HousingPointValue")
  self._ui.staticText_PearlPointValue = UI.getChildControl(self._ui.static_WishListBG, "StaticText_PearlPointValue")
  self._ui.staticText_PriceValue = UI.getChildControl(self._ui.static_WishListBG, "StaticText_PriceValue")
  self._ui.static_BottomBg = UI.getChildControl(self._ui.static_House_InstallationMode_Right, "Static_BottomBg")
  self._ui.staticText_A_Select_ConsoleUI = UI.getChildControl(self._ui.static_BottomBg, "StaticText_A_Select_ConsoleUI")
  self._ui.staticText_Y_BuyAll_ConsoleUI = UI.getChildControl(self._ui.static_BottomBg, "StaticText_Y_BuyAll_ConsoleUI")
  self._ui.staticText_B_Close_ConsoleUI = UI.getChildControl(self._ui.static_BottomBg, "StaticText_B_Close_ConsoleUI")
  self._keyGuideBottom = {
    self._ui.staticText_A_Select_ConsoleUI,
    self._ui.staticText_Y_BuyAll_ConsoleUI,
    self._ui.staticText_B_Close_ConsoleUI
  }
  self._ui.static_KeyGuide_ConsoleBG = UI.getChildControl(self._ui.static_House_InstallationMode_Right, "Static_KeyGuide_ConsoleBG")
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
  self._ui.static_Move = UI.getChildControl(Panel_House_InstallationMode, "Static_Move")
end
function Panel_Window_InstallationMode_House_info:createItemSlot()
  for index = 0, self._config.itemMaxIndex - 1 do
    local slotBG = {}
    slotBG.bg = UI.createAndCopyBasePropertyControl(self._ui.static_HousingItemListBG, "Static_Item_Templete", self._ui.static_HousingItemListBG, "Static_Item_Templete_" .. index)
    slotBG.bluebg = UI.createAndCopyBasePropertyControl(self._ui.static_Item_Templete, "Static_BlueItemSlotBg", slotBG.bg, "Static_BlueItemSlotBg_" .. index)
    slotBG.check = UI.createAndCopyBasePropertyControl(self._ui.static_Item_Templete, "Static_CheckMarkTemplete", slotBG.bg, "Static_CheckMarkTemplete_" .. index)
    local row = math.floor(index / self._config.itemSlotCol)
    local col = index % self._config.itemSlotCol
    slotBG.bg:SetShow(true)
    slotBG.bg:SetPosX(self._pos.itemSlotStartX + (self._pos.itemSlotSizeX + self._pos.itemSlotSpace) * col)
    slotBG.bg:SetPosY(self._pos.itemSlotStartY + (self._pos.itemSlotSizeY + self._pos.itemSlotSpace) * row)
    if 0 == row then
      slotBG.bg:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "PaGlobalFunc_InstallationMode_House_ScrollItem(true)")
    end
    if self._config.itemSlotRow - 1 == row then
      slotBG.bg:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "PaGlobalFunc_InstallationMode_House_ScrollItem(false)")
    end
    local slot = {}
    SlotItem.new(slot, "Static_Item_" .. index, index, slotBG.bg, self._slotConfig)
    slot:createChild()
    slot.icon:SetPosX(slot.icon:GetPosX() + 2)
    slot.icon:SetPosY(slot.icon:GetPosY() + 2)
    slotBG.bg:SetChildOrder(slot.icon:GetKey(), slotBG.check:GetKey())
    slotBG.bg:SetChildOrder(slot.icon:GetKey(), self._ui.static_Item_Focus:GetKey())
    self._ui.static_HousingItemListBG:SetChildOrder(slotBG.bg:GetKey(), self._ui.static_Item_Focus:GetKey())
    self._itemSlotBG[index] = slotBG
    self._itemSlot[index] = slot
    self._itemSlotBG[index].bg:addInputEvent("Mouse_On", "PaGlobalFunc_InstallationMode_House_FocusSlot(true,false," .. index .. ")")
    self._itemSlotBG[index].bg:addInputEvent("Mouse_Out", "PaGlobalFunc_InstallationMode_House_FocusSlot(false,false," .. index .. ")")
  end
end
function Panel_Window_InstallationMode_House_info:createWishSlot()
  for index = 0, self._config.wishMaxIndex - 1 do
    local slotBG = {}
    slotBG.bg = UI.createAndCopyBasePropertyControl(self._ui.static_WishItemListBG, "Static_WishListItemTemplete", self._ui.static_WishItemListBG, "Static_WishListItemTemplete_" .. index)
    local row = math.floor(index / self._config.wishSlotCol)
    local col = index % self._config.wishSlotCol
    slotBG.bg:SetPosX(self._pos.wishSlotStartX + (self._pos.wishSlotSizeX + self._pos.wishSlotSpace) * col)
    slotBG.bg:SetPosY(self._pos.wishSlotStartY + (self._pos.wishSlotSizeY + self._pos.wishSlotSpace) * row)
    local slot = {}
    SlotItem.new(slot, "Static_WishItem_" .. index, index, slotBG.bg, self._slotConfig)
    slot:createChild()
    if 0 == row then
      slotBG.bg:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "PaGlobalFunc_InstallationMode_House_ScrollWish(true)")
    end
    if self._config.wishSlotRow - 1 == row then
      slotBG.bg:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "PaGlobalFunc_InstallationMode_House_ScrollWish(false)")
    end
    slotBG.bg:SetChildOrder(slot.icon:GetKey(), self._ui.static_WishItem_Focus:GetKey())
    self._ui.static_WishItemListBG:SetChildOrder(slotBG.bg:GetKey(), self._ui.static_WishItem_Focus:GetKey())
    self._wishSlotBG[index] = slotBG
    self._wishSlot[index] = slot
    self._wishSlotBG[index].bg:addInputEvent("Mouse_On", "PaGlobalFunc_InstallationMode_House_FocusSlot(true,true," .. index .. ")")
    self._wishSlotBG[index].bg:addInputEvent("Mouse_Out", "PaGlobalFunc_InstallationMode_House_FocusSlot(false,true," .. index .. ")")
  end
end
function Panel_Window_InstallationMode_House_info:clearTab()
  self._tabSlot[self._menu_Top_Enum.All]:SetCheck(false)
  self._tabSlot[self._menu_Top_Enum.CategoryList]:SetCheck(false)
  self._tabSlot[self._menu_Top_Enum.AllBaseMaterial]:SetCheck(false)
  self._tabSlot[self._menu_Top_Enum.AllFurniture]:SetCheck(false)
  self._tabSlot[self._menu_Top_Enum.AllGoods]:SetCheck(false)
  self._tabSlot[self._menu_Top_Enum.AllTools]:SetCheck(false)
end
function Panel_Window_InstallationMode_House_info:checkAndShowItem()
  if false == self._ui.static_HousingItemListBG:GetShow() then
    self._ui.static_HousingItemListBG:SetShow(true)
    self:initItemValue()
    self:setItemScroll()
    self:updateItemContent()
  else
    self:initItemValue()
    self:setItemScroll()
    self:updateItemContent(true)
  end
end
function Panel_Window_InstallationMode_House_info:setKeyGuideBottom(stringNum)
  if nil == stringNum then
    self._ui.staticText_A_Select_ConsoleUI:SetShow(false)
  else
    self._ui.staticText_A_Select_ConsoleUI:SetShow(true)
    self._ui.staticText_A_Select_ConsoleUI:SetText(self._panelKeyGuideString[stringNum])
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideBottom, self._ui.static_House_InstallationMode_Right, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT, nil, 20)
end
function Panel_Window_InstallationMode_House_info:setKeyPosX(parantControl, keyList)
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
function Panel_Window_InstallationMode_House_info:setKeyGuide(modeType, isShowMove, isShowFix, isShowDelete, isShowCancel)
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
    self._ui.staticText_RS_Click_ConsoleUI:SetText(self._keyGuideString.changeCamMode)
    self._ui.staticText_RS_Click_ConsoleUI:SetShow(true)
    if false == ToClient_isCameraControlModeForConsole() then
      self._ui.staticText_RS_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(false)
    else
      self._ui.staticText_RS_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetText(self._keyGuideString.zoomInOut)
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
    self._ui.staticText_RS_Click_ConsoleUI:SetText(self._keyGuideString.changeCamMode)
    self._ui.staticText_RS_Click_ConsoleUI:SetShow(true)
    if false == ToClient_isCameraControlModeForConsole() then
      self._ui.staticText_RS_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(false)
    else
      self._ui.staticText_RS_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetText(self._keyGuideString.zoomInOut)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(true)
    end
    if true == isFixed then
      self._ui.staticText_LS_ConsoleUI:SetText(self._keyGuideString.moveBuild)
      self._ui.staticText_LS_ConsoleUI:SetShow(true)
    end
    if true == isRotatePossible then
      self._ui.staticText_LB_RB_ConsoleUI:SetShow(true)
      self._ui.staticText_LT_RT_ConsoleUI:SetShow(true)
    end
    self._ui.staticText_A_ConsoleUI:SetText(self._keyGuideString.build)
    self._ui.staticText_A_ConsoleUI:SetShow(true)
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
    self._ui.staticText_RS_Click_ConsoleUI:SetText(self._keyGuideString.zoomInOutAndHeight)
    self._ui.staticText_RS_Click_ConsoleUI:SetShow(true)
    if false == ToClient_isCameraControlModeForConsole() then
      self._ui.staticText_RS_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(false)
    else
      self._ui.staticText_RS_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(true)
    end
    if UI_CIT.eType_Curtain == installationType or UI_CIT.eType_Curtain_Tied == installationType then
      self._ui.staticText_LS_ConsoleUI:SetText(self._keyGuideString.changeWidthBuild)
      self._ui.staticText_LS_ConsoleUI:SetShow(true)
    end
    if UI_CIT.eType_Chandelier == installationType or UI_CIT.eType_Curtain == installationType or UI_CIT.eType_Curtain_Tied == installationType then
      if false == ToClient_isCameraControlModeForConsole() then
        self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(false)
      else
        self._ui.staticText_RS_UpDown_ConsoleUI:SetText(self._keyGuideString.changeHeightBuild)
        self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(true)
      end
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
    self._ui.staticText_RS_Click_ConsoleUI:SetText(self._keyGuideString.changeCamMode)
    self._ui.staticText_RS_Click_ConsoleUI:SetShow(true)
    if false == ToClient_isCameraControlModeForConsole() then
      self._ui.staticText_RS_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetShow(false)
    else
      self._ui.staticText_RS_ConsoleUI:SetShow(false)
      self._ui.staticText_RS_LeftRight_ConsoleUI:SetShow(true)
      self._ui.staticText_RS_UpDown_ConsoleUI:SetText(self._keyGuideString.zoomInOut)
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
function Panel_Window_InstallationMode_House_info:setList()
  self._ui.list2_HousingCategoryList:getElementManager():clearKey()
  for index = 0, self._menu_Category_Enum.Count - 1 do
    self._ui.list2_HousingCategoryList:getElementManager():pushKey(toInt64(0, index))
    self._ui.list2_HousingCategoryList:requestUpdateByKey(toInt64(0, index))
  end
end
function Panel_Window_InstallationMode_House_info:setTab()
  self:clearTab()
  self._ui.staticText_ToolTip:SetText(self._menu_Top_String[self._value.currentTabIndex])
  local sizeX = self._ui.staticText_ToolTip:GetTextSizeX()
  self._ui.staticText_ToolTip:SetSize(sizeX + 10, self._ui.staticText_ToolTip:GetSizeY())
  self._ui.staticText_ToolTip:SetPosX(self._tabSlot[self._value.currentTabIndex]:GetPosX() - self._ui.staticText_ToolTip:GetSizeX() / 2 + self._tabSlot[self._value.currentTabIndex]:GetSizeX() / 2)
  self._ui.static_ToolTip_Arrow:ComputePos()
  self._tabSlot[self._value.currentTabIndex]:SetCheck(true)
  self._ui.list2_HousingCategoryList:SetShow(false)
  ToClient_Housing_List_ClearFilter()
  if self._menu_Top_Enum.All == self._value.currentTabIndex then
    self:checkAndShowItem()
  elseif self._menu_Top_Enum.CategoryList == self._value.currentTabIndex then
    self._ui.list2_HousingCategoryList:SetShow(true)
    self:setList()
    self._ui.static_HousingItemListBG:SetShow(false)
  elseif self._menu_Top_Enum.AllBaseMaterial == self._value.currentTabIndex then
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.WallPaper])
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.FloorMaterial])
    self:checkAndShowItem()
  elseif self._menu_Top_Enum.AllFurniture == self._value.currentTabIndex then
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Dresser])
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Wardrobe])
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Table])
    ToClient_Housing_List_Filter_InstallType(CppEnums.InstallationType.eType_Forging)
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Chair])
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Bookcase])
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Bed])
    self:checkAndShowItem()
  elseif self._menu_Top_Enum.AllGoods == self._value.currentTabIndex then
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Ceiling])
    ToClient_Housing_List_Filter_Table()
    ToClient_Housing_List_Filter_Floor()
    ToClient_Housing_List_Filter_Wall()
    self:checkAndShowItem()
  elseif self._menu_Top_Enum.AllTools == self._value.currentTabIndex then
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Cooking])
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Alchemy])
    self:checkAndShowItem()
  end
  ToClient_padSnapResetControl()
end
function Panel_Window_InstallationMode_House_info:setSubCategory(filter)
  self._ui.list2_HousingCategoryList:SetShow(false)
  self._ui.static_HousingItemListBG:SetShow(true)
  ToClient_Housing_List_ClearFilter()
  if self._menu_Category_Enum.Dresser == filter then
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Dresser])
  elseif self._menu_Category_Enum.Wardrobe == filter then
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Wardrobe])
  elseif self._menu_Category_Enum.Table == filter then
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Table])
  elseif self._menu_Category_Enum.Chair == filter then
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Chair])
  elseif self._menu_Category_Enum.Bookcase == filter then
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Bookcase])
  elseif self._menu_Category_Enum.Bed == filter then
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Bed])
  elseif self._menu_Category_Enum.OntheTable == filter then
    ToClient_Housing_List_Filter_Table()
  elseif self._menu_Category_Enum.Floor == filter then
    ToClient_Housing_List_Filter_Floor()
  elseif self._menu_Category_Enum.Wall == filter then
    ToClient_Housing_List_Filter_Wall()
  elseif self._menu_Category_Enum.Ceiling == filter then
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Ceiling])
  elseif self._menu_Category_Enum.WallPaper == filter then
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.WallPaper])
  elseif self._menu_Category_Enum.FloorMaterial == filter then
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.FloorMaterial])
  elseif self._menu_Category_Enum.Cooking == filter then
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Cooking])
  elseif self._menu_Category_Enum.Alchemy == filter then
    ToClient_Housing_List_Filter_InstallType(self._categoryIndex[self._menu_Category_Enum.Alchemy])
  end
  self:updateItemContent(true)
end
function Panel_Window_InstallationMode_House_info:setItemData(initflag)
  if nil == initflag then
    initflag = false
  end
  ToClient_Furniture_Setdata(initflag)
  self._value.itemDataCount = ToClient_GetFurnitureListSize()
end
function Panel_Window_InstallationMode_House_info:updateItemScroll(isUpScroll)
  local beforeSlotIndex = self._value.startItemIndex
  self._value.startItemIndex = UIScroll.ScrollEvent(self._ui.scroll_HousingItemList, isUpScroll, self._config.itemSlotRow, self._value.itemDataCount, self._value.startItemIndex, self._config.itemSlotCol)
  self._value.lastStartItemIndex = beforeSlotIndex
  if (ToClient_isConsole() or ToClient_IsDevelopment()) and beforeSlotIndex ~= self._value.startItemIndex then
    ToClient_padSnapIgnoreGroupMove()
  end
  self:setItemSlot()
end
function Panel_Window_InstallationMode_House_info:setItemScroll()
  UIScroll.SetButtonSize(self._ui.scroll_HousingItemList, self._config.itemMaxIndex, self._value.itemDataCount)
  self._ui.scroll_HousingItemList:SetControlPos(0)
  if self._value.itemDataCount == self._value.startItemIndex + self._config.itemSlotRow then
    self._ui.scroll_HousingItemList:SetControlBottom()
  end
end
function Panel_Window_InstallationMode_House_info:focusItem(isOn, index)
  if nil == self._itemSlotBG[index].bg then
    return
  end
  local posX = self._itemSlotBG[index].bg:GetPosX()
  local posY = self._itemSlotBG[index].bg:GetPosY()
  if isOn then
    self._value.currentItemIndex = index
    self._value.currentWishIndex = -1
    self._ui.static_Item_Focus:SetShow(true)
    self._ui.static_Item_Focus:SetPosXY(posX, posY)
  else
    self._ui.static_Item_Focus:SetShow(false)
  end
  if nil ~= self._itemSlot[index] and nil ~= self._itemSlot[index].icon and false == self._itemSlot[index].icon:GetShow() then
    self._ui.staticText_A_Select_ConsoleUI:SetShow(false)
  end
end
function Panel_Window_InstallationMode_House_info:setItemSlot()
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  if 0 <= self._value.itemDataCount then
    for index = 0, self._config.itemMaxIndex - 1 do
      self._itemSlot[index].icon:addInputEvent("Mouse_On", "")
      self._itemSlot[index].icon:addInputEvent("Mouse_Out", "")
      self._itemSlot[index].icon:addInputEvent("Mouse_LUp", "")
      self._itemSlot[index]:clearItem()
      self._itemSlotBG[index].bluebg:SetShow(false)
      self._itemSlotBG[index].bg:SetShow(true)
      self._itemSlot[index].isCash:SetShow(false)
      self._itemSlotBG[index].check:SetShow(false)
    end
  end
  if self._config.itemMaxIndex - 1 < self._value.itemDataCount then
    self._ui.scroll_HousingItemList:SetShow(true)
  else
    self._ui.scroll_HousingItemList:SetShow(false)
  end
  for index = 0, self._config.itemMaxIndex - 1 do
    local slotIndex = self._value.startItemIndex + index
    local Data = ToClient_GetFurniture(slotIndex)
    if nil ~= Data then
      self._itemSlotBG[index].bg:SetShow(true)
      if true == Data._isInstalled then
        if index == self._value.currentItemIndex then
          PaGlobalFunc_InstallationMode_House_showInstalledItemToolTip(true, Data._invenSlotNo, index)
        end
        self._itemSlot[index].icon:addInputEvent("Mouse_On", "PaGlobalFunc_InstallationMode_House_showInstalledItemToolTip(true, " .. Data._invenSlotNo .. ", " .. index .. " )")
        self._itemSlot[index].icon:addInputEvent("Mouse_LUp", "PaGlobalFunc_InstallationMode_House_SelectInstalledObject( " .. Data._invenSlotNo .. " )")
        self._itemSlot[index].isCash:SetShow(false)
        self._itemSlotBG[index].bg:registerPadEvent(__eConsoleUIPadEvent_X, "PaGlobalFunc_InstallationMode_House_showInstalledItemToolTip(false, " .. Data._invenSlotNo .. ", " .. index .. " )")
        self._itemSlotBG[index].bluebg:SetShow(false)
        self._itemSlotBG[index].check:SetShow(true)
      elseif not Data._isCashProduct then
        if index == self._value.currentItemIndex then
          PaGlobalFunc_InstallationMode_House_showToolTip(true, Data._invenType, Data._invenSlotNo, index, self._panelKeyGuideEnum.Select)
        end
        self._itemSlot[index].icon:addInputEvent("Mouse_On", "PaGlobalFunc_InstallationMode_House_showToolTip(true, " .. Data._invenType .. ", " .. Data._invenSlotNo .. ", " .. index .. "," .. self._panelKeyGuideEnum.Select .. ")")
        self._itemSlot[index].icon:addInputEvent("Mouse_LUp", "PaGlobalFunc_InstallationMode_House_installFurniture( " .. Data._invenType .. ", " .. Data._invenSlotNo .. ", false, " .. 0 .. ")")
        self._itemSlot[index].isCash:SetShow(false)
        self._itemSlotBG[index].bg:registerPadEvent(__eConsoleUIPadEvent_X, "PaGlobalFunc_InstallationMode_House_showToolTip(false, " .. Data._invenType .. ", " .. Data._invenSlotNo .. ", " .. index .. "," .. self._panelKeyGuideEnum.Select .. ")")
        self._itemSlotBG[index].bluebg:SetShow(false)
        self._itemSlotBG[index].check:SetShow(false)
      else
        if index == self._value.currentItemIndex then
          PaGlobalFunc_InstallationMode_House_CashItemShowToolTip(true, Data._productNoRaw, index)
        end
        self._itemSlot[index].icon:registerPadEvent(__eConsoleUIPadEvent_X, "PaGlobalFunc_InstallationMode_House_CashItemShowToolTip(false, " .. Data._productNoRaw .. ", " .. index .. " )")
        self._itemSlot[index].icon:addInputEvent("Mouse_On", "PaGlobalFunc_InstallationMode_House_CashItemShowToolTip(true, " .. Data._productNoRaw .. ", " .. index .. " )")
        self._itemSlot[index].icon:addInputEvent("Mouse_LUp", "PaGlobalFunc_InstallationMode_House_installFurniture( " .. Data._invenType .. ", " .. Data._invenSlotNo .. ", true, " .. Data._productNoRaw .. ")")
        self._itemSlot[index].isCash:SetShow(true)
        self._itemSlotBG[index].bg:registerPadEvent(__eConsoleUIPadEvent_X, "PaGlobalFunc_InstallationMode_House_CashItemShowToolTip(false, " .. Data._productNoRaw .. ", " .. index .. " )")
        self._itemSlotBG[index].bluebg:SetShow(true)
        self._itemSlotBG[index].check:SetShow(false)
      end
      self._itemSlot[index]:setItemByStaticStatus(Data:getItemStaticStatusWrapper(), 0)
      self._itemSlot[index].icon:SetAlpha(1)
      self._itemSlot[index].icon:SetShow(true)
      self._itemSlot[index].icon:addInputEvent("Mouse_Out", "PaGlobalFunc_InstallationMode_House_HideTooltip()")
    end
    if slotIndex >= self._value.itemDataCount then
      self._itemSlot[index].icon:addInputEvent("Mouse_LUp", "")
      self._itemSlot[index].icon:addInputEvent("Mouse_Out", "PaGlobalFunc_InstallationMode_House_HideTooltip()")
      self._itemSlot[index].icon:SetShow(false)
      self._itemSlotBG[index].bg:registerPadEvent(__eConsoleUIPadEvent_X, "")
      self._itemSlotBG[index].bluebg:SetShow(false)
    end
  end
end
function Panel_Window_InstallationMode_House_info:setWishData()
  self._value.wishDataCount = housing_getShoppingBasketItemCount()
end
function Panel_Window_InstallationMode_House_info:updateWishScroll(isUpScroll)
  local beforeSlotIndex = self._value.startWishIndex
  self._value.startWishIndex = UIScroll.ScrollEvent(self._ui.scroll_WishItemList, isUpScroll, self._config.wishSlotRow, self._value.wishDataCount, self._value.startWishIndex, self._config.wishSlotCol)
  self._value.lastStartWishIndex = beforeSlotIndex
  if (ToClient_isConsole() or ToClient_IsDevelopment()) and beforeSlotIndex ~= self._value.startWishIndex then
    ToClient_padSnapIgnoreGroupMove()
  end
  self:setWishSlot()
end
function Panel_Window_InstallationMode_House_info:setWishScroll()
  UIScroll.SetButtonSize(self._ui.scroll_WishItemList, self._config.wishMaxIndex, self._value.wishDataCount)
  if self._value.itemDataCount == self._value.startWishIndex + self._config.wishSlotRow then
    self._ui.scroll_WishItemList:SetControlBottom()
  end
end
function Panel_Window_InstallationMode_House_info:focusWishItem(isOn, index)
  if nil == self._wishSlotBG[index].bg then
    return
  end
  local posX = self._wishSlotBG[index].bg:GetPosX()
  local posY = self._wishSlotBG[index].bg:GetPosY()
  if isOn then
    self._value.currentWishIndex = index
    self._value.currentItemIndex = -1
    self._ui.static_WishItem_Focus:SetShow(true)
    self._ui.static_WishItem_Focus:SetPosXY(posX, posY)
  else
    self._ui.static_WishItem_Focus:SetShow(false)
  end
  if nil ~= self._wishSlot[index] and nil ~= self._wishSlot[index].icon and false == self._wishSlot[index].icon:GetShow() then
    self._ui.staticText_A_Select_ConsoleUI:SetShow(false)
  end
end
function Panel_Window_InstallationMode_House_info:setWishSlot()
  if 0 <= self._value.wishDataCount then
    for index = 0, self._config.wishMaxIndex - 1 do
      self._wishSlot[index].icon:addInputEvent("Mouse_On", "")
      self._wishSlot[index].icon:addInputEvent("Mouse_Out", "")
      self._wishSlot[index].icon:addInputEvent("Mouse_LUp", "")
      self._wishSlot[index]:clearItem()
      self._wishSlotBG[index].bg:SetShow(true)
      self._wishSlot[index].isCash:SetShow(false)
    end
  end
  local s64_havePearls = 0
  local pearlItemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, getPearlSlotNo())
  if nil ~= pearlItemWrapper then
    s64_havePearls = pearlItemWrapper:get():getCount_s64()
  end
  self._ui.staticText_PearlPointValue:SetText(makeDotMoney(s64_havePearls))
  self._ui.staticText_PriceValue:SetText("0")
  self._ui.staticText_HousingPointValue:SetText(ToClient_GetVisitingBuyExpectPlusInteriorPoint())
  local s64_havePearls = 0
  local pearlItemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, getPearlSlotNo())
  if nil ~= pearlItemWrapper then
    s64_havePearls = pearlItemWrapper:get():getCount_s64()
  end
  self._ui.staticText_PearlPointValue:SetText(makeDotMoney(s64_havePearls))
  self._ui.staticText_PriceValue:SetText("0")
  self._ui.staticText_HousingPointValue:SetText(ToClient_GetVisitingBuyExpectPlusInteriorPoint())
  local s64_SumPearls = toInt64(0, 0)
  local interiorTotalPoint = 0
  for idx = 0, self._value.wishDataCount - 1 do
    local cPSSW = housing_getShoppingBasketItemByIndex_New(idx)
    if nil ~= cPSSW then
      local itemSSW = cPSSW:getItemByIndex(0)
      s64_SumPearls = s64_SumPearls + cPSSW:getPrice()
    end
  end
  self._ui.staticText_PriceValue:SetText(makeDotMoney(s64_SumPearls))
  for index = 0, self._config.wishMaxIndex - 1 do
    local slotIndex = self._value.startWishIndex + index
    local cPSSW = housing_getShoppingBasketItemByIndex_New(slotIndex)
    if nil ~= cPSSW then
      local itemSSW = cPSSW:getItemByIndex(0)
      if index == self._value.currentWishIndex then
        PaGlobalFunc_InstallationMode_House_showToolTip(true, slotIndex, index, nil, self._panelKeyGuideEnum.Collect)
      end
      self._wishSlotBG[index].bg:SetShow(true)
      self._wishSlot[index]:setItemByStaticStatus(itemSSW, 0)
      self._wishSlot[index].icon:SetShow(true)
      self._itemSlot[index].icon:registerPadEvent(__eConsoleUIPadEvent_X, "")
      self._wishSlot[index].icon:addInputEvent("Mouse_On", "PaGlobalFunc_InstallationMode_House_showToolTip(true," .. slotIndex .. ", " .. index .. ",nil, " .. self._panelKeyGuideEnum.Collect .. ")")
      self._wishSlot[index].icon:addInputEvent("Mouse_LUp", "PaGlobalFunc_InstallationMode_House_ClickWishSlot(" .. slotIndex .. ")")
      self._wishSlot[index].icon:addInputEvent("Mouse_Out", "PaGlobalFunc_InstallationMode_House_HideTooltip()")
    end
    if slotIndex >= self._value.wishDataCount then
      self._wishSlot[index].icon:SetShow(false)
    end
  end
end
function Panel_Window_InstallationMode_House_info:updateItemContent(initflag)
  self:setItemData(initflag)
  self:setItemScroll()
  self:setItemSlot()
end
function Panel_Window_InstallationMode_House_info:updateWishContent()
  self:setWishData()
  self:setWishScroll()
  self:setWishSlot()
end
function Panel_Window_InstallationMode_House_info:setTitle(isMyHouse)
  if true == isMyHouse then
    self._ui.staticText_Title_Top:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TEXT_PANELTITLE1"))
  else
    self._ui.staticText_Title_Top:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_TEXT_PANELTITLE1") .. PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_HAPPYYOU"))
  end
end
function Panel_Window_InstallationMode_House_info:readyToExit()
  PaGlobalFunc_HousingName_InitializeModeClose_PetMaidInit()
  PaGlobalFunc_InstallationMode_HousePoint_Exit()
end
function Panel_Window_InstallationMode_House_info:open()
  Panel_House_InstallationMode:SetShow(true)
end
function Panel_Window_InstallationMode_House_info:close()
  _AudioPostEvent_SystemUiForXBOX(1, 33)
  Panel_House_InstallationMode:SetShow(false)
end
function PaGlobalFunc_InstallationMode_House_GetShow()
  return Panel_House_InstallationMode:GetShow()
end
function PaGlobalFunc_InstallationMode_House_Open()
  local self = Panel_Window_InstallationMode_House_info
  self:open()
end
function PaGlobalFunc_InstallationMode_House_Close()
  local self = Panel_Window_InstallationMode_House_info
  self:close()
end
function PaGlobalFunc_InstallationMode_House_Show()
  local self = Panel_Window_InstallationMode_House_info
  self:initValue()
  self._value.isMyHouse = PaGlobalFunc_InstallationMode_Manager_GetMyHouse()
  self:setTab()
  self:setKeyGuideBottom()
  self:setKeyGuide(self._mode_Type_Enum.InstallMode_None)
  self:setList()
  self:setTitle(self._value.isMyHouse)
  self:updateItemContent(true)
  self:updateWishContent()
  PaGlobalFunc_InstallationMode_HousePoint_Show()
  PaGlobalFunc_InstallationMode_HousePoint_ShowFloor(true)
  self:open()
end
function PaGlobalFunc_InstallationMode_House_Exit()
  local self = Panel_Window_InstallationMode_House_info
  self:readyToExit()
  self:close()
end
function PaGlobalFunc_InstallationMode_House_UpdatePerFrame(deltaTime)
  local self = Panel_Window_InstallationMode_House_info
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
function PaGlobalFunc_InstallationMode_House_UpdateItem()
  local self = Panel_Window_InstallationMode_House_info
  self:updateItemContent()
end
function PaGlobalFunc_InstallationMode_House_UpdateWish()
  local self = Panel_Window_InstallationMode_House_info
  self:updateWishContent()
end
function PaGlobalFunc_InstallationMode_House_ToogleTab(value)
  _AudioPostEvent_SystemUiForXBOX(51, 6)
  local self = Panel_Window_InstallationMode_House_info
  local newTabIndex = self._value.currentTabIndex + self._menu_Top_Enum.Count + value
  newTabIndex = newTabIndex % self._menu_Top_Enum.Count
  self._value.currentTabIndex = newTabIndex
  self:setTab(newTabIndex)
  PaGlobalFunc_InstallationMode_House_HideTooltip()
end
function PaGlobalFunc_InstallationMode_House_FilterList(list_content, key)
  local self = Panel_Window_InstallationMode_House_info
  local id = Int64toInt32(key)
  local button = UI.getChildControl(list_content, "Button_List_ButtonTemplete")
  local icon = UI.getChildControl(button, "Static_ListIconTemplete")
  button:SetText(self._menu_Category_String[id])
  local x1, y1, x2, y2 = setTextureUV_Func(icon, self._menu_Category_Texture[id][1], self._menu_Category_Texture[id][2], self._menu_Category_Texture[id][3], self._menu_Category_Texture[id][4])
  icon:getBaseTexture():setUV(x1, y1, x2, y2)
  icon:setRenderTexture(icon:getBaseTexture())
  button:addInputEvent("Mouse_On", "PaGlobalFunc_InstallationMode_House_OnSubCategory()")
  button:addInputEvent("Mouse_LUp", "PaGlobalFunc_InstallationMode_House_CliclkSubCategory(" .. id .. ")")
end
function PaGlobalFunc_InstallationMode_House_installFurniture(invenType, invenSlotNo, iscash, productNo)
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
function PaGlobalFunc_InstallationMode_House_showToolTip(showFlating, invenType, invenSlotNo, slot_Idx, stringNum)
  local itemWrapper = getInventoryItemByType(invenType, invenSlotNo)
  local self = Panel_Window_InstallationMode_House_info
  local slot = self._itemSlot[slot_Idx]
  if nil == slot then
    return
  end
  local slotBGControl = self._itemSlot[slot_Idx].icon
  if false == showFlating then
    PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemWrapper, itemWrapper, Defines.TooltipTargetType.ItemWithoutCompare, self._ui.static_House_InstallationMode_Right:GetPosX())
    PaGlobalFunc_FloatingTooltip_Close()
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  PaGlobalFunc_FloatingTooltip_Open(Defines.TooltipDataType.ItemWrapper, itemWrapper, Defines.TooltipTargetType.Item, slotBGControl)
  self:setKeyGuideBottom(stringNum)
end
function PaGlobalFunc_InstallationMode_House_CashItemShowToolTip(showFlating, productNoRaw, slot_Idx)
  local cPSSW = ToClient_GetCashProductStaticStatusWrapperByKeyRaw(productNoRaw)
  local itemSSW = cPSSW:getItemByIndex(0)
  local self = Panel_Window_InstallationMode_House_info
  local slot = self._itemSlot[slot_Idx]
  local slotBGControl = self._itemSlot[slot_Idx].icon
  if nil == itemSSW then
    return
  end
  if false == showFlating then
    PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemSSWrapper, itemSSW, Defines.TooltipTargetType.ItemWithoutCompare, self._ui.static_House_InstallationMode_Right:GetPosX())
    PaGlobalFunc_FloatingTooltip_Close()
    return
  end
  PaGlobalFunc_FloatingTooltip_Open(Defines.TooltipDataType.ItemSSWrapper, itemSSW, Defines.TooltipTargetType.Item, slotBGControl)
  self:setKeyGuideBottom(self._panelKeyGuideEnum.Select)
end
function PaGlobalFunc_InstallationMode_House_showInstalledItemToolTip(showFlating, invenSlotNo, slot_Idx)
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  local itemSSW = houseWrapper:getCurrentItemEnchantStatStaticWrapper(invenSlotNo)
  if nil == itemSSW then
    return
  end
  local self = Panel_Window_InstallationMode_House_info
  local slot = self._itemSlot[slot_Idx]
  local slotBGControl = self._itemSlot[slot_Idx].icon
  if false == showFlating then
    PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemSSWrapper, itemSSW, Defines.TooltipTargetType.ItemWithoutCompare, self._ui.static_House_InstallationMode_Right:GetPosX())
    PaGlobalFunc_FloatingTooltip_Close()
    return
  end
  PaGlobalFunc_FloatingTooltip_Open(Defines.TooltipDataType.ItemSSWrapper, itemSSW, Defines.TooltipTargetType.Item, slotBGControl)
  self:setKeyGuideBottom(self._panelKeyGuideEnum.Select)
end
function PaGlobalFunc_InstallationMode_House_SelectInstalledObject(idx)
  if Panel_Win_System:GetShow() then
    return
  end
  local self = Panel_Window_InstallationMode_House_info
  if housing_isTemporaryObject() and self._mode_Type_Enum.InstallMode_None == self._value.currentMode then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_DELETEOBJECT_ACK"))
    return
  end
  _AudioPostEvent_SystemUiForXBOX(50, 1)
  ToClient_Select_FromInstallationList(idx)
end
function PaGlobalFunc_InstallationMode_House_ScrollItem(isUpScroll)
  local self = Panel_Window_InstallationMode_House_info
  self:updateItemScroll(isUpScroll)
end
function PaGlobalFunc_InstallationMode_House_ScrollWish(isUpScroll)
  local self = Panel_Window_InstallationMode_House_info
  self:updateWishScroll(isUpScroll)
end
function PaGlobalFunc_InstallationMode_House_OnSubCategory()
  local self = Panel_Window_InstallationMode_House_info
  self:setKeyGuideBottom(self._panelKeyGuideEnum.Select)
end
function PaGlobalFunc_InstallationMode_House_CliclkSubCategory(filter)
  local self = Panel_Window_InstallationMode_House_info
  self:setSubCategory(filter)
end
function PaGlobalFunc_InstallationMode_House_ClickConfirm()
  local self = Panel_Window_InstallationMode_House_info
  if self._value.currentMode ~= self._mode_Type_Enum.InstallMode_WatingConfirm then
    return
  end
  if housing_isInstallMode() then
    local doit = function()
      housing_InstallObject()
      PaGlobalFunc_InstallationMode_House_UpdateItem()
      PaGlobalFunc_InstallationMode_House_UpdateWish()
      PaGlobalFunc_InstallationMode_Manager_InitInput()
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
          functionNo = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageboxData)
        return
      end
    end
    _AudioPostEvent_SystemUiForXBOX(50, 1)
    doit()
  else
    PaGlobalFunc_InstallationMode_Manager_Exit()
  end
end
function PaGlobalFunc_InstallationMode_House_ClickMove()
  housing_moveObject()
end
function PaGlobalFunc_InstallationMode_House_ClickDelete()
  housing_deleteObject()
  PaGlobalFunc_InstallationMode_House_UpdateWish()
end
function PaGlobalFunc_InstallationMode_House_ClickWishSlot(slotIndex)
  housing_clearShoppingBasketItemByIndex(slotIndex)
  PaGlobalFunc_InstallationMode_House_UpdateWish()
  PaGlobalFunc_InstallationMode_House_HideTooltip()
end
function PaGlobalFunc_InstallationMode_House_ClickCancel()
  housing_CancelInstallObject()
  PaGlobalFunc_InstallationMode_House_UpdateWish()
end
function PaGlobalFunc_InstallationMode_House_CanGetInput()
  local self = Panel_Window_InstallationMode_House_info
  return self._value.currentMode ~= self._mode_Type_Enum.InstallMode_None
end
function PaGlobalFunc_InstallationMode_House_BuyItemAll()
  local buyCartDo = function()
    _AudioPostEvent_SystemUiForXBOX(50, 1)
    housing_buyShoppinBasketItems()
  end
  local messageBoxMemo = ""
  if getSelfPlayer():get():isMyHouseVisiting() then
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_CART_BUYITEMALL_MSGMEMO1")
  else
    messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSE_INSTALLATIONMODE_CART_BUYITEMALL_MSGMEMO2")
  end
  local messageBoxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
    content = messageBoxMemo,
    functionYes = buyCartDo,
    functionNo = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function PaGlobalFunc_InstallationMode_House_FocusSlot(isOn, isWish, index)
  local self = Panel_Window_InstallationMode_House_info
  if true == isWish then
    self:focusWishItem(isOn, index)
  else
    self:focusItem(isOn, index)
  end
end
function PaGlobalFunc_InstallationMode_House_HideTooltip()
  PaGlobalFunc_TooltipInfo_Close()
  PaGlobalFunc_FloatingTooltip_Close()
end
function FromClient_InstallationMode_House_Init()
  local self = Panel_Window_InstallationMode_House_info
  self:initialize()
end
function FromClient_InstallationMode_Resize_House_Renew()
  local self = Panel_Window_InstallationMode_House_info
  self:resize()
end
function FromClient_ShowInstallationMenu_House_Renew(installMode, isShow, isShowMove, isShowFix, isShowDelete, isShowCancel)
  local posX = housing_getInstallationMenuPosX()
  local posY = housing_getInstallationMenuPosY()
  local self = Panel_Window_InstallationMode_House_info
  self._value.isCanMove = isShowMove
  self._value.isCanDelete = isShowDelete
  if true == isShow then
    self:setKeyGuide(installMode, isShowMove, isShowFix, isShowDelete, isShowCancel)
  else
    self:setKeyGuide(installMode)
  end
  self:updateWishContent()
end
function FromClient_InstallationMode_UpdateInventory_House_Renew()
  local self = Panel_Window_InstallationMode_House_info
  if false == PaGlobalFunc_InstallationMode_House_GetShow() then
    return
  end
  self:updateItemContent(true)
  self:updateWishContent()
end
function FromClient_InstallationMode_UpdateInstallationActor_House_Renew(isAdd)
  local self = Panel_Window_InstallationMode_House_info
  if false == PaGlobalFunc_InstallationMode_House_GetShow() then
    return
  end
  self:updateItemContent(true)
  self:updateWishContent()
end
function FromClient_EventHousingPointUpdate_House_Renew()
  PaGlobalFunc_InstallationMode_HousePoint_UpdatePoint()
end
function FromClient_ChangeHousingInstallMode_House_Renew(preMode, nowMode)
  local self = Panel_Window_InstallationMode_House_info
  self._value.currentMode = nowMode
  if self._mode_Type_Enum.InstallMode_None == self._value.currentMode then
    self:setKeyGuide(self._value.currentMode)
  elseif self._mode_Type_Enum.InstallMode_Translation == self._value.currentMode then
    self:setKeyGuide(self._value.currentMode)
  end
  if self._mode_Type_Enum.InstallMode_None == self._value.currentMode then
    Panel_House_InstallationMode:ignorePadSnapUpdate(false)
    Panel_Window_InstallationMode_HousePoint:ignorePadSnapUpdate(false)
    self._ui.static_BottomBg:SetShow(true)
  else
    Panel_House_InstallationMode:ignorePadSnapUpdate(true)
    Panel_Window_InstallationMode_HousePoint:ignorePadSnapUpdate(true)
    self._ui.static_BottomBg:SetShow(false)
  end
end
function FromClient_changePadCameraControlMode_House_Renew(canZoom)
  local self = Panel_Window_InstallationMode_House_info
  self:setKeyGuide(self._value.currentMode)
end
registerEvent("FromClient_luaLoadComplete", "FromClient_InstallationMode_House_Init")

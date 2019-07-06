local _panel = Panel_Worldmap_HouseManagement
local UI_TM = CppEnums.TextMode
Panel_Worldmap_HouseManagement:ignorePadSnapMoveToOtherPanel()
local eHouseUseGroupType = CppEnums.eHouseUseType
local WorldMapHouseManager = {
  _ui = {
    stc_BG = UI.getChildControl(_panel, "Static_BG_House"),
    stc_KeyGudideBg = UI.getChildControl(_panel, "Static_KeyGuideBg"),
    txt_title = nil,
    stc_tipBG = nil,
    stc_tipUsageIcon = nil,
    txt_tipIcon = nil,
    txt_tipDesc = nil,
    stc_typeBG = nil,
    frame_houseType = nil,
    stc_houseTypeContentBG = nil,
    rdo_houseTypeTemplate = nil,
    rdo_houseTypes = nil,
    stc_stars = nil,
    txt_detailTitle = nil,
    stc_line = nil,
    txt_descriptions = nil,
    stc_itemSlotBG = nil,
    stc_detailBG = nil,
    scroll_detailList = nil,
    itemSlots = {},
    txt_manage = nil,
    stc_manageBG = nil,
    txt_manageTitle = nil,
    stc_normalBG = nil,
    txt_normalNeedPoint = nil,
    txt_normalNeedPointVal = nil,
    txt_normalMyPoint = nil,
    txt_normalMyPointVal = nil,
    txt_normalTimeCost = nil,
    txt_normalTimeCostVal = nil,
    txt_normalSilverCost = nil,
    txt_normalSilverCostVal = nil,
    txt_normalMySilver = nil,
    txt_normalMySilverVal = nil,
    btn_upgradeOrChange = nil,
    stc_processingBG = nil,
    txt_processingTimeLeft = nil,
    txt_processingTimeLeftVal = nil,
    txt_processingProgress = nil,
    txt_processingProgressVal = nil,
    progress_bar = nil,
    stc_houseImage = nil,
    chk_buyOrSell = nil
  },
  _houseInfoSSWrapper = nil,
  _houseInfoSS = nil,
  _houseKey = nil,
  _isUsable = nil,
  _feature1 = nil,
  _feature2 = nil,
  _screenShotPath = nil,
  _isSalable = nil,
  _isPurchasable = nil,
  _needExplorePoint = nil,
  _isSet = nil,
  _receipeCount = nil,
  _houseName = nil,
  _needTime = nil,
  _selected = nil,
  _useTypeData = {},
  _isProcessing = nil,
  _rentedLevel = nil,
  _rentedUseType = nil,
  _isRentedHouse = nil,
  _starCountMax = 5,
  _houseTypeMax = 8,
  _listDefaultYGap = 37,
  _listStartY = 4,
  _detailListData = {},
  _detailListScrollAmount = 0,
  _detailListRowMax = 3,
  _receipeIconColumnMax = 6,
  _receipeIconCountMax = 18,
  _receipeIconDefaultGap = 50,
  _purposeFliterUVConfig = {
    [0] = {
      x1 = 57,
      y1 = 319,
      x2 = 84,
      y2 = 346
    },
    [1] = {
      x1 = 85,
      y1 = 319,
      x2 = 112,
      y2 = 346
    },
    [2] = {
      x1 = 29,
      y1 = 319,
      x2 = 56,
      y2 = 346
    },
    [3] = {
      x1 = 337,
      y1 = 319,
      x2 = 364,
      y2 = 346
    },
    [4] = {
      x1 = 29,
      y1 = 347,
      x2 = 56,
      y2 = 374
    },
    [5] = {
      x1 = 57,
      y1 = 347,
      x2 = 84,
      y2 = 374
    },
    [6] = {
      x1 = 85,
      y1 = 347,
      x2 = 112,
      y2 = 374
    },
    [7] = {
      x1 = 113,
      y1 = 347,
      x2 = 140,
      y2 = 374
    },
    [8] = {
      x1 = 309,
      y1 = 347,
      x2 = 336,
      y2 = 374
    },
    [9] = {
      x1 = 141,
      y1 = 347,
      x2 = 168,
      y2 = 374
    },
    [10] = {
      x1 = 113,
      y1 = 319,
      x2 = 140,
      y2 = 346
    },
    [11] = {
      x1 = 309,
      y1 = 347,
      x2 = 336,
      y2 = 374
    },
    [12] = {
      x1 = 309,
      y1 = 319,
      x2 = 336,
      y2 = 346
    },
    [13] = {
      x1 = 337,
      y1 = 347,
      x2 = 364,
      y2 = 374
    },
    [14] = {
      x1 = 309,
      y1 = 319,
      x2 = 336,
      y2 = 346
    },
    [15] = {
      x1 = 197,
      y1 = 347,
      x2 = 224,
      y2 = 374
    },
    [18] = {
      x1 = 281,
      y1 = 319,
      x2 = 308,
      y2 = 346
    },
    [19] = {
      x1 = 1,
      y1 = 347,
      x2 = 28,
      y2 = 374
    },
    [20] = {
      x1 = 253,
      y1 = 347,
      x2 = 280,
      y2 = 374
    },
    [21] = {
      x1 = 225,
      y1 = 347,
      x2 = 252,
      y2 = 374
    },
    [23] = {
      x1 = 85,
      y1 = 347,
      x2 = 112,
      y2 = 374
    },
    [24] = {
      x1 = 1,
      y1 = 319,
      x2 = 28,
      y2 = 346
    },
    [16] = {
      x1 = 141,
      y1 = 347,
      x2 = 168,
      y2 = 374
    },
    [17] = {
      x1 = 0,
      y1 = 0,
      x2 = 0,
      y2 = 0
    },
    [22] = {
      x1 = 0,
      y1 = 0,
      x2 = 0,
      y2 = 0
    }
  },
  _purposeFilterUVConfigForOther = {
    [22] = {
      x1 = 141,
      y1 = 347,
      x2 = 168,
      y2 = 374
    },
    [23] = {
      x1 = 141,
      y1 = 347,
      x2 = 168,
      y2 = 374
    },
    [24] = {
      x1 = 141,
      y1 = 347,
      x2 = 168,
      y2 = 374
    },
    [26] = {
      x1 = 141,
      y1 = 347,
      x2 = 168,
      y2 = 374
    },
    [27] = {
      x1 = 141,
      y1 = 347,
      x2 = 168,
      y2 = 374
    },
    [1401] = {
      x1 = 169,
      y1 = 347,
      x2 = 196,
      y2 = 374
    },
    [1402] = {
      x1 = 169,
      y1 = 347,
      x2 = 196,
      y2 = 374
    },
    [1403] = {
      x1 = 169,
      y1 = 347,
      x2 = 196,
      y2 = 374
    },
    [1404] = {
      x1 = 169,
      y1 = 347,
      x2 = 196,
      y2 = 374
    },
    [1405] = {
      x1 = 169,
      y1 = 347,
      x2 = 196,
      y2 = 374
    },
    [1406] = {
      x1 = 169,
      y1 = 347,
      x2 = 196,
      y2 = 374
    },
    [1501] = {
      x1 = 197,
      y1 = 319,
      x2 = 224,
      y2 = 346
    },
    [1504] = {
      x1 = 197,
      y1 = 319,
      x2 = 224,
      y2 = 346
    },
    [1507] = {
      x1 = 197,
      y1 = 319,
      x2 = 224,
      y2 = 346
    },
    [1510] = {
      x1 = 197,
      y1 = 319,
      x2 = 224,
      y2 = 346
    },
    [1513] = {
      x1 = 197,
      y1 = 319,
      x2 = 224,
      y2 = 346
    },
    [1516] = {
      x1 = 197,
      y1 = 319,
      x2 = 224,
      y2 = 346
    },
    [1502] = {
      x1 = 225,
      y1 = 319,
      x2 = 252,
      y2 = 346
    },
    [1505] = {
      x1 = 225,
      y1 = 319,
      x2 = 252,
      y2 = 346
    },
    [1508] = {
      x1 = 225,
      y1 = 319,
      x2 = 252,
      y2 = 346
    },
    [1511] = {
      x1 = 225,
      y1 = 319,
      x2 = 252,
      y2 = 346
    },
    [1514] = {
      x1 = 225,
      y1 = 319,
      x2 = 252,
      y2 = 346
    },
    [1517] = {
      x1 = 225,
      y1 = 319,
      x2 = 252,
      y2 = 346
    },
    [1503] = {
      x1 = 253,
      y1 = 319,
      x2 = 280,
      y2 = 346
    },
    [1506] = {
      x1 = 253,
      y1 = 319,
      x2 = 280,
      y2 = 346
    },
    [1509] = {
      x1 = 253,
      y1 = 319,
      x2 = 280,
      y2 = 346
    },
    [1512] = {
      x1 = 253,
      y1 = 319,
      x2 = 280,
      y2 = 346
    },
    [1515] = {
      x1 = 253,
      y1 = 319,
      x2 = 280,
      y2 = 346
    },
    [1518] = {
      x1 = 253,
      y1 = 319,
      x2 = 280,
      y2 = 346
    },
    [1551] = {
      x1 = 141,
      y1 = 319,
      x2 = 168,
      y2 = 346
    },
    [1553] = {
      x1 = 141,
      y1 = 319,
      x2 = 168,
      y2 = 346
    },
    [1552] = {
      x1 = 169,
      y1 = 319,
      x2 = 196,
      y2 = 346
    },
    [1554] = {
      x1 = 169,
      y1 = 319,
      x2 = 196,
      y2 = 346
    }
  },
  _progressType = -1,
  _currentSlotInfo = {
    _slotIndex = 0,
    _index = 0,
    _itemIndex = 0
  },
  _currentTooltipSlot = -1,
  _currentHouseButton = nil,
  _isOpenFromFilter = false,
  _keyGuideAlign = {}
}
local _slotOption = {createIcon = true}
local _starUV = {
  full = {
    248,
    24,
    269,
    45
  },
  empty = {
    248,
    2,
    269,
    23
  }
}
function FromClient_luaLoadComplete_WorldMapHouseManager()
  WorldMapHouseManager:initialize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_luaLoadComplete_WorldMapHouseManager")
function WorldMapHouseManager:initialize()
  self._ui.txt_title = UI.getChildControl(self._ui.stc_BG, "StaticText_Title")
  self._ui.stc_tipBG = UI.getChildControl(self._ui.stc_BG, "Static_Tip")
  self._ui._static_KeyGuide_Select = UI.getChildControl(self._ui.stc_KeyGudideBg, "StaticText_A_ConsoleUI")
  self._ui._static_KeyGuide_Close = UI.getChildControl(self._ui.stc_KeyGudideBg, "StaticText_B_ConsoleUI")
  self._keyGuideAlign = {
    self._ui._static_KeyGuide_Select,
    self._ui._static_KeyGuide_Close
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui.stc_KeyGudideBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self._ui.txt_tipIcon = UI.getChildControl(self._ui.stc_tipBG, "StaticText_Icon")
  self._ui.stc_tipUsageIcon = UI.getChildControl(self._ui.stc_tipBG, "Static_UsageIcon")
  self._originalTextSpanY = self._ui.txt_tipIcon:GetTextSpan().x
  self._ui.txt_tipDesc = UI.getChildControl(self._ui.stc_tipBG, "StaticText_Desc")
  self._ui.txt_tipDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_tipDesc:SetText(self._ui.txt_tipDesc:GetText())
  self._ui.stc_typeBG = UI.getChildControl(self._ui.stc_BG, "Static_Type")
  self._ui.frame_houseType = UI.getChildControl(self._ui.stc_typeBG, "Frame_HouseType")
  local frameContent = self._ui.frame_houseType:GetFrameContent()
  self._ui.stc_houseTypeContentBG = UI.getChildControl(frameContent, "Static_ContentBG")
  self._ui.rdo_houseTypes = {}
  for ii = 1, self._houseTypeMax do
    self._ui.rdo_houseTypes[ii] = UI.getChildControl(frameContent, "RadioButton_Content_" .. ii)
    self._ui.rdo_houseTypes[ii]:SetPosY(self._listStartY + (ii - 1) * self._listDefaultYGap)
    self._ui.rdo_houseTypes[ii]:addInputEvent("Mouse_LUp", "Input_WorldMapHouseManager_SetUseType(" .. ii .. ")")
    self._ui.rdo_houseTypes[ii]:addInputEvent("Mouse_On", "Input_WorldMapHouseManager_SetSelectButton(" .. ii .. ")")
    self._ui.rdo_houseTypes[ii]:addInputEvent("Mouse_Out", "Input_WorldMapHouseManager_SetSelectButton(-1)")
    self._ui.rdo_houseTypes[ii]:SetShow(false)
  end
  self._ui.stc_stars = {}
  for ii = 1, self._houseTypeMax do
    self._ui.stc_stars[ii] = {}
    for jj = 1, self._starCountMax do
      self._ui.stc_stars[ii][jj] = UI.getChildControl(self._ui.rdo_houseTypes[ii], "Static_Star_" .. jj)
    end
  end
  self._ui.frame_houseType:UpdateContentPos()
  self._ui.frame_houseType:UpdateContentScroll()
  self._ui.stc_houseTypeContentBG:SetSize(frameContent:GetSizeX(), frameContent:GetSizeY())
  self:initDetailList()
  self._ui.txt_manage = UI.getChildControl(self._ui.stc_BG, "StaticText_Manage")
  self._ui.stc_manageBG = UI.getChildControl(self._ui.stc_BG, "Static_Manage")
  self._ui.txt_manageTitle = UI.getChildControl(self._ui.stc_manageBG, "StaticText_Title")
  self._ui.stc_normalBG = UI.getChildControl(self._ui.stc_manageBG, "Static_Normal")
  self._ui.txt_normalNeedPoint = UI.getChildControl(self._ui.stc_normalBG, "StaticText_Need_Point")
  self._ui.txt_normalNeedPointVal = UI.getChildControl(self._ui.stc_normalBG, "StaticText_Need_Point_Val")
  self._ui.txt_normalMyPoint = UI.getChildControl(self._ui.stc_normalBG, "StaticText_My_Point")
  self._ui.txt_normalMyPointVal = UI.getChildControl(self._ui.stc_normalBG, "StaticText_My_Point_Val")
  self._ui.txt_normalTimeCost = UI.getChildControl(self._ui.stc_normalBG, "StaticText_Time")
  self._ui.txt_normalTimeCostVal = UI.getChildControl(self._ui.stc_normalBG, "StaticText_Time_Val")
  self._ui.txt_normalSilverCost = UI.getChildControl(self._ui.stc_normalBG, "StaticText_Cost")
  self._ui.txt_normalSilverCostVal = UI.getChildControl(self._ui.stc_normalBG, "StaticText_Cost_Val")
  self._ui.txt_normalMySilver = UI.getChildControl(self._ui.stc_normalBG, "StaticText_Silver")
  self._ui.txt_normalMySilverVal = UI.getChildControl(self._ui.stc_normalBG, "StaticText_Silver_Val")
  self._ui.btn_upgradeOrChange = UI.getChildControl(self._ui.stc_normalBG, "Button_UpgradeOrChange")
  self._ui.btn_upgradeOrChange:addInputEvent("Mouse_On", "PaGlobalFunc_WorldMapHouseManager_SetDetailFocus(false)")
  self._ui.btn_upgradeOrChange:addInputEvent("Mouse_LUp", "Input_WorldMapHouseManager_UpgradeOrChange()")
  self._ui.stc_processingBG = UI.getChildControl(self._ui.stc_manageBG, "Static_Progress")
  self._ui.txt_processingTimeLeft = UI.getChildControl(self._ui.stc_processingBG, "StaticText_Time_Left")
  self._ui.txt_processingTimeLeftVal = UI.getChildControl(self._ui.stc_processingBG, "StaticText_Time_Left_Val")
  self._ui.txt_processingProgress = UI.getChildControl(self._ui.stc_processingBG, "StaticText_Progress")
  self._ui.txt_processingProgressVal = UI.getChildControl(self._ui.stc_processingBG, "StaticText_Progress_Val")
  self._ui.progress_bar = UI.getChildControl(self._ui.stc_processingBG, "Progress2_Bar")
  self._ui.stc_houseImage = UI.getChildControl(self._ui.stc_manageBG, "static_House_Image")
  self._ui.chk_buyOrSell = UI.getChildControl(self._ui.stc_manageBG, "Button_Confirm")
  self._ui.chk_buyOrSell:addInputEvent("Mouse_On", "PaGlobalFunc_WorldMapHouseManager_SetDetailFocus(false)")
  self._ui.btn_CraftManage = UI.getChildControl(self._ui.stc_manageBG, "Button_CraftManage")
  self._ui.btn_CraftManage:addInputEvent("Mouse_LUp", "Input_WorldMapHouseManager_CraftManage()")
  self._ui.txt_detailTitle:addInputEvent("Mouse_On", "PaGlobalFunc_WorldMapHouseManager_SetDetailFocus(true)")
  self._ui.txt_detailTitle:addInputEvent("Mouse_Out", "PaGlobalFunc_WorldMapHouseManager_SetDetailFocus(false)")
end
function WorldMapHouseManager:initDetailList()
  self._ui.stc_line = UI.getChildControl(self._ui.stc_typeBG, "Static_Line")
  self._ui.stc_detailBG = UI.getChildControl(self._ui.stc_typeBG, "Static_DetailListBG")
  self._ui.txt_detailTitle = UI.getChildControl(self._ui.stc_detailBG, "StaticText_DetailTitle")
  self._ui.txt_detailTitle:SetAutoResize(true)
  self._ui.scroll_detailList = UI.getChildControl(self._ui.stc_detailBG, "Scroll_DetailList")
  self._ui.scroll_ctrlButton = UI.getChildControl(self._ui.scroll_detailList, "Frame_1_VerticalScroll_CtrlButton")
  UIScroll.InputEvent(self._ui.scroll_detailList, "InputScroll_WorldMapHouseManager_DetailList")
  self._ui.txt_descriptions = {}
  local startX, startY = self._ui.stc_line:GetPosX(), self._ui.stc_line:GetPosY() + 25
  for ii = 1, self._detailListRowMax do
    self._ui.txt_descriptions[ii] = UI.createAndCopyBasePropertyControl(self._ui.stc_detailBG, "StaticText_DescTemplete", self._ui.stc_detailBG, "StaticText_DescTemplete_" .. ii)
    self._ui.txt_descriptions[ii]:SetPosX(20)
    self._ui.txt_descriptions[ii]:SetPosY(startY + (ii - 1) * self._receipeIconDefaultGap)
  end
  self._ui.stc_itemSlotBG = {}
  for ii = 1, self._receipeIconCountMax do
    self._ui.stc_itemSlotBG[ii] = UI.createAndCopyBasePropertyControl(self._ui.stc_detailBG, "Static_ItemSlotBgTemplete", self._ui.stc_detailBG, "Static_ItemSlotBgTemplete" .. ii)
    self._ui.stc_itemSlotBG[ii]:SetPosX(20 + (ii - 1) % self._receipeIconColumnMax * self._receipeIconDefaultGap)
    self._ui.stc_itemSlotBG[ii]:SetPosY(startY - 12 + math.floor((ii - 1) / self._receipeIconColumnMax) * self._receipeIconDefaultGap)
  end
  self:registMessageHandler()
  self:registEvent()
end
function WorldMapHouseManager:registEvent()
  _panel:RegisterUpdateFunc("PaGlobalFunc_WorldMapHouseManager_UpdatePerFrame")
end
function WorldMapHouseManager:registMessageHandler()
  registerEvent("FromClient_ReceiveBuyHouse", "FromClient_WorldMapHouseManager_ReceiveBuyHouse")
  registerEvent("FromClient_ReceiveReturnHouse", "FromClient_WorldMapHouseManager_ReceiveReturnHouse")
  registerEvent("FromClient_ReceiveChangeUseType", "FromClient_WorldMapHouseManager_ReceiveChangeUseType")
  registerEvent("FromClient_AppliedChangeUseType", "FromClient_WorldMapHouseManager_AppliedChangeUseType")
  registerEvent("WorldMap_WorkerDataUpdateByHouse", "FromClient_WorldMapHouseManager_WorkerDataUpdateByHouse")
end
function PaGlobalFunc_WorldMapHouseManager_SetDetailFocus(isFocus)
  local self = WorldMapHouseManager
  self._ui.scroll_ctrlButton:SetShow(isFocus)
  self._ui._static_KeyGuide_Select:SetShow(not isFocus)
end
function FromClient_WorldMapHouseManager_WorkerDataUpdateByHouse(rentHouseWrapper)
  local self = WorldMapHouseManager
  local houseInfoSSWrapper = rentHouseWrapper:getStaticStatus()
  PaGlobalFunc_WorldMapHouseManager_RefreshHouse(houseInfoSSWrapper)
  if false == PaGlobalFunc_WorldMapHouseManager_IsShow() then
    return
  end
  local currentRentHouse = ToClient_GetRentHouseWrapper(self._houseKey)
  if currentRentHouse ~= rentHouseWrapper then
    return
  end
  self:update(houseInfoSSWrapper)
end
function PaGlobalFunc_WorldMapHouseManager_UpdatePerFrame(deltaTime)
  local self = WorldMapHouseManager
  if -1 == self._progressType then
    return
  end
  self:updateWorkingState(self._progressType)
end
function PaGlobalFunc_WorldMapHouseManager_IsShow()
  return _panel:GetShow()
end
function PaGlobalFunc_WorldMapHouseManager_Close()
  local self = WorldMapHouseManager
  PaGlobalFunc_WorldMapHouseManager_HideTooltip()
  if true == self._isOpenFromFilter then
    PaGlobalFunc_WorldMap_RightMenu_OpenHouseFilter()
  else
    PaGlobalFunc_WorldMap_TopMenu_Open()
    PaGlobalFunc_WorldMap_RingMenu_Open()
  end
  _panel:SetShow(false)
end
function PaGlobalFunc_WorldMapHouseManager_CloseByCraftManage()
  PaGlobalFunc_WorldMapHouseManager_HideTooltip()
  _panel:SetShow(false)
end
function PaGlobalFunc_WorldMapHouseManager_Open(houseBtn, isFilter)
  local self = WorldMapHouseManager
  if nil ~= houseBtn then
    self._currentHouseButton = houseBtn
  end
  if nil ~= isFilter then
    self._isOpenFromFilter = isFilter
  end
  WorldMapHouseManager:open(self._currentHouseButton:FromClient_getStaticStatus())
end
function WorldMapHouseManager:open(houseInfoSSWrapper)
  self._selected = nil
  self._ui.chk_buyOrSell:SetIgnore(false)
  self:lateInit()
  self:update(houseInfoSSWrapper)
  _panel:SetShow(true)
end
function WorldMapHouseManager:lateInit()
end
function WorldMapHouseManager:ResetAlign()
  self._ui.txt_tipIcon:SetTextSpan(0, self._originalTextSpanY)
  self._ui.txt_tipIcon:SetTextMode(CppEnums.TextMode.eTextMode_None)
end
function WorldMapHouseManager:update(houseInfoSSWrapper)
  local houseInfoSS = houseInfoSSWrapper:get()
  self._houseInfoSS = houseInfoSSWrapper:get()
  self._houseKey = houseInfoSSWrapper:getHouseKey()
  self._screenShotPath = ToClient_getScreenShotPath(houseInfoSS, 0)
  self._isSalable = houseInfoSSWrapper:isSalable()
  self._isPurchasable = houseInfoSSWrapper:isPurchasable()
  self._needExplorePoint = houseInfoSSWrapper:getNeedExplorePoint()
  self._isSet = houseInfoSSWrapper:isSet()
  self._receipeCount = houseInfoSSWrapper:getReceipeCount()
  self._houseName = houseInfoSSWrapper:getName()
  self._ui.stc_houseImage:ChangeTextureInfoName(self._screenShotPath)
  self._ui.frame_houseType:GetVScroll():SetControlPos(0)
  self._ui.frame_houseType:UpdateContentPos()
  self:updateTypeList(houseInfoSSWrapper)
  local rentHouse = ToClient_GetRentHouseWrapper(self._houseKey)
  local stc_stars = {}
  for ii = 1, #self._ui.rdo_houseTypes do
    for jj = 1, self._starCountMax do
      stc_stars[jj] = UI.getChildControl(self._ui.rdo_houseTypes[ii], "Static_Star_" .. jj)
      stc_stars[jj]:ChangeTextureInfoName("renewal/ui_icon/console_icon_worldmap_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(stc_stars[jj], _starUV.empty[1], _starUV.empty[2], _starUV.empty[3], _starUV.empty[4])
      stc_stars[jj]:getBaseTexture():setUV(x1, y1, x2, y2)
      stc_stars[jj]:setRenderTexture(stc_stars[jj]:getBaseTexture())
    end
  end
  self._ui.btn_upgradeOrChange:SetShow(false)
  self._ui.txt_normalTimeCost:SetShow(true)
  self._ui.chk_buyOrSell:SetMonoTone(false)
  self._ui.chk_buyOrSell:SetIgnore(false)
  if nil ~= rentHouse and true == rentHouse:isSet() then
    self:updateRentedHouse(rentHouse, houseInfoSSWrapper)
  else
    self:updateEmptyHouse(houseInfoSSWrapper)
  end
  self:updateDetailList()
  self:updateBottomBox()
  self._ui.txt_title:SetText(self._houseName)
end
function WorldMapHouseManager:updateTypeList(houseInfoSSWrapper)
  if nil == houseInfoSSWrapper then
    return
  end
  if false == houseInfoSSWrapper:isSet() then
    return
  end
  local rentHouseWrapper = ToClient_GetRentHouseWrapper(self._houseKey)
  local frameContent = self._ui.frame_houseType:GetFrameContent()
  self._useTypeData = {}
  for ii = 1, self._houseTypeMax do
    if nil == self._ui.rdo_houseTypes[ii] then
      self._ui.rdo_houseTypes[ii] = UI.cloneControl(self._ui.rdo_houseTypeTemplate, frameContent, "RadioButton_HouseType_" .. ii)
    end
    if ii <= self._receipeCount then
      local houseInfoCraftWrapper = houseInfoSSWrapper:getHouseCraftWrapperByIndex(ii - 1)
      self._useTypeData[ii] = {}
      self._useTypeData[ii].receipeKey = houseInfoSSWrapper:getReceipeByIndex(ii - 1)
      self._useTypeData[ii].useType = houseInfoSSWrapper:getGroupTypeByIndex(ii - 1)
      self._useTypeData[ii].useTypeDesc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_USETYPE_DESC_EMPTY")
      if self._useTypeData[ii].useType > -1 then
        self._useTypeData[ii].useTypeDesc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_USETYPE_DESC_" .. tostring(self._useTypeData[ii].useType))
      end
      self._useTypeData[ii].name = houseInfoCraftWrapper:getReciepeName()
      local txt_name = UI.getChildControl(self._ui.rdo_houseTypes[ii], "StaticText_Name")
      txt_name:SetText(self._useTypeData[ii].name)
      txt_name:ChangeTextureInfoName("renewal/ui_icon/console_icon_worldmap_00.dds")
      local x1, y1, x2, y2
      if 17 ~= self._useTypeData[ii].useType and 16 ~= self._useTypeData[ii].useType then
        x1, y1, x2, y2 = setTextureUV_Func(txt_name, WorldMapHouseManager._purposeFliterUVConfig[self._useTypeData[ii].useType].x1, WorldMapHouseManager._purposeFliterUVConfig[self._useTypeData[ii].useType].y1, WorldMapHouseManager._purposeFliterUVConfig[self._useTypeData[ii].useType].x2, WorldMapHouseManager._purposeFliterUVConfig[self._useTypeData[ii].useType].y2)
      else
        x1, y1, x2, y2 = setTextureUV_Func(txt_name, WorldMapHouseManager._purposeFilterUVConfigForOther[self._useTypeData[ii].receipeKey].x1, WorldMapHouseManager._purposeFilterUVConfigForOther[self._useTypeData[ii].receipeKey].y1, WorldMapHouseManager._purposeFilterUVConfigForOther[self._useTypeData[ii].receipeKey].x2, WorldMapHouseManager._purposeFilterUVConfigForOther[self._useTypeData[ii].receipeKey].y2)
      end
      txt_name:getBaseTexture():setUV(x1, y1, x2, y2)
      txt_name:setRenderTexture(txt_name:getBaseTexture())
      self._useTypeData[ii].maxLevel = houseInfoCraftWrapper:getLevel()
      for jj = 1, self._starCountMax do
        if jj <= self._useTypeData[ii].maxLevel then
          self._ui.stc_stars[ii][jj]:SetShow(true)
        else
          self._ui.stc_stars[ii][jj]:SetShow(false)
        end
      end
      self._ui.rdo_houseTypes[ii]:SetShow(true)
    else
      self._ui.rdo_houseTypes[ii]:SetShow(false)
    end
  end
  frameContent:SetSize(frameContent:GetSizeX(), self._receipeCount * (self._ui.rdo_houseTypes[1]:GetSizeY() + self._listStartY))
  self._ui.stc_houseTypeContentBG:SetSize(frameContent:GetSizeX(), frameContent:GetSizeY())
  local scroll = self._ui.frame_houseType:GetVScroll()
  if frameContent:GetSizeY() > self._ui.frame_houseType:GetSizeY() then
    scroll:SetShow(true)
  else
    scroll:SetShow(false)
  end
end
function WorldMapHouseManager:updateRentedHouse(rentHouse, houseInfoStaticStatusWrapper)
  self._rentedLevel = rentHouse:getLevel()
  self._currentGroupType = rentHouse:getHouseUseType()
  self._rentedUseType = rentHouse:getType()
  self._isRentedHouse = true
  self._ui.txt_normalTimeCost:SetShow(false)
  self._ui.btn_upgradeOrChange:SetShow(true)
  local rentedIndex
  if false == ToClient_IsMyLiveHouse(self._houseKey) and eHouseUseGroupType.Empty == self._currentGroupType then
    self._currentGroupType = eHouseUseGroupType.Count
  end
  for ii = 1, #self._useTypeData do
    if self._rentedUseType == self._useTypeData[ii].receipeKey then
      rentedIndex = ii
      WorldMapHouseManager:ResetAlign()
      self._ui.txt_tipIcon:SetText(self._useTypeData[rentedIndex].name)
      if self._ui.txt_tipIcon:GetSizeX() < self._ui.txt_tipIcon:GetTextSizeX() then
        self._ui.txt_tipIcon:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
        self._ui.txt_tipIcon:SetTextSpan(0, self._originalTextSpanY)
      else
        self._ui.txt_tipIcon:SetTextSpan(0, 15)
      end
      self._ui.txt_tipIcon:SetText(self._useTypeData[rentedIndex].name)
      if nil == self._selected then
        Input_WorldMapHouseManager_SetUseType(ii)
        break
      end
    end
  end
  local rentType = rentHouse:getType()
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_USETYPE_DESC_EMPTY")
  if rentType > -1 then
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_USETYPE_DESC_" .. tostring(rentType))
  end
  self._ui.txt_tipDesc:SetText(desc)
  local stc_stars = {}
  for ii = 1, self._starCountMax do
    stc_stars[ii] = UI.getChildControl(self._ui.rdo_houseTypes[rentedIndex], "Static_Star_" .. ii)
    stc_stars[ii]:ChangeTextureInfoName("renewal/ui_icon/console_icon_worldmap_00.dds")
    if ii <= self._rentedLevel then
      local x1, y1, x2, y2 = setTextureUV_Func(stc_stars[ii], _starUV.full[1], _starUV.full[2], _starUV.full[3], _starUV.full[4])
      stc_stars[ii]:getBaseTexture():setUV(x1, y1, x2, y2)
      stc_stars[ii]:setRenderTexture(stc_stars[ii]:getBaseTexture())
    else
      local x1, y1, x2, y2 = setTextureUV_Func(stc_stars[ii], _starUV.empty[1], _starUV.empty[2], _starUV.empty[3], _starUV.empty[4])
      stc_stars[ii]:getBaseTexture():setUV(x1, y1, x2, y2)
      stc_stars[ii]:setRenderTexture(stc_stars[ii]:getBaseTexture())
    end
  end
  self._ui.txt_tipIcon:SetColor(Defines.Color.C_FF000000)
  local icon = self._ui.stc_tipUsageIcon
  icon:SetShow(true)
  icon:ChangeTextureInfoName("renewal/ui_icon/console_icon_worldmap_00.dds")
  local x1, y1, x2, y2
  if 17 ~= self._useTypeData[rentedIndex].useType and 16 ~= self._useTypeData[rentedIndex].useType then
    x1, y1, x2, y2 = setTextureUV_Func(icon, WorldMapHouseManager._purposeFliterUVConfig[self._useTypeData[rentedIndex].useType].x1, WorldMapHouseManager._purposeFliterUVConfig[self._useTypeData[rentedIndex].useType].y1, WorldMapHouseManager._purposeFliterUVConfig[self._useTypeData[rentedIndex].useType].x2, WorldMapHouseManager._purposeFliterUVConfig[self._useTypeData[rentedIndex].useType].y2)
  else
    x1, y1, x2, y2 = setTextureUV_Func(icon, WorldMapHouseManager._purposeFilterUVConfigForOther[self._useTypeData[rentedIndex].receipeKey].x1, WorldMapHouseManager._purposeFilterUVConfigForOther[self._useTypeData[rentedIndex].receipeKey].y1, WorldMapHouseManager._purposeFilterUVConfigForOther[self._useTypeData[rentedIndex].receipeKey].x2, WorldMapHouseManager._purposeFilterUVConfigForOther[self._useTypeData[rentedIndex].receipeKey].y2)
  end
  icon:getBaseTexture():setUV(x1, y1, x2, y2)
  icon:setRenderTexture(icon:getBaseTexture())
  self:setSellButton(houseInfoStaticStatusWrapper)
end
function WorldMapHouseManager:setSellButton(houseInfoStaticStatusWrapper)
  if houseInfoStaticStatusWrapper:isSalable() then
    self._ui.chk_buyOrSell:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_RENEW_RETURN"))
    self._ui.chk_buyOrSell:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorldMapHouseManager_SellHouse(true)")
  else
    self._ui.chk_buyOrSell:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_HOUSECONTROL_BTN_CANTSELL"))
    self._ui.chk_buyOrSell:addInputEvent("Mouse_LUp", "Input_WorldMapHouseManager_SellCondition(true)")
  end
  self._ui.txt_normalNeedPoint:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_WITHDRAWEXPLORE"))
end
function WorldMapHouseManager:updateEmptyHouse(houseInfoSSWrapper)
  self._rentedUseType = -1
  self._rentedLevel = 0
  self._rentedUseType = eHouseUseGroupType.Count
  self._isRentedHouse = false
  WorldMapHouseManager:ResetAlign()
  self._ui.txt_tipIcon:SetTextSpan(0, 15)
  self._ui.txt_tipIcon:SetColor(Defines.Color.C_FFFFFFFF)
  self._ui.txt_tipIcon:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_TYPENAME_EMPTYHOUSE"))
  self._ui.txt_tipDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_USETYPE_DESC_EMPTY"))
  self._ui.stc_tipUsageIcon:SetShow(false)
  if nil == self._selected then
    Input_WorldMapHouseManager_SetUseType(1)
  end
  self:setBuyButton(houseInfoSSWrapper)
end
function WorldMapHouseManager:setBuyButton(houseInfoSSWrapper)
  local isPurchasable = houseInfoSSWrapper:isPurchasable(self._useTypeData[self._selected].useType)
  if isPurchasable and self._needExplorePoint <= ToClient_RequestGetMyExploredPoint() then
    self._ui.chk_buyOrSell:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_RENEW_RENT"))
    self._ui.chk_buyOrSell:addInputEvent("Mouse_LUp", "Input_WorldMapHouseManager_Buy()")
  elseif isPurchasable and self._needExplorePoint > ToClient_RequestGetMyExploredPoint() then
    self._ui.chk_buyOrSell:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_HOUSECONTROL_BTN_LOWPOINT"))
    self._ui.chk_buyOrSell:SetMonoTone(true)
    self._ui.chk_buyOrSell:SetIgnore(true)
  else
    self._ui.chk_buyOrSell:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_HOUSECONTROL_BTN_CANTBUY"))
    self._ui.chk_buyOrSell:addInputEvent("Mouse_LUp", "Input_WorldMapHouseManager_BuyCondition()")
  end
  self._ui.txt_normalNeedPoint:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_NEEDEXPLORE"))
end
function WorldMapHouseManager:updateDetailList()
  self:updateDetailData()
  self._exchangeKeyList = {}
  for ii = 1, #self._ui.txt_descriptions do
    self._ui.txt_descriptions[ii]:SetShow(false)
  end
  for ii = 1, #self._ui.stc_itemSlotBG do
    self._ui.stc_itemSlotBG[ii]:SetShow(false)
  end
  local data = self._detailListData
  for ii = 1, self._detailListRowMax do
    local index = ii + self._detailListScrollAmount
    if nil ~= data[index] then
      if nil ~= data[index].desc then
        self._ui.txt_descriptions[ii]:SetShow(true)
        self._ui.txt_descriptions[ii]:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
        self._ui.txt_descriptions[ii]:SetText(data[index].desc)
        for jj = 1, self._receipeIconColumnMax do
          self._ui.stc_itemSlotBG[jj + (ii - 1) * self._receipeIconColumnMax]:SetShow(false)
        end
      elseif nil ~= data[index].itemIndexList then
        for jj = 1, self._receipeIconColumnMax do
          local slotIndex = jj + (ii - 1) * self._receipeIconColumnMax
          local slotBG = self._ui.stc_itemSlotBG[slotIndex]
          slotBG:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "")
          slotBG:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "")
          if 1 == ii then
            slotBG:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "InputScroll_WorldMapHouseManager_DetailList(true)")
          end
          if 2 == ii then
            if nil ~= data[index - 1] and nil ~= data[index - 1].desc then
              slotBG:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "InputScroll_WorldMapHouseManager_DetailList(true)")
            end
            if nil ~= data[index + 1] and nil ~= data[index + 1].desc then
              slotBG:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "InputScroll_WorldMapHouseManager_DetailList(false)")
            end
          end
          if self._detailListRowMax == ii then
            slotBG:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "InputScroll_WorldMapHouseManager_DetailList(false)")
          end
          if nil ~= data[index].itemIndexList[jj] then
            slotBG:SetShow(true)
            local esSSW = ToClient_getHouseDataWorkableItemExchangeByIndex(data[index].itemIndexList[jj])
            if esSSW:isSet() then
              local esSS = esSSW:get()
              local workIcon = "icon/" .. esSSW:getIcon()
              local itemStatic = esSS:getFirstDropGroup():getItemStaticStatus()
              local itemKey = esSS:getFirstDropGroup()._itemKey
              local staticStatusWrapper = getItemEnchantStaticStatus(itemKey)
              if nil ~= staticStatusWrapper then
                if nil == self._ui.itemSlots[slotIndex] then
                  self._ui.itemSlots[slotIndex] = {}
                  local slot = self._ui.itemSlots[slotIndex]
                  SlotItem.new(slot, "DetailSlot_" .. slotIndex, slotIndex, slotBG, _slotOption)
                  slot:createChild()
                  UIScroll.InputEventByControl(slot.icon, "InputScroll_WorldMapHouseManager_DetailList")
                  self._exchangeKeyList[slotIndex] = data[index].itemIndexList[jj]
                  self._ui.itemSlots[slotIndex] = slot
                end
                self._ui.itemSlots[slotIndex].icon:addInputEvent("Mouse_On", "PaGlobalFunc_WorldMapHouseManager_ShowTooltip(" .. slotIndex .. "," .. index .. "," .. jj .. ")")
                self._ui.itemSlots[slotIndex].icon:addInputEvent("Mouse_Out", "PaGlobalFunc_WorldMapHouseManager_HideTooltip(" .. slotIndex .. ")")
                self._ui.itemSlots[slotIndex]:setItemByStaticStatus(staticStatusWrapper)
              end
            end
          else
            slotBG:SetShow(false)
          end
        end
      end
    end
  end
  if #data <= self._detailListRowMax then
    self._ui.scroll_detailList:SetShow(false)
  else
    self._ui.scroll_detailList:SetShow(true)
  end
end
function PaGlobalFunc_WorldMapHouseManager_ShowTooltip(slotIndex, index, jj)
  local self = WorldMapHouseManager
  local uiBase = self._ui.itemSlots[slotIndex].icon
  local data = self._detailListData[index]
  local item = data.itemIndexList[jj]
  if nil == item then
    return
  end
  local esSSW = ToClient_getHouseDataWorkableItemExchangeByIndex(item)
  if esSSW:isSet() then
    local esSS = esSSW:get()
    local count = esSS:getDropGroupCount() - 1
    local itemKey = esSS:getDropGroupByIndex(count)._itemKey
    local staticStatusWrapper = getItemEnchantStaticStatus(itemKey)
    PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemSSWrapper, staticStatusWrapper, Defines.TooltipTargetType.Item, getScreenSizeX())
  end
  self._currentTooltipSlot = slotIndex
  self._currentSlotInfo._slotIndex = slotIndex
  self._currentSlotInfo._index = index
  self._currentSlotInfo._itemIndex = jj
  PaGlobalFunc_WorldMapHouseManager_SetDetailFocus(true)
end
function PaGlobalFunc_WorldMapHouseManager_HideTooltip(slotIndex)
  local self = WorldMapHouseManager
  if self._currentTooltipSlot == slotIndex then
    PaGlobalFunc_TooltipInfo_Close()
    self._currentTooltipSlot = -1
  end
end
function WorldMapHouseManager:updateDetailData()
  local houseInfoSSW = ToClient_GetHouseInfoStaticStatusWrapper(self._houseKey)
  local houseInfoCraftWrapper = houseInfoSSW:getHouseCraftWrapperByIndex(self._selected - 1)
  local maxLevel = self._useTypeData[self._selected].maxLevel
  local receipeKey = self._useTypeData[self._selected].receipeKey
  local houseUseType = self._useTypeData[self._selected].useType
  local workCount = ToClient_getHouseWorkableListByData(self._houseKey, receipeKey, maxLevel)
  self._detailListData = {}
  local data = self._detailListData
  if workCount < 1 then
    data.isCraft = false
    local rowNum = 1
    for ii = 1, maxLevel do
      data[ii] = {}
      data[ii].desc = ii .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEWORKLIST_HOUSE_LEVEL")
      if eHouseUseGroupType.Lodging == houseUseType then
        local workerCount = houseInfoSSW:getWorkerCount(ii)
        data[ii].desc = data[ii].desc .. " : " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_LODGING2", "workerCount", workerCount)
      elseif eHouseUseGroupType.Depot == houseUseType then
        local extendWarehouseCount = houseInfoSSW:getExtendWarehouseCount(ii)
        data[ii].desc = data[ii].desc .. " : " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_DEPOT2", "extendWarehouseCount", extendWarehouseCount)
      elseif eHouseUseGroupType.Ranch == houseUseType then
        local extendStableCount = houseInfoSSW:getExtendStableCount(ii)
        data[ii].desc = data[ii].desc .. " : " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_RANCH2", "extendStableCount", extendStableCount)
      else
        local desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_HELP_MYHOUSE")
        local stringList = string.split(desc, "\n")
        data[1].desc = ""
        data[2] = {}
        data[2].desc = stringList[1]
        data[3] = {}
        data[4] = {}
        data[5] = {}
        data[5].desc = stringList[2]
        data[6] = {}
        data[7] = {}
        data[8] = {}
        data[8].desc = stringList[3]
        data[9] = {}
        return
      end
    end
  else
    data.isCraft = true
    local levelTitleRow = 1
    local itemSlotRow = 1
    local itemIndexFromZero = 0
    local itemCountInLevel = {}
    for ii = 1, maxLevel do
      if nil == data[levelTitleRow] then
        data[levelTitleRow] = {}
      end
      data[levelTitleRow].desc = ii .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_HOUSEWORKLIST_HOUSE_LEVEL")
      itemCountInLevel[ii] = ToClient_getHouseWorkableListByDataOnlySize(receipeKey, ii, ii)
      local itemRowAmountInLevel = math.ceil(itemCountInLevel[ii] / self._receipeIconColumnMax) + 1
      itemSlotRow = levelTitleRow + 1
      levelTitleRow = levelTitleRow + itemRowAmountInLevel
      for jj = 1, itemCountInLevel[ii] do
        if nil == data[itemSlotRow] then
          data[itemSlotRow] = {}
        end
        if nil == data[itemSlotRow].itemIndexList then
          data[itemSlotRow].itemIndexList = {}
        end
        data[itemSlotRow].itemIndexList[(jj - 1) % self._receipeIconColumnMax + 1] = itemIndexFromZero
        itemIndexFromZero = itemIndexFromZero + 1
        if 0 == jj % self._receipeIconColumnMax then
          itemSlotRow = itemSlotRow + 1
        end
      end
    end
  end
end
function WorldMapHouseManager:updateBottomBox()
  local workingcnt = getWorkingListAtRentHouse(self._houseKey)
  local isUsable = ToClient_IsUsable(self._houseKey)
  local houseInfoSS = ToClient_GetHouseInfoStaticStatusWrapper(self._houseKey):get()
  local rentHouseWrapper = ToClient_GetRentHouseWrapper(self._houseKey)
  local isWorkable = true == ToClient_IsMyHouse(self._houseKey) and rentHouseWrapper:isSet() and true == ToClient_IsUsable(self._houseKey) and eHouseUseGroupType.ImproveWorkshop <= rentHouseWrapper:getType() and self._useTypeData[self._selected].receipeKey == rentHouseWrapper:getType()
  self._ui.btn_CraftManage:SetShow(isWorkable)
  local isLargeCraft = ToClient_getLargeCraftExchangeKeyRaw(houseInfoSS)
  self._ui.txt_processingTimeLeft:SetText(PAGetString(Defines.StringSheet_RESOURCE, "WORLDMAP_WOKRPROGRESS_TXT_REMAINTIME"))
  self._ui.txt_processingProgress:SetText(PAGetString(Defines.StringSheet_RESOURCE, "WORLDMAP_WOKRPROGRESS_TXT_PROGRESS_1"))
  local isNormalState = true
  if false == isUsable then
    if rentHouseWrapper:getType() == self._useTypeData[self._selected].receipeKey then
      self._progressType = eWorkType.changeHouseUseType
      isNormalState = false
    end
  elseif isLargeCraft > 0 then
    self._progressType = eWorkType.largeCraft
    isNormalState = false
    self:SetProgressStateByLargeCraft()
  elseif workingcnt > 0 and self._useTypeData[self._selected].receipeKey == rentHouseWrapper:getType() then
    self._progressType = eWorkType.craft
    isNormalState = false
  end
  self._ui.stc_normalBG:SetShow(isNormalState)
  self._ui.stc_processingBG:SetShow(not isNormalState)
  if true == isNormalState then
    self:updateBottomAsNormalState()
  end
end
function WorldMapHouseManager:SetProgressStateByLargeCraft()
  self._ui.txt_processingTimeLeft:SetText(PAGetString(Defines.StringSheet_RESOURCE, "WORLDMAP_WOKRPROGRESS_TXT_ONGOING"))
  self._ui.txt_processingProgress:SetText(PAGetString(Defines.StringSheet_RESOURCE, "WORLDMAP_WOKRPROGRESS_TXT_PROGRESS_2"))
  local rentHouse = ToClient_GetRentHouseWrapper(self._houseKey)
  local param = {
    _houseName = self._houseName,
    _useTypeName = self._useTypeData[self._selected].name,
    _useType_Desc = desc,
    _level = rentHouse:getLevel(),
    _useType = rentHouse:getType(),
    _houseKey = self._houseKey,
    _houseUseType = self._currentGroupType
  }
  local houseInfoSSW = ToClient_findHouseButtonByKey(self._houseKey):FromClient_getStaticStatus()
  local dataTable = PaGlobalFunc_WorldMap_HouseCraftLarge_GetCraftingdata(houseInfoSSW, param)
  local workingProgress = math.floor(dataTable._currentCount / dataTable._totalCount * 100)
  self._ui.progress_bar:SetProgressRate(workingProgress)
  self._ui.txt_processingProgressVal:SetText(dataTable._currentCount .. " / " .. dataTable._totalCount)
  self._ui.txt_processingTimeLeftVal:SetText(dataTable._sumProgressCount)
end
function WorldMapHouseManager:updateWorkingState(state)
  if eWorkType.changeHouseUseType == state then
    local remineTime = Util.Time.timeFormatting(ToClient_GetLeftTimeChangeHouseUseType(self._houseKey))
    local progressVal = ToClient_GetProgressRateChangeHouseUseType(self._houseKey)
    self._ui.txt_processingTimeLeftVal:SetText(remineTime)
    self._ui.txt_processingProgressVal:SetText(string.format("%3.1f%%", progressVal))
    self._ui.progress_bar:SetProgressRate(progressVal)
  elseif eWorkType.largeCraft == state then
  elseif eWorkType.craft == state then
    local workingcnt = getWorkingListAtRentHouse(self._houseKey)
    for index = 0, workingcnt - 1 do
      local worker = getWorkingByIndex(index).workerNo
      local workerNo = worker:get_s64()
      local workingProgress = getWorkingProgress(workerNo) * 100000
      local remainTime = Util.Time.timeFormatting(ToClient_getWorkingTime(workerNo))
      self._ui.progress_bar:SetProgressRate(workingProgress)
      self._ui.txt_processingProgressVal:SetText(string.format("%3.1f%%", workingProgress))
      self._ui.txt_processingTimeLeftVal:SetText(remainTime)
    end
  end
end
function WorldMapHouseManager:updateBottomAsNormalState()
  local houseInfoSSW = ToClient_GetHouseInfoStaticStatusWrapper(self._houseKey)
  local rentHouseWrapper = ToClient_GetRentHouseWrapper(self._houseKey)
  local isMyHouse = ToClient_IsMyHouse(self._houseKey)
  local isMaxLevel = false
  local isUsable = ToClient_IsUsable(self._houseKey)
  local currentUseType = self._useTypeData[self._selected].receipeKey
  local houseUseType
  local nextRentHouseLevel = 1
  if false == self._isSet then
    return
  end
  if true == isMyHouse and rentHouseWrapper:isSet() then
    isMaxLevel = rentHouseWrapper:isMaxLevel()
    houseUseType = rentHouseWrapper:getType()
    if currentUseType == houseUseType then
      if isUsable and false == isMaxLevel then
        nextRentHouseLevel = rentHouseWrapper:getLevel() + 1
      elseif false == isUsable then
        nextRentHouseLevel = rentHouseWrapper:getLevel()
      end
    end
  end
  local itemKey = {}
  local itemName = {}
  local itemCount = {}
  local listCount = 0
  if nil ~= nextRentHouseLevel then
    listCount = houseInfoSSW:getNeedItemListCount(currentUseType, nextRentHouseLevel)
  end
  for index = 0, listCount - 1 do
    itemKey[index] = houseInfoSSW:getNeedItemListItemKey(currentUseType, nextRentHouseLevel, index)
    itemName[index] = getItemEnchantStaticStatus(itemKey[index]):getName()
    itemCount[index] = Int64toInt32(houseInfoSSW:getNeedItemListItemCount(currentUseType, nextRentHouseLevel, index))
  end
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayer = selfPlayerWrapper:get()
  local inventory = selfPlayer:getInventory()
  local myMoney = Int64toInt32(inventory:getMoney_s64())
  local myMoneyDot = makeDotMoney(myMoney)
  self._ui.txt_normalMySilverVal:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_HAVEMONEY", "myMoney", myMoneyDot))
  if nil ~= itemCount[0] and nil ~= itemName[0] then
    if currentUseType == houseUseType and true == isMaxLevel and true == isUsable then
      self._ui.txt_normalSilverCostVal:SetText("--")
    else
      local needMoney = itemCount[0]
      if myMoney < needMoney then
        needMoney = "<PAColor0xFFDB2B2B>" .. makeDotMoney(needMoney) .. " " .. itemName[0] .. "<PAOldColor>"
      else
        needMoney = makeDotMoney(needMoney) .. " " .. itemName[0]
      end
      self._ui.txt_normalSilverCostVal:SetText(needMoney)
    end
  else
    self._ui.txt_normalSilverCostVal:SetText("--")
  end
  self._needTime = -1
  local needTime = "--"
  if currentUseType == houseUseType and true == isMaxLevel and true == isUsable then
    self._needTime = 0
  else
    self._needTime = houseInfoSSW:getTransperTime(currentUseType, nextRentHouseLevel, nextRentHouseLevel)
  end
  if 0 ~= self._needTime then
    needTime = Util.Time.timeFormatting(self._needTime)
  end
  self._ui.txt_normalTimeCostVal:SetText(needTime)
  self._ui.txt_normalNeedPointVal:SetText(self._needExplorePoint)
  self._ui.txt_normalMyPointVal:SetText(ToClient_RequestGetMyExploredPoint())
  self:updateBottomButtons()
end
function WorldMapHouseManager:updateBottomButtons()
  local selectedUseType = self._useTypeData[self._selected].receipeKey
  local houseInfoSSW = ToClient_GetHouseInfoStaticStatusWrapper(self._houseKey)
  local houseInfoCraftWrapper = houseInfoSSW:getHouseCraftWrapperByIndex(self._selected - 1)
  local rentHouseWrapper = ToClient_GetRentHouseWrapper(self._houseKey)
  local isMaxLevel
  self._isUsable = ToClient_IsUsable(self._houseKey)
  if nil ~= rentHouseWrapper then
    isMaxLevel = rentHouseWrapper:isMaxLevel()
  end
  if nil ~= houseInfoCraftWrapper and selectedUseType ~= self._rentedUseType then
    self._ui.btn_upgradeOrChange:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CHANGESTATE_TITLE_1") .. " : " .. houseInfoCraftWrapper:getReciepeName())
    self._ui.btn_upgradeOrChange:EraseAllEffect()
    self._ui.btn_upgradeOrChange:AddEffect("UI_ButtonLineRight_WhiteLong", false, -10, -3)
    self._ui.btn_upgradeOrChange:SetMonoTone(false)
    self._ui.btn_upgradeOrChange:SetIgnore(false)
  elseif true == self._isUsable and false == isMaxLevel and eHouseUseGroupType.Empty ~= self._currentUseType then
    self._ui.btn_upgradeOrChange:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_GRADEUP_TITLE") .. " : " .. houseInfoCraftWrapper:getReciepeName())
    self._ui.btn_upgradeOrChange:EraseAllEffect()
    self._ui.btn_upgradeOrChange:AddEffect("UI_ButtonLineRight_WhiteLong", false, -10, -3)
    self._ui.btn_upgradeOrChange:SetMonoTone(false)
    self._ui.btn_upgradeOrChange:SetIgnore(false)
  elseif true == self._isUsable and true == isMaxLevel then
    self._ui.btn_upgradeOrChange:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_BTN_MAXLEVEL_1"))
    self._ui.btn_upgradeOrChange:SetMonoTone(true)
    self._ui.btn_upgradeOrChange:SetIgnore(true)
  else
    self._ui.btn_upgradeOrChange:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_BTN_MAXLEVEL_2"))
    self._ui.btn_upgradeOrChange:SetMonoTone(true)
    self._ui.btn_upgradeOrChange:SetIgnore(true)
  end
end
function PaGlobalFunc_WorldMapHouseManager_SellHouse()
  local self = WorldMapHouseManager
  local houseInfoSS = self._houseInfoSS
  local workingcnt = ToClient_getHouseWorkingWorkerList(houseInfoSS)
  local returnPoint = self._needExplorePoint
  local houseName = self._houseName
  local function handleClickedHouseControlSellHouseContinue()
    local houseKey = self._houseKey
    ToClient_RequestReturnHouse(houseKey)
    PaGlobal_TutorialManager:handleClickedHouseControlSellHouseContinue(houseKey)
  end
  if false == ToClient_IsUsable(self._houseKey) then
    local sellHouseContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_ONCHANGEUSETYPE", "houseName", houseName) .. [[


]] .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_RETURNPOINT", "returnPoint", returnPoint)
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_TITLE"),
      content = sellHouseContent,
      functionYes = handleClickedHouseControlSellHouseContinue,
      functionCancel = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData, "top")
  elseif workingcnt > 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_ONCRAFT"))
    return
  else
    local sellHouseContent = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_DEFAULT", "houseName", houseName) .. [[


]] .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_RETURNPOINT", "returnPoint", returnPoint)
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_TITLE"),
      content = sellHouseContent,
      functionYes = handleClickedHouseControlSellHouseContinue,
      functionCancel = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData, "top")
  end
end
function Input_WorldMapHouseManager_Buy()
  local self = WorldMapHouseManager
  if nil == self._selected then
    return
  end
  if workerManager_CheckWorkingOtherChannelAndMsg() then
    return
  end
  if not self._houseKey then
    return
  end
  local SSW = ToClient_GetHouseInfoStaticStatusWrapper(self._houseKey)
  if false == SSW:isSet() then
    return
  end
  local nextRentHouseLevel = 1
  local receipeKey = self._useTypeData[self._selected].receipeKey
  local realIndex = SSW:getIndexByReceipeKey()
  local houseInfoCraftWrapper = SSW:getHouseCraftWrapperByIndex(realIndex)
  local listCount = SSW:getNeedItemListCount(receipeKey, nextRentHouseLevel)
  local needTime_sec = SSW:getTransperTime(receipeKey, nextRentHouseLevel, nextRentHouseLevel)
  local needExplorePoint = SSW:getNeedExplorePoint()
  local needTime = Util.Time.timeFormatting(needTime_sec)
  local houseName = self._houseName
  local useTypeName = houseInfoCraftWrapper:getReciepeName()
  local itemExplain = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_NEEDPOINT", "needPoint", needExplorePoint) .. "\n"
  for index = 0, listCount - 1 do
    local itemKey = SSW:getNeedItemListItemKey(receipeKey, nextRentHouseLevel, index)
    local itemName = getItemEnchantStaticStatus(itemKey):getName()
    local itemCount = SSW:getNeedItemListItemCount(receipeKey, nextRentHouseLevel, index)
    local needCost = makeDotMoney(Int64toInt32(itemCount)) .. " " .. itemName
    itemExplain = itemExplain .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_NEEDCOST", "needCost", needCost) .. "\n"
  end
  itemExplain = itemExplain .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_NEEDTIME", "needTime", needTime)
  itemExplain = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_BUYHOUSE_CONTENT", "houseName", houseName, "useTypeName", useTypeName) .. [[


]] .. itemExplain
  local function buyConfirmed()
    ToClient_RequestBuyHouse(self._houseKey, receipeKey, 1)
    PaGlobal_TutorialManager:handleClickedHouseControlBuyHouseContinue()
  end
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_BUYHOUSE_TITLE"),
    content = itemExplain,
    functionYes = buyConfirmed,
    functionCancel = MessageBox_Empty_function
  }
  MessageBox.showMessageBox(messageboxData, "top")
end
function Input_WorldMapHouseManager_SellCondition(isRefresh)
  local self = WorldMapHouseManager
  PaGlobalFunc_WorldMap_SellBuyHouse_Open(true)
end
function Input_WorldMapHouseManager_BuyCondition(isRefresh)
  local self = WorldMapHouseManager
  PaGlobalFunc_WorldMap_SellBuyHouse_Open(false)
end
function Input_WorldMapHouseManager_SetSelectButton(index)
  local self = WorldMapHouseManager
  self._ui.scroll_ctrlButton:SetShow(false)
  self._ui._static_KeyGuide_Select:SetShow(index ~= self._selected)
end
function Input_WorldMapHouseManager_SetUseType(index)
  local self = WorldMapHouseManager
  local houseInfoSSW = ToClient_GetHouseInfoStaticStatusWrapper(self._houseKey)
  if false == houseInfoSSW:isSet() then
    return
  end
  self._selected = index
  for ii = 1, #self._ui.rdo_houseTypes do
    self._ui.rdo_houseTypes[ii]:SetCheck(false)
  end
  self._ui.rdo_houseTypes[index]:SetCheck(true)
  self._ui.txt_manageTitle:SetText(self._useTypeData[index].name)
  self._ui.txt_manageTitle:ChangeTextureInfoName("renewal/ui_icon/console_icon_worldmap_00.dds")
  local x1, y1, x2, y2
  if 17 ~= self._useTypeData[index].useType and 16 ~= self._useTypeData[index].useType then
    x1, y1, x2, y2 = setTextureUV_Func(self._ui.txt_manageTitle, WorldMapHouseManager._purposeFliterUVConfig[self._useTypeData[index].useType].x1, WorldMapHouseManager._purposeFliterUVConfig[self._useTypeData[index].useType].y1, WorldMapHouseManager._purposeFliterUVConfig[self._useTypeData[index].useType].x2, WorldMapHouseManager._purposeFliterUVConfig[self._useTypeData[index].useType].y2)
  else
    x1, y1, x2, y2 = setTextureUV_Func(self._ui.txt_manageTitle, WorldMapHouseManager._purposeFilterUVConfigForOther[self._useTypeData[index].receipeKey].x1, WorldMapHouseManager._purposeFilterUVConfigForOther[self._useTypeData[index].receipeKey].y1, WorldMapHouseManager._purposeFilterUVConfigForOther[self._useTypeData[index].receipeKey].x2, WorldMapHouseManager._purposeFilterUVConfigForOther[self._useTypeData[index].receipeKey].y2)
  end
  self._ui.txt_manageTitle:getBaseTexture():setUV(x1, y1, x2, y2)
  self._ui.txt_manageTitle:setRenderTexture(self._ui.txt_manageTitle:getBaseTexture())
  self._detailListScrollAmount = 0
  self._ui.scroll_detailList:SetControlPos(0)
  self:updateDetailList()
  self:updateBottomBox()
  local maxLevel = self._useTypeData[self._selected].maxLevel
  local receipeKey = self._useTypeData[self._selected].receipeKey
  local workCount = ToClient_getHouseWorkableListByData(self._houseKey, receipeKey, maxLevel)
  if workCount < 1 then
    self._ui.txt_detailTitle:SetIgnore(false)
  else
    self._ui.txt_detailTitle:SetIgnore(true)
  end
  self._ui.frame_houseType:GetVScroll():SetControlPos(0)
  self._ui.frame_houseType:UpdateContentPos()
  self._ui.scroll_detailList:SetControlPos(0)
  self._ui.scroll_ctrlButton:SetShow(false)
  Input_WorldMapHouseManager_SetSelectButton(index)
  local rentHouse = ToClient_GetRentHouseWrapper(self._houseKey)
  if nil ~= rentHouse and true == rentHouse:isSet() then
  else
    self:setBuyButton(self._currentHouseButton:FromClient_getStaticStatus())
  end
end
function InputScroll_WorldMapHouseManager_DetailList(isUp)
  local self = WorldMapHouseManager
  local prevScrollAmount = self._detailListScrollAmount
  if false == self._ui.scroll_ctrlButton:GetShow() then
    return
  end
  self._detailListScrollAmount = UIScroll.ScrollEvent(self._ui.scroll_detailList, isUp, self._detailListRowMax, #self._detailListData, self._detailListScrollAmount, 1)
  if prevScrollAmount ~= self._detailListScrollAmount then
    self:updateDetailList()
    ToClient_padSnapIgnoreGroupMove()
    local index = self._currentSlotInfo._index
    if true == isUp then
      index = self._currentSlotInfo._index - 1
    else
      index = self._currentSlotInfo._index + 1
    end
    local data = self._detailListData[index]
    if nil == data then
      return
    end
    if nil ~= data.desc then
      return
    end
    if 0 == self._useTypeData[self._selected].useType then
      return
    end
    PaGlobalFunc_WorldMapHouseManager_HideTooltip()
    PaGlobalFunc_WorldMapHouseManager_ShowTooltip(self._currentSlotInfo._slotIndex, index, self._currentSlotInfo._itemIndex)
  end
end
function PaGlobalFunc_WorldMapHouseManager_ChangeStateHouseContinue()
  local self = WorldMapHouseManager
  local rentHouseWrapper = ToClient_GetRentHouseWrapper(self._houseKey)
  local useType = rentHouseWrapper:getType()
  local level = 1
  if useType == self._useTypeData[self._selected].receipeKey and eHouseUseGroupType.Count ~= self._currentGroupType then
    level = rentHouseWrapper:getLevel() + 1
  end
  ToClient_RequestChangeHouseUseType(self._houseKey, self._useTypeData[self._selected].receipeKey, level)
end
function Input_WorldMapHouseManager_CraftManage()
  local self = WorldMapHouseManager
  if false == ToClient_IsUsable(self._houseKey) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CHANGESTATE_MESSAGE"))
    return
  end
  local rentHouse = ToClient_GetRentHouseWrapper(self._houseKey)
  local rentType = rentHouse:getType()
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_USETYPE_DESC_EMPTY")
  if rentType > -1 then
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_USETYPE_DESC_" .. tostring(rentType))
  end
  local param = {
    _houseName = self._houseName,
    _useTypeName = self._useTypeData[self._selected].name,
    _useType_Desc = desc,
    _level = rentHouse:getLevel(),
    _useType = rentHouse:getType(),
    _houseKey = self._houseKey,
    _houseUseType = self._currentGroupType
  }
  local houseInfoSSW = ToClient_findHouseButtonByKey(self._houseKey):FromClient_getStaticStatus()
  if self._currentGroupType == 12 or self._currentGroupType == 13 or self._currentGroupType == 14 then
    PaGlobalFunc_WorldMap_HouseCraftLarge_Open(houseInfoSSW, param)
  else
    PaGlobalFunc_WorldMap_HouseCraft_Open(houseInfoSSW, param)
  end
  PaGlobalFunc_WorldMapHouseManager_CloseByCraftManage()
end
function Input_WorldMapHouseManager_UpgradeOrChange()
  local self = WorldMapHouseManager
  local rentHouseWrapper = ToClient_GetRentHouseWrapper(self._houseKey)
  local houseInfoStaticStatusWrapper = rentHouseWrapper:getStaticStatus()
  local rentedReceipeKey = rentHouseWrapper:getType()
  local nextRentHouseLevel = 1
  local selectedUseType = self._useTypeData[self._selected].receipeKey
  if selectedUseType == rentedReceipeKey and eHouseUseGroupType.Count ~= self._currentGroupType then
    nextRentHouseLevel = rentHouseWrapper:getLevel() + 1
  end
  local realIndex = houseInfoStaticStatusWrapper:getIndexByReceipeKey(selectedUseType)
  local houseInfoCraftWrapper = houseInfoStaticStatusWrapper:getHouseCraftWrapperByIndex(realIndex)
  local targetUseTypeName = houseInfoCraftWrapper:getReciepeName()
  realIndex = houseInfoStaticStatusWrapper:getIndexByReceipeKey(rentedReceipeKey)
  houseInfoCraftWrapper = houseInfoStaticStatusWrapper:getHouseCraftWrapperByIndex(realIndex)
  local currentUseTypeName = houseInfoCraftWrapper:getReciepeName()
  local rentHouseLevel = rentHouseWrapper:getLevel()
  local listCount = houseInfoStaticStatusWrapper:getNeedItemListCount(selectedUseType, nextRentHouseLevel)
  local needTime = Util.Time.timeFormatting(houseInfoStaticStatusWrapper:getTransperTime(selectedUseType, nextRentHouseLevel, nextRentHouseLevel))
  local itemExplain = ""
  for index = 0, listCount - 1 do
    local itemKey = houseInfoStaticStatusWrapper:getNeedItemListItemKey(selectedUseType, nextRentHouseLevel, index)
    local itemName = getItemEnchantStaticStatus(itemKey):getName()
    local itemCount = houseInfoStaticStatusWrapper:getNeedItemListItemCount(selectedUseType, nextRentHouseLevel, index)
    itemExplain = itemExplain .. itemName .. " " .. Int64toInt32(itemCount) .. PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_COUNT") .. "\n"
  end
  itemExplain = itemExplain .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_NEEDTIME", "needTime", needTime)
  local workingcnt = ToClient_getHouseWorkingWorkerList(houseInfoStaticStatusWrapper:get())
  local _title = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CHANGESTATE_TITLE_1")
  if false == ToClient_IsUsable(self._houseKey) then
    itemExplain = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CHANGESTATE_CONTENT_1", "currentTypeName", currentUseTypeName, "targetTypeName", targetUseTypeName) .. [[


]] .. itemExplain
  elseif workingcnt > 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CHANGESTATE_CONTENT_2"))
    return
  elseif targetUseTypeName == currentUseTypeName then
    itemExplain = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CHANGESTATE_CONTENT_4", "currentTypeName", currentUseTypeName, "rentHouseLevel", rentHouseLevel, "nextLevel", rentHouseLevel + 1) .. [[


]] .. itemExplain
    _title = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CHANGESTATE_TITLE_2")
  else
    itemExplain = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_CHANGESTATE_CONTENT_3", "currentTypeName", currentUseTypeName, "targetTypeName", targetUseTypeName) .. [[


]] .. itemExplain
  end
  local messageboxData = {
    title = _title,
    content = itemExplain,
    functionYes = PaGlobalFunc_WorldMapHouseManager_ChangeStateHouseContinue,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData, "top")
end
function FromClient_WorldMapHouseManager_ReceiveChangeUseType(houseInfoSSWrapper, hasPreviouseHouse)
  local self = WorldMapHouseManager
  self._progressType = -1
  PaGlobalFunc_WorldMapHouseManager_RefreshHouse(houseInfoSSWrapper)
  if self._houseKey == houseInfoSSWrapper:getHouseKey() then
    self:update(houseInfoSSWrapper)
  end
  local rentHouse = ToClient_GetRentHouseWrapper(houseInfoSSWrapper:getHouseKey())
  local eHouseUseGroupType = CppEnums.eHouseUseType
  local _currentGroupType = eHouseUseGroupType.Count
  if nil ~= rentHouse and true == rentHouse:isSet() then
    _currentGroupType = rentHouse:getHouseUseType()
  end
  if _currentGroupType == eHouseUseGroupType.Empty then
    FGlobal_MiniGame_HouseControl_Empty()
    if true == hasPreviouseHouse then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CHANGE_HOUSE_USETYPE_MYHOUSE"))
    end
  end
  if _currentGroupType == eHouseUseGroupType.Depot then
    FGlobal_MiniGame_HouseControl_Depot()
  end
  if _currentGroupType == eHouseUseGroupType.Refinery then
    FGlobal_MiniGame_HouseControl_Refinery()
  end
  if _currentGroupType == eHouseUseGroupType.LocalSpecailtiesWorkshop then
    FGlobal_MiniGame_HouseControl_LocalSpecailtiesWorkshop()
  end
  if _currentGroupType == eHouseUseGroupType.Shipyard then
    FGlobal_MiniGame_HouseControl_Shipyard()
  end
end
function FromClient_WorldMapHouseManager_ReceiveReturnHouse(houseInfoSSWrapper)
  local self = WorldMapHouseManager
  PaGlobalFunc_WorldMapHouseManager_RefreshHouse(houseInfoSSWrapper)
  PaGlobalFunc_WorldMap_SellBuyHouse_DataUpdate(self._houseKey)
  if self._houseKey == houseInfoSSWrapper:getHouseKey() then
    self:update(houseInfoSSWrapper)
  end
end
function FromClient_WorldMapHouseManager_AppliedChangeUseType(houseInfoSSWrapper)
  local self = WorldMapHouseManager
  PaGlobalFunc_WorldMapHouseManager_RefreshHouse(houseInfoSSWrapper)
  if self._houseKey ~= houseInfoSSWrapper:getHouseKey() then
    return
  end
  self._progressType = -1
  self:update(houseInfoSSWrapper)
end
function FromClient_WorldMapHouseManager_ReceiveBuyHouse(houseInfoSSWrapper)
  local self = WorldMapHouseManager
  PaGlobalFunc_WorldMapHouseManager_RefreshHouse(houseInfoSSWrapper)
  PaGlobalFunc_WorldMap_SellBuyHouse_DataUpdate(self._houseKey)
  if self._houseKey == houseInfoSSWrapper:getHouseKey() then
    self:update(houseInfoSSWrapper)
  end
end
function PaGlobalFunc_WorldMapHouseManager_RefreshHouse(houseInfoSSWrapper)
  if nil == houseInfoSSWrapper then
    return
  end
  PaGlobalFunc_WorldMapHouseManager_SetHouseTexture(houseInfoSSWrapper)
  local NextHouseCount = houseInfoSSWrapper:getNextHouseCount()
  for idx = 0, NextHouseCount - 1 do
    local NextHouseInfoStaticStatusWrapper = houseInfoSSWrapper:getNextHouseInfoStaticStatusWrapper(idx)
    PaGlobalFunc_WorldMapHouseManager_SetHouseTexture(NextHouseInfoStaticStatusWrapper)
  end
end
function PaGlobalFunc_WorldMapHouseManager_SetHouseTexture(houseInfoSSWrapper)
  if nil == houseInfoSSWrapper then
    return
  end
  local _houseKey = houseInfoSSWrapper:getHouseKey()
  local _houseBtn = ToClient_findHouseButtonByKey(_houseKey)
  FGlobal_HouseHoldButtonSetBaseTexture(_houseBtn)
end
function PaGlobalFunc_WorldMapHouseManager_GetCurrentHouseKey()
  local self = WorldMapHouseManager
  return self._houseKey
end
function PaGlobalFunc_WorldMapHouseManager_GetCurrentUseType()
  local self = WorldMapHouseManager
  return self._useTypeData[self._selected].receipeKey
end

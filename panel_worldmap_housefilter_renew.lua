local Window_WorldMap_HouseFilterInfo = {
  _ui = {
    _static_FilterBg = UI.getChildControl(Panel_Worldmap_HouseFilter, "Static_FilterBg"),
    _static_List2Bg = UI.getChildControl(Panel_Worldmap_HouseFilter, "Static_HouseListBg"),
    _static_BottomBg = UI.getChildControl(Panel_Worldmap_HouseFilter, "Static_BottomBg"),
    _purposeFilterList = {},
    _houseFilterList = {},
    _gradeFilterList = {},
    _gradeStar = {}
  },
  _houseFilterConfig = {
    _all = 0,
    _mine = 1,
    _buyPerpose = 2,
    _other = 3,
    _count = 4
  },
  _filterConfig = {
    _house = 0,
    _grade = 1,
    _purpose = 2,
    _mainFilter = 3
  },
  _houseFilterStrConfig = {
    [0] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_OWNERRFILTER_ALL"),
    [1] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_OWNERFIILTER_MINE"),
    [2] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_USETYPEFILTER"),
    [3] = PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_OWNERFILTER_OTHER")
  },
  _purposeFilterTexture = "renewal/ui_icon/console_icon_worldmap_00.dds",
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
    [16] = {
      x1 = 141,
      y1 = 347,
      x2 = 168,
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
      x1 = 0,
      y1 = 0,
      x2 = 0,
      y2 = 0
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
  _config = {
    _focusOut = -10,
    _gradeCount = 5,
    _purposeFilterStartPosY
  },
  _BOTTOMBUTTONPOSYLIMIT = 1060,
  _MINIMUMPUPOSEBGSPANY = 30,
  _currentNodeInfo,
  _currentFilterIndex = -1,
  _currentHouseFilterIndex = 0,
  _currentGradeFilterIndex = 0,
  _currentPurposeFilterIndex = -1,
  _currentPurposeFilterType = -1,
  _currnetHouseListIndex = 0,
  _houseListInfo = {},
  _prevScrollIndex = 0,
  _currentHouseButton = nil,
  _isOpenFromCraftManage = false,
  _keyGuideAlign = {}
}
function Window_WorldMap_HouseFilterInfo:Clear()
  self:UpdateHouseList()
end
function PaGlobalFunc_WorldMap_HouseFilter_SetCurrentNodeInfo(nodeInfo)
  local self = Window_WorldMap_HouseFilterInfo
  self._currentNodeInfo = nodeInfo
end
function Window_WorldMap_HouseFilterInfo:ClearPurposeFilter()
  for _, control in pairs(self._ui._purposeFilterList) do
    if nil ~= control then
      control._button:SetShow(false)
      control._icon:SetShow(false)
    end
  end
end
function PaGlobalFunc_WorldMap_HouseFilter_SetSelectButton(index, filterType)
  local self = Window_WorldMap_HouseFilterInfo
  local isShow = false
  if self._filterConfig._house == filterType then
    isShow = index ~= self._currentHouseFilterIndex
  elseif self._filterConfig._grade == filterType then
    isShow = index ~= self._currentGradeFilterIndex
  elseif self._filterConfig._purpose == filterType then
    isShow = index ~= self._currentPurposeFilterIndex
  elseif self._filterConfig._mainFilter == filterType then
    isShow = index ~= self._currentFilterIndex
  end
  self._ui._static_KeyGuide_Select:SetShow(isShow)
  if self._config._focusOut == index then
    self._ui._static_KeyGuide_Select:SetShow(true)
  end
end
function Window_WorldMap_HouseFilterInfo:SetPurposeFilter()
  local allFilter = self._ui._purposeFilterList[0]
  local resultPosY = 0
  if nil == allFilter then
    allFilter = {}
    local allButtonControl = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, self._ui._static_PurposeBg, "Radiobutton_Purpose_" .. 0)
    CopyBaseProperty(self._ui._purposeButtonTemplete, allButtonControl)
    allButtonControl:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorldMap_HouseFilter_SelectPurposeFilter(-1)")
    allButtonControl:addInputEvent("Mouse_On", "PaGlobalFunc_WorldMap_HouseFilter_SetSelectButton( -1 ," .. self._filterConfig._purpose .. ")")
    local allIconControl = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, allButtonControl, "button_Purpose_" .. 0)
    CopyBaseProperty(self._ui._purposeIconTemplete, allIconControl)
    allIconControl:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_OWNERRFILTER_ALL"))
    allButtonControl:SetPosY(allButtonControl:GetPosY())
    allButtonControl:SetShow(true)
    allIconControl:SetShow(true)
    allIconControl:ChangeTextureInfoName(self._purposeFilterTexture)
    local x1, y1, x2, y2 = setTextureUV_Func(allIconControl, self._purposeFliterUVConfig[24].x1, self._purposeFliterUVConfig[24].y1, self._purposeFliterUVConfig[24].x2, self._purposeFliterUVConfig[24].y2)
    allIconControl:getBaseTexture():setUV(x1, y1, x2, y2)
    allIconControl:setRenderTexture(allIconControl:getBaseTexture())
    allFilter._button = allButtonControl
    allFilter._icon = allIconControl
    self._ui._purposeFilterList[0] = allFilter
  end
  self._ui._purposeFilterList[0]._button:SetShow(true)
  self._ui._purposeFilterList[0]._icon:SetShow(true)
  local count = ToClient_getTownReceipeList()
  for index = 1, count do
    local filter = self._ui._purposeFilterList[index]
    if nil == filter then
      filter = {}
      local buttonControl = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_RADIOBUTTON, self._ui._static_PurposeBg, "Radiobutton_Purpose_" .. index)
      CopyBaseProperty(self._ui._purposeButtonTemplete, buttonControl)
      buttonControl:SetPosY(buttonControl:GetPosY() + buttonControl:GetSizeY() * index)
      local iconControl = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, buttonControl, "button_Purpose_" .. index)
      CopyBaseProperty(self._ui._purposeIconTemplete, iconControl)
      filter._button = buttonControl
      filter._icon = iconControl
    end
    filter._button:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorldMap_HouseFilter_SelectPurposeFilter(" .. index .. ")")
    filter._button:addInputEvent("Mouse_On", "PaGlobalFunc_WorldMap_HouseFilter_SetSelectButton(" .. index .. ", " .. self._filterConfig._purpose .. ")")
    filter._icon:SetText(ToClient_getReceipeName(ToClient_getReceipeTypeByIndex(index - 1)))
    local houseType = ToClient_getGroupType(ToClient_getReceipeTypeByIndex(index - 1))
    local houseTypeForOther = ToClient_getReceipeTypeByIndex(index - 1)
    filter._icon:ChangeTextureInfoName(self._purposeFilterTexture)
    local x1, y1, x2, y2
    if 17 ~= houseType and 16 ~= houseType then
      x1, y1, x2, y2 = setTextureUV_Func(filter._icon, self._purposeFliterUVConfig[houseType].x1, self._purposeFliterUVConfig[houseType].y1, self._purposeFliterUVConfig[houseType].x2, self._purposeFliterUVConfig[houseType].y2)
    else
      x1, y1, x2, y2 = setTextureUV_Func(filter._icon, self._purposeFilterUVConfigForOther[houseTypeForOther].x1, self._purposeFilterUVConfigForOther[houseTypeForOther].y1, self._purposeFilterUVConfigForOther[houseTypeForOther].x2, self._purposeFilterUVConfigForOther[houseTypeForOther].y2)
    end
    filter._icon:getBaseTexture():setUV(x1, y1, x2, y2)
    filter._icon:setRenderTexture(filter._icon:getBaseTexture())
    filter._button:SetShow(true)
    filter._icon:SetShow(true)
    self._ui._purposeFilterList[index] = filter
    local tempPosY = 0
    tempPosY = filter._button:GetPosY() + self._ui._static_PurposeBg:GetPosY()
    if tempPosY >= self._BOTTOMBUTTONPOSYLIMIT then
      resultPosY = resultPosY + self._ui._purposeButtonTemplete:GetSizeY()
    end
  end
  self._ui._static_PurposeBg:SetSize(self._ui._static_PurposeBg:GetSizeX(), self._ui._purposeButtonTemplete:GetSizeY() * count + 45)
  if self._ui._static_PurposeBg:GetSpanSize().y > self._MINIMUMPUPOSEBGSPANY then
    self._ui._static_PurposeBg:SetSpanSize(self._ui._static_PurposeBg:GetSpanSize().x, self._ui._static_PurposeBg:GetSpanSize().y - resultPosY)
  else
    self._ui._static_PurposeBg:SetSpanSize(self._ui._static_PurposeBg:GetSpanSize().x, self._MINIMUMPUPOSEBGSPANY)
  end
end
function PaGlobalFunc_WorldMap_HouseFilter_UpdateHouseList()
  local self = Window_WorldMap_HouseFilterInfo
  self:UpdateHouseList()
end
function Window_WorldMap_HouseFilterInfo:UpdateHouseList()
  self._prevScrollIndex = 0
  self._currnetHouseListIndex = 0
  self._houseListInfo = {}
  self._ui._list2_HouseList:getElementManager():clearKey()
  self:SetFilterTitle()
  ToCleint_findHouseByFilter(self._currentHouseFilterIndex, self._currentPurposeFilterType, self._currentGradeFilterIndex + 1)
end
function Window_WorldMap_HouseFilterInfo:InitControl()
  self._ui._static_HouseFilterBg = UI.getChildControl(Panel_Worldmap_HouseFilter, "Static_HouseFilterBg")
  self._ui._static_gradeBg = UI.getChildControl(Panel_Worldmap_HouseFilter, "Static_GradeBg")
  self._ui._static_PurposeBg = UI.getChildControl(Panel_Worldmap_HouseFilter, "Static_PurposeBg")
  self._ui._button_HouseFilter = UI.getChildControl(self._ui._static_FilterBg, "Button_HouseFilter")
  self._ui._button_GradeFilter = UI.getChildControl(self._ui._static_FilterBg, "Button_Grade")
  self._ui._gradeStar = {}
  for index = 0, self._config._gradeCount - 1 do
    self._ui._gradeStar[index] = UI.getChildControl(self._ui._button_GradeFilter, "CheckButton_Star" .. index + 1)
  end
  self._ui._button_PurposeFilter = UI.getChildControl(self._ui._static_FilterBg, "Button_Purpose")
  self._ui._staticText_PurposeFilter = UI.getChildControl(self._ui._button_PurposeFilter, "StaticText_Purpose")
  self._ui._staticText_PurposeFilter:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._purposeButtonTemplete = UI.getChildControl(self._ui._static_PurposeBg, "Radiobutton_Template")
  self._ui._purposeButtonTemplete:SetShow(false)
  self._ui._purposeIconTemplete = UI.getChildControl(self._ui._purposeButtonTemplete, "StaticText_Icon")
  self._ui._purposeIconTemplete:SetShow(false)
  self._config._purposeFilterStartPosY = self._ui._purposeIconTemplete:GetPosY()
  self._ui._list2_HouseList = UI.getChildControl(self._ui._static_List2Bg, "List2_Title_List")
  self._ui._houseFilterList = {}
  for index = 0, self._houseFilterConfig._count - 1 do
    self._ui._houseFilterList[index] = {}
    self._ui._houseFilterList[index]._button = UI.getChildControl(self._ui._static_HouseFilterBg, "Radiobutton_" .. index + 1)
    self._ui._houseFilterList[index]._icon = UI.getChildControl(self._ui._houseFilterList[index]._button, "StaticText_Icon")
    self._ui._houseFilterList[index]._icon:SetText(self._houseFilterStrConfig[index])
  end
  self._ui._gradeFilterList = {}
  for index = 0, self._config._gradeCount - 1 do
    self._ui._gradeFilterList[index] = UI.getChildControl(self._ui._static_gradeBg, "Radiobutton_" .. index + 1)
  end
  self._ui._static_KeyGuide_Select = UI.getChildControl(self._ui._static_BottomBg, "StaticText_A_ConsoleUI")
  self._ui._static_KeyGuide_Close = UI.getChildControl(self._ui._static_BottomBg, "StaticText_B_ConsoleUI")
  self._keyGuideAlign = {
    self._ui._static_KeyGuide_Select,
    self._ui._static_KeyGuide_Close
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui._static_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function Window_WorldMap_HouseFilterInfo:InitEvent()
  self._ui._button_HouseFilter:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorldMap_HouseFilter_OpenFilter(0)")
  self._ui._button_GradeFilter:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorldMap_HouseFilter_OpenFilter(1)")
  self._ui._button_PurposeFilter:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorldMap_HouseFilter_OpenFilter(2)")
  self._ui._button_HouseFilter:addInputEvent("Mouse_On", "PaGlobalFunc_WorldMap_HouseFilter_SetSelectButton(0, " .. self._filterConfig._mainFilter .. ")")
  self._ui._button_GradeFilter:addInputEvent("Mouse_On", "PaGlobalFunc_WorldMap_HouseFilter_SetSelectButton(1, " .. self._filterConfig._mainFilter .. ")")
  self._ui._button_PurposeFilter:addInputEvent("Mouse_On", "PaGlobalFunc_WorldMap_HouseFilter_SetSelectButton(2, " .. self._filterConfig._mainFilter .. ")")
  for index = 0, self._houseFilterConfig._count - 1 do
    self._ui._houseFilterList[index]._button:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorldMap_HouseFilter_SelectHouseFilter(" .. index .. ")")
    self._ui._houseFilterList[index]._button:addInputEvent("Mouse_On", "PaGlobalFunc_WorldMap_HouseFilter_SetSelectButton(" .. index .. ", " .. self._filterConfig._house .. ")")
  end
  for index = 0, self._config._gradeCount - 1 do
    self._ui._gradeFilterList[index]:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorldMap_HouseFilter_SelectGradeFilter(" .. index .. ")")
    self._ui._gradeFilterList[index]:addInputEvent("Mouse_On", "PaGlobalFunc_WorldMap_HouseFilter_SetSelectButton(" .. index .. ", " .. self._filterConfig._grade .. ")")
  end
  self._ui._list2_HouseList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_WorldMap_HouseFilter_List2EventControlCreate")
  self._ui._list2_HouseList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function Window_WorldMap_HouseFilterInfo:InitRegister()
  registerEvent("FromClient_SetTownMode", "PaGlobalFunc_FromClient_WorldMap_HouseFilter_HouseNaviShow")
  registerEvent("FromClient_HouseFilterOn", "PaGlobalFunc_FromClient_WorldMap_HouseFilter_HouseFilterOn")
  registerEvent("FromClient_RefreshHouseList", "PaGlobalFunc_FromClient_WorldMap_HouseFilter_RefreshHouseList")
  registerEvent("FromClient_RefreshHouseListFinish", "PaGlobalFunc_FromClient_WorldMap_HouseFilter_RefreshHouseListFinish")
end
function Window_WorldMap_HouseFilterInfo:Initialize()
  self:InitControl()
  self:InitEvent()
  self:InitRegister()
end
function Window_WorldMap_HouseFilterInfo:SetFilterTitle()
  self._ui._button_HouseFilter:SetText(self._houseFilterStrConfig[self._currentHouseFilterIndex])
  for index = 0, self._config._gradeCount - 1 do
    self._ui._gradeStar[index]:SetCheck(index <= self._currentGradeFilterIndex)
  end
  if -1 == self._currentPurposeFilterIndex then
    self._ui._staticText_PurposeFilter:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_OWNERRFILTER_ALL"))
  else
    self._ui._staticText_PurposeFilter:SetText(ToClient_getReceipeName(ToClient_getReceipeTypeByIndex(self._currentPurposeFilterIndex - 1)))
  end
end
function PaGlobalFunc_WorldMap_HouseFilter_SelectHouseFilter(index)
  local self = Window_WorldMap_HouseFilterInfo
  self._currentHouseFilterIndex = index
  self:UpdateHouseList()
  PaGlobalFunc_WorldMap_HouseFilter_SetSelectButton(self._currentHouseFilterIndex, self._filterConfig._house)
end
function PaGlobalFunc_WorldMap_HouseFilter_SelectGradeFilter(gradeValue)
  local self = Window_WorldMap_HouseFilterInfo
  self._currentGradeFilterIndex = gradeValue
  self:UpdateHouseList()
  PaGlobalFunc_WorldMap_HouseFilter_SetSelectButton(self._currentGradeFilterIndex, self._filterConfig._grade)
end
function PaGlobalFunc_WorldMap_HouseFilter_SelectPurposeFilter(index)
  local self = Window_WorldMap_HouseFilterInfo
  self._currentPurposeFilterIndex = index
  self._currentPurposeFilterType = ToClient_getReceipeTypeByIndex(index - 1)
  self:UpdateHouseList()
  PaGlobalFunc_WorldMap_HouseFilter_SetSelectButton(self._currentPurposeFilterIndex, self._filterConfig._purpose)
end
function PaGlobalFunc_WorldMap_HouseFilter_OpenFilter(filterIndex)
  local self = Window_WorldMap_HouseFilterInfo
  self._ui._static_HouseFilterBg:SetShow(false)
  self._ui._static_gradeBg:SetShow(false)
  self._ui._static_PurposeBg:SetShow(false)
  if 0 == filterIndex then
    self._ui._static_HouseFilterBg:SetShow(true)
  elseif 1 == filterIndex then
    self._ui._static_gradeBg:SetShow(true)
  elseif 2 == filterIndex then
    self._ui._static_PurposeBg:SetShow(true)
  end
  self._currentFilterIndex = filterIndex
  for index = 0, self._houseFilterConfig._count - 1 do
    self._ui._houseFilterList[index]._button:SetCheck(index == self._currentHouseFilterIndex)
  end
  for index = 0, self._config._gradeCount - 1 do
    self._ui._gradeFilterList[index]:SetCheck(index == self._currentGradeFilterIndex)
  end
  for index = 0, #self._ui._purposeFilterList do
    self._ui._purposeFilterList[index]._button:SetCheck(index == self._currentPurposeFilterIndex)
  end
  if -1 == self._currentPurposeFilterIndex then
    self._ui._purposeFilterList[0]._button:SetCheck(true)
  end
  self._ui._static_KeyGuide_Select:SetShow(false)
end
function PaGlobalFunc_WorldMap_HouseFilter_ClearSubFilter()
  local self = Window_WorldMap_HouseFilterInfo
  self._currentFilterIndex = -1
  self._ui._static_HouseFilterBg:SetShow(false)
  self._ui._static_gradeBg:SetShow(false)
  self._ui._static_PurposeBg:SetShow(false)
  PaGlobalFunc_WorldMap_HouseFilter_SetSelectButton(self._config._focusOut)
end
function PaGlobalFunc_FromClient_WorldMap_HouseFilter_HouseNaviShow(isShow)
  local self = Window_WorldMap_HouseFilterInfo
  self:ClearPurposeFilter()
  self:SetPurposeFilter()
end
function PaGlobalFunc_WorldMap_HouseFilter_HouseSort(w1, w2)
  if w1._name < w2._name then
    return true
  end
end
function PaGlobalFunc_FromClient_WorldMap_HouseFilter_RefreshHouseList()
  local self = Window_WorldMap_HouseFilterInfo
  self._prevScrollIndex = self._ui._list2_HouseList:getCurrenttoIndex()
  self._currnetHouseListIndex = 0
  self._houseListInfo = {}
  self._ui._list2_HouseList:getElementManager():clearKey()
end
function PaGlobalFunc_FromClient_WorldMap_HouseFilter_RefreshHouseListFinish()
  local self = Window_WorldMap_HouseFilterInfo
  if 0 == self._currnetHouseListIndex and true == self._isOpenFromCraftManage then
    self._isOpenFromCraftManage = false
    PaGlobalFunc_WorldMap_HouseFilter_SelectHouseFilter(0)
  end
end
function PaGlobalFunc_FromClient_WorldMap_HouseFilter_HouseFilterOn(houseBtn)
  local self = Window_WorldMap_HouseFilterInfo
  if false == PaGlobalFunc_WorldMap_HouseFilter_GetShow() then
    return
  end
  local houseInClientWrapper = houseBtn:FromClient_getStaticStatus()
  local houseInfoSS = houseInClientWrapper:get()
  local houseInfo = {
    _button = houseBtn,
    _houseInClientWrapper = houseInClientWrapper,
    _name = houseInClientWrapper:getName(),
    _houseKey = houseInClientWrapper:getHouseKey(),
    _screenShotPath = ToClient_getScreenShotPath(houseInfoSS, 0),
    _isSalable = houseInClientWrapper:isSalable(),
    _isPurchasable = houseInClientWrapper:isPurchasable(),
    _needExplorePoint = houseInClientWrapper:getNeedExplorePoint(),
    _isSet = houseInClientWrapper:isSet(),
    _receipeCount = houseInClientWrapper:getReceipeCount()
  }
  self._houseListInfo[self._currnetHouseListIndex] = houseInfo
  self._ui._list2_HouseList:getElementManager():pushKey(toInt64(0, self._currnetHouseListIndex))
  self._ui._list2_HouseList:requestUpdateByKey(toInt64(0, self._currnetHouseListIndex))
  self._ui._list2_HouseList:moveIndex(self._prevScrollIndex)
  self._currnetHouseListIndex = self._currnetHouseListIndex + 1
end
function PaGlobalFunc_WorldMap_HouseFilter_SelectHouseList(index)
  local self = Window_WorldMap_HouseFilterInfo
  local houseInfo = self._houseListInfo[index]
  if nil == houseInfo then
    return
  end
  PaGlobalFunc_WorldMap_HouseFilter_CloseSubFilter()
  PaGlobalFunc_WorldMapHouseManager_Open(houseInfo._button, true)
end
function PaGlobalFunc_WorldMap_HouseFilter_SetHouseListEffect(index)
  local self = Window_WorldMap_HouseFilterInfo
  self._ui._static_KeyGuide_Select:SetShow(true)
  local houseInfo = self._houseListInfo[index]
  if nil == houseInfo then
    return
  end
  if self._currentHouseButton == houseInfo._button then
    return
  end
  if nil ~= self._currentHouseButton then
    self._currentHouseButton:EraseAllEffect()
    self._currentHouseButton = nil
  end
  houseInfo._button:AddEffect("UI_ArrowMark_Diagonal01", true, 70, 80)
  self._currentHouseButton = houseInfo._button
end
function PaGlobalFunc_WorldMap_HouseFilter_HouseListEffectHide()
  local self = Window_WorldMap_HouseFilterInfo
  if nil ~= self._currentHouseButton then
    self._currentHouseButton:EraseAllEffect()
    self._currentHouseButton = nil
  end
end
function PaGlobalFunc_WorldMap_HouseFilter_List2EventControlCreate(list_content, key)
  local self = Window_WorldMap_HouseFilterInfo
  local id = Int64toInt32(key)
  local houseInfo = self._houseListInfo[id]
  if nil == houseInfo then
    return
  end
  local staticText_Name = UI.getChildControl(list_content, "StaticText_BoughtHouseAdress")
  local button = UI.getChildControl(list_content, "Button_HouseList")
  local icon = UI.getChildControl(list_content, "Static_HouseTypeIcon")
  local staticText_grade = UI.getChildControl(list_content, "StaticText_Grade")
  staticText_Name:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  button:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorldMap_HouseFilter_SelectHouseList(" .. id .. ")")
  button:addInputEvent("Mouse_On", "PaGlobalFunc_WorldMap_HouseFilter_SetHouseListEffect(" .. id .. ")")
  if 0 == id then
    button:addInputEvent("Mouse_Out", "PaGlobalFunc_WorldMap_HouseFilter_HouseListEffectHide()")
  end
  staticText_Name:SetText(houseInfo._name)
  local rentHouse = ToClient_GetRentHouseWrapper(houseInfo._houseKey)
  local houseType = 0
  if nil ~= rentHouse and true == rentHouse:isSet() then
    houseType = rentHouse:getHouseUseType()
    local houseTypeForOther = rentHouse:getType()
    local houseInfoSSWrapper = houseInfo._houseInClientWrapper
    local maxLevel = rentHouse:getMaxLevel()
    local currentLevel = rentHouse:getLevel()
    staticText_grade:SetText(currentLevel .. " / " .. maxLevel)
    icon:ChangeTextureInfoName(self._purposeFilterTexture)
    local x1, y1, x2, y2
    if 17 ~= houseType and 16 ~= houseType then
      x1, y1, x2, y2 = setTextureUV_Func(icon, self._purposeFliterUVConfig[houseType].x1, self._purposeFliterUVConfig[houseType].y1, self._purposeFliterUVConfig[houseType].x2, self._purposeFliterUVConfig[houseType].y2)
    else
      x1, y1, x2, y2 = setTextureUV_Func(icon, self._purposeFilterUVConfigForOther[houseTypeForOther].x1, self._purposeFilterUVConfigForOther[houseTypeForOther].y1, self._purposeFilterUVConfigForOther[houseTypeForOther].x2, self._purposeFilterUVConfigForOther[houseTypeForOther].y2)
    end
    icon:getBaseTexture():setUV(x1, y1, x2, y2)
    icon:setRenderTexture(icon:getBaseTexture())
    icon:SetShow(true)
    staticText_grade:SetShow(true)
  else
    icon:SetShow(false)
    staticText_grade:SetShow(false)
  end
end
function PaGlobalFunc_WorldMap_HouseFilter_GetShow()
  return Panel_Worldmap_HouseFilter:GetShow()
end
function PaGlobalFunc_WorldMap_HouseFilter_SetShow(isShow, isAni)
  Panel_Worldmap_HouseFilter:SetShow(isShow, isAni)
end
function Window_WorldMap_HouseFilterInfo:CommonOpen()
  PaGlobalFunc_WorldMap_RingMenu_Close()
  PaGlobalFunc_WorldMap_TopMenu_Close()
  PaGlobalFunc_WorldMap_RightMenu_Close()
  PaGlobalFunc_WorldMap_HouseFilter_SetShow(true, false)
end
function PaGlobalFunc_WorldMap_HouseFilter_Open()
  local self = Window_WorldMap_HouseFilterInfo
  if true == PaGlobalFunc_WorldMap_HouseFilter_GetShow() then
    return
  end
  self:CommonOpen()
  self:Clear()
  self._isOpenFromCraftManage = false
  self._currentFilterIndex = -1
end
function PaGlobalFunc_WorldMap_HouseFilter_OpenFromCraftManage()
  local self = Window_WorldMap_HouseFilterInfo
  if true == PaGlobalFunc_WorldMap_HouseFilter_GetShow() then
    return
  end
  self:CommonOpen()
  self._isOpenFromCraftManage = true
  PaGlobalFunc_WorldMap_HouseFilter_SelectHouseFilter(2)
end
function PaGlobalFunc_WorldMap_HouseFilter_Close()
  local self = Window_WorldMap_HouseFilterInfo
  if false == PaGlobalFunc_WorldMap_HouseFilter_GetShow() then
    return
  end
  self:Clear()
  PaGlobalFunc_WorldMap_TopMenu_Open()
  PaGlobalFunc_WorldMap_RingMenu_Open()
  PaGlobalFunc_WorldMap_HouseFilter_HouseListEffectHide()
  PaGlobalFunc_WorldMap_HouseFilter_SetShow(false, false)
end
function PaGlobalFunc_WorldMap_HouseFilter_CloseSubFilter()
  local self = Window_WorldMap_HouseFilterInfo
  self._currentFilterIndex = -1
  if true == self._ui._static_HouseFilterBg:GetShow() then
    self._ui._static_HouseFilterBg:SetShow(false)
    PaGlobalFunc_WorldMap_HouseFilter_SetSelectButton(self._config._focusOut)
    return false
  end
  if true == self._ui._static_gradeBg:GetShow() then
    self._ui._static_gradeBg:SetShow(false)
    PaGlobalFunc_WorldMap_HouseFilter_SetSelectButton(self._config._focusOut)
    return false
  end
  if true == self._ui._static_PurposeBg:GetShow() then
    self._ui._static_PurposeBg:SetShow(false)
    PaGlobalFunc_WorldMap_HouseFilter_SetSelectButton(self._config._focusOut)
    return false
  end
  return true
end
function PaGlobalFunc_WorldMap_HouseFilter_CloseedByOpenManager()
  local self = Window_WorldMap_HouseFilterInfo
  self._currentFilterIndex = -1
  self._ui._static_HouseFilterBg:SetShow(false)
  self._ui._static_gradeBg:SetShow(false)
  self._ui._static_PurposeBg:SetShow(false)
  self:Clear()
  PaGlobalFunc_WorldMap_HouseFilter_SetSelectButton(self._config._focusOut)
  PaGlobalFunc_WorldMap_HouseFilter_HouseListEffectHide()
  PaGlobalFunc_WorldMap_HouseFilter_SetShow(false, false)
end
function PaGlobalFunc_WorldMap_HouseFilter_FilterClear()
  local self = Window_WorldMap_HouseFilterInfo
  self._currentHouseFilterIndex = 0
  self._currentPurposeFilterType = -1
  self._currentPurposeFilterIndex = -1
  self._currentGradeFilterIndex = 0
end
function PaGlobalFunc_FromClient_WorldMap_HouseFilter_luaLoadComplete()
  local self = Window_WorldMap_HouseFilterInfo
  self:Initialize()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_FromClient_WorldMap_HouseFilter_luaLoadComplete")

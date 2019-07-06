local pearlShop = {
  _init = false,
  _panel = Panel_PearlShop,
  _productInfoOffset = 0,
  _frameContentOffset = 0,
  _productControlOffset = 0,
  _showingDescIndex = -1,
  _showingSubProductIndex = -1,
  _scrollContentSize = 0,
  _productControlSmallSize = 70,
  _ui = {
    _productControlList = {},
    _productControlListSize = 0,
    _subProductNameControlListSize = 16,
    _subProductNameControlList = {},
    _subItemControlListSize = 20,
    _subItemControlList = {},
    _categoryTitleControl = nil,
    _frameControl = nil,
    _frameContentControl = nil,
    _bgControl = nil,
    _scrollControl = nil,
    _pearlPriceControl = nil,
    _mileagePriceControl = nil,
    _buttonSelectClass = nil,
    _classFilter = nil
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true,
    createEnduranceIcon = true
  },
  _listItemGapY = 3,
  _infoListSize = 0,
  _classCount = 0,
  _currentClass = -1,
  _list = {},
  _classButton = {},
  _keyGuideAlign = {},
  _itemSlotGapX = 0
}
function PaGlobalFunc_PearlShopOpen(showPanel, productNo)
  pearlShop:open(showPanel, productNo)
end
function pearlShop:classFilterReveal()
  self._ui._buttonSelectClass:SetShow(true)
end
function PaGlobalFunc_PearlShop_ClassFilter_Reveal()
  pearlShop:classFilterReveal()
end
function pearlShop:classFilterHidden()
  self._ui._buttonSelectClass:SetShow(false)
end
function PaGlobalFunc_PearlShop_ClassFilter_Hidden()
  pearlShop:classFilterHidden()
end
function PaGlobalFunc_PearlShop_ClassFilterMenu_Open()
  pearlShop:classFilterMenuOpen()
end
function pearlShop:classFilterMenuOpen()
  self:setClassInfo()
  self:hideDesc()
  self._classFilter:SetShow(true)
end
function PaGlobalFunc_PearlShop_ClassFilterMenu_Close()
  pearlShop:classFilterMenuClose()
end
function pearlShop:classFilterMenuClose()
  self._classFilter:SetShow(false)
end
function pearlShop:initialize()
  if not _ContentsGroup_RenewUI_PearlShop then
    return
  end
  if self._init then
    return
  end
  self._init = true
  local topMenuControl = UI.getChildControl(self._panel, "Static_TopMenu")
  self._ui._categoryTitleControl = UI.getChildControl(topMenuControl, "StaticText_CategoryTitle")
  self._ui._buttonSelectClass = UI.getChildControl(topMenuControl, "Button_SelectClass")
  self._ui._classValueControl = UI.getChildControl(self._ui._buttonSelectClass, "StaticText_ClassValue")
  self._ui._classIconControl = UI.getChildControl(self._ui._buttonSelectClass, "Static_SelectClassIcon")
  topMenuControl:ComputePos()
  topMenuControl:SetShow(true)
  self._ui._bottomKeyGuide = UI.getChildControl(self._panel, "Static_BottomBg")
  self._ui._bottomKeyGuideY = UI.getChildControl(self._ui._bottomKeyGuide, "StaticText_Y_ConsoleUI")
  self._ui._bottomKeyGuideA = UI.getChildControl(self._ui._bottomKeyGuide, "StaticText_A_ConsoleUI")
  self._ui._bottomKeyGuideB = UI.getChildControl(self._ui._bottomKeyGuide, "StaticText_B_ConsoleUI")
  self._keyGuideAlign = {
    self._ui._bottomKeyGuideY,
    self._ui._bottomKeyGuideA,
    self._ui._bottomKeyGuideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui._bottomKeyGuide, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self._ui._frameControl = UI.getChildControl(self._panel, "Panel_PearlShop_ProductListFrame")
  self._ui._frameContentControl = UI.getChildControl(self._ui._frameControl, "Panel_PearlShop_ProductListFrameContent")
  self._ui._bgControl = UI.getChildControl(self._ui._frameContentControl, "Static_MainBG")
  self._ui._scrollControl = UI.getChildControl(self._ui._frameControl, "Panel_PearlShop_ProductListFrameVerticalScroll")
  self._ui._categoryTitleControl:addInputEvent("Mouse_LUp", "PaGlobalFunc_PearlShopBack()")
  self._ui._buttonSelectClass:addInputEvent("Mouse_LUp", "PaGlobalFunc_PearlShop_ClassFilterMenu_Open()")
  self._ui._buttonSelectClass:SetShow(true)
  self._ui._classValueControl:SetShow(true)
  self._ui._classIconControl:SetShow(true)
  self._panel:registerPadEvent(__eConsoleUIPadEvent_LTPress_Y, "PaGlobalFunc_PearlShopDisplayController_ChangeWeather()")
  self._classCount = getPossibleClassCount()
  self._classFilter = UI.getChildControl(self._panel, "Static_ClassSelectBG")
  local buttonTemp = UI.getChildControl(self._classFilter, "Button_Class")
  buttonTemp:SetShow(false)
  UI.getChildControl(self._classFilter, "StaticText_ClassSelectTitle"):SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INGAMESHOP_CLASSBASE"))
  local menuYSize = (buttonTemp:GetSizeY() + 10) * (self._classCount + 1) + 50
  for i = 0, self._classCount do
    local productControl = UI.cloneControl(buttonTemp, self._classFilter, "Button_Class_" .. i)
    self._classButton[i] = productControl
    self._classButton[i]:SetPosY(buttonTemp:GetPosY() + i * (self._classButton[i]:GetSizeY() + 3))
    self._classButton[i]:addInputEvent("Mouse_On", "PaGlobalFunc_PearlShop_ClassSelectButton_Show( " .. i .. " )")
  end
  self._classFilter:SetSize(self._classFilter:GetSizeX(), menuYSize)
  UI.getChildControl(self._classFilter, "Static_ClassSelectBG1"):SetSize(self._classFilter:GetSizeX() - 30, menuYSize - 80)
  self._classFilter:registerPadEvent(__eConsoleUIPadEvent_DpadLeft, "ToClient_padSnapIgnoreGroupMove()")
  local productControlTemplate = UI.getChildControl(self._ui._bgControl, "Button_ProductClick")
  self:hideDescXXXXX(productControlTemplate)
  UI.getChildControl(productControlTemplate, "StaticText_ProductDesc"):SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  productControlTemplate:SetShow(false)
  self._panel:registerPadEvent(__eConsoleUIPadEvent_LB, "PaGlobalFunc_PearlShopDisplayController_LBInput(true)")
  self._panel:registerPadEvent(__eConsoleUIPadEvent_Up_LB, "PaGlobalFunc_PearlShopDisplayController_LBInput(false)")
  local size = math.floor(self._ui._frameControl:GetSizeY() / productControlTemplate:GetSizeY()) + 2
  for i = 0, size - 1 do
    local productControl = UI.cloneControl(productControlTemplate, self._ui._bgControl, "Button_ProductClick" .. i)
    self._ui._productControlList[i] = productControl
    self._ui._productControlListSize = self._ui._productControlListSize + 1
    productControl:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobalFunc_PearlShopSelect(" .. i .. ")")
    productControl:registerPadEvent(__eConsoleUIPadEvent_DpadLeft, "PaGlobalFunc_PearlShopChangeSubProduct(-1)")
    productControl:registerPadEvent(__eConsoleUIPadEvent_DpadRight, "PaGlobalFunc_PearlShopChangeSubProduct(1)")
    productControl:registerPadEvent(__eConsoleUIPadEvent_LBPress_A, "PaGlobalFunc_PearlShopDisplayController_ExcuteOutfitFunction()")
    productControl:registerPadEvent(__eConsoleUIPadEvent_LBPress_DpadLeft, "PaGlobalFunc_PearlShopDisplayController_ChangeOutfitButtonIndex(-1)")
    productControl:registerPadEvent(__eConsoleUIPadEvent_LBPress_DpadRight, "PaGlobalFunc_PearlShopDisplayController_ChangeOutfitButtonIndex(1)")
    productControl:registerPadEvent(__eConsoleUIPadEvent_LBPress_RStickLeft, "PaGlobalFunc_PearlShopDisplayController_OutfitDurabilityControl(-3)")
    productControl:registerPadEvent(__eConsoleUIPadEvent_LBPress_RStickRight, "PaGlobalFunc_PearlShopDisplayController_OutfitDurabilityControl(3)")
    productControl:registerPadEvent(__eConsoleUIPadEvent_RB, "PaGlobalFunc_PearlShopDisplayController_InputPetLookChange(true)")
    local nameControl = UI.getChildControl(productControl, "StaticText_ProductName")
    nameControl:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
    local buttombg = UI.getChildControl(productControl, "Static_ConsoleBottomBg")
    local detailButtonControl = UI.getChildControl(buttombg, "Button_XboxProductSelect_ConsoleUI")
    detailButtonControl:addInputEvent("Mouse_LUp", "PaGlobalFunc_PearlShopShowDetail()")
    local buyButtonControl = UI.getChildControl(productControl, "Button_Buy")
    buyButtonControl:addInputEvent("Mouse_LUp", "PaGlobalFunc_PearlShopBuy(" .. i .. ")")
    local subProductNameControlBase = UI.getChildControl(productControl, "StaticText_SubProductName")
    for j = 0, self._ui._subProductNameControlListSize - 1 do
      local subProductNameControl = UI.cloneControl(subProductNameControlBase, productControl, "StaticText_SubProductName" .. j)
      subProductNameControl:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
      subProductNameControl:addInputEvent("Mouse_LUp", "PaGlobalFunc_PearlShopSelectSubProduct(" .. j .. ")")
    end
    local subItemControlTemplate = UI.getChildControl(productControl, "Static_ItemSlot")
    for j = 0, self._ui._subItemControlListSize - 1 do
      local subItemControl = UI.cloneControl(subItemControlTemplate, productControl, "Static_ItemSlot" .. j)
    end
    local subItemControlTemplate = UI.getChildControl(productControl, "Static_ItemSlotBG")
    for j = 0, self._ui._subItemControlListSize - 1 do
      local subItemControl = UI.cloneControl(subItemControlTemplate, productControl, "Static_ItemSlotBG" .. j)
    end
    self:hideDescXXX(i)
    productControl:SetPosY(productControlTemplate:GetSizeY() * i)
  end
  local bottomMenuControl = UI.getChildControl(self._panel, "Static_BottomMenu")
  self._ui._noProductInfo = UI.getChildControl(self._panel, "StaticText_NOPRODUCTINFO")
  local pearlBgControl = UI.getChildControl(bottomMenuControl, "Static_MoneyType2BG")
  self._ui._pearlPriceControl = UI.getChildControl(pearlBgControl, "StaticText_MoneyType_Price1")
  local mileageBgControl = UI.getChildControl(bottomMenuControl, "Static_MoneyType3BG")
  self._ui._mileagePriceControl = UI.getChildControl(mileageBgControl, "StaticText_MoneyType_Price1")
  self._itemSlotGapX = UI.getChildControl(productControlTemplate, "Static_ItemSlot"):GetSizeX() + 5
  self._panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_PearlShopShowDetail()")
  self._panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobal_PearlShopCoupon_Open()")
  self._panel:RegisterUpdateFunc("PaGlobalFunc_PearlShopProductListPerFrameUpdate")
end
function pearlShop:getClassButtonData(classType)
  local eClassType = CppEnums.ClassType
  local buttonData = {className = ""}
  if classType == eClassType.ClassType_Warrior then
    buttonData.className = PAGetString(Defines.StringSheet_RESOURCE, "UI_CHARACTERCREATE_SELECTCLASS_WARRIOR")
  elseif classType == eClassType.ClassType_Ranger then
    buttonData.className = PAGetString(Defines.StringSheet_RESOURCE, "UI_CHARACTERCREATE_SELECTCLASS_RANGER")
  elseif classType == eClassType.ClassType_Sorcerer then
    buttonData.className = PAGetString(Defines.StringSheet_RESOURCE, "UI_CHARACTERCREATE_SELECTCLASS_SOCERER")
  elseif classType == eClassType.ClassType_Giant then
    buttonData.className = PAGetString(Defines.StringSheet_RESOURCE, "UI_CHARACTERCREATE_SELECTCLASS_GIANT")
  elseif classType == eClassType.ClassType_Tamer then
    buttonData.className = PAGetString(Defines.StringSheet_RESOURCE, "UI_CHARACTERCREATE_SELECTCLASS_TAMER")
  elseif classType == eClassType.ClassType_Wizard then
    buttonData.className = PAGetString(Defines.StringSheet_RESOURCE, "UI_CHARACTERCREATE_SELECTCLASS_WIZARD")
  elseif classType == eClassType.ClassType_WizardWomen then
    buttonData.className = PAGetString(Defines.StringSheet_RESOURCE, "UI_CHARACTERCREATE_SELECTCLASS_WIZARDWOMEN")
  elseif classType == eClassType.ClassType_DarkElf then
    buttonData.className = PAGetString(Defines.StringSheet_RESOURCE, "UI_CHARACTERCREATE_SELECTCLASS_DARKELF")
  elseif classType == eClassType.ClassType_Combattant then
    buttonData.className = PAGetString(Defines.StringSheet_RESOURCE, "UI_CHARACTERCREATE_SELECTCLASS_STRIKER")
  elseif classType == eClassType.ClassType_Lahn then
    buttonData.className = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_RAN")
  elseif classType == eClassType.ClassType_BladeMaster then
    buttonData.className = PAGetString(Defines.StringSheet_RESOURCE, "UI_CHARACTERCREATE_SELECTCLASS_BLADERMASTER")
  elseif classType == eClassType.ClassType_BladeMasterWomen then
    buttonData.className = PAGetString(Defines.StringSheet_RESOURCE, "UI_CHARACTERCREATE_SELECTCLASS_BLADERMASTERWOMEN")
  elseif classType == eClassType.ClassType_CombattantWomen then
    buttonData.className = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_COMBATTANTWOMEN")
  elseif classType == eClassType.ClassType_Valkyrie then
    buttonData.className = PAGetString(Defines.StringSheet_RESOURCE, "UI_CHARACTERCREATE_SELECTCLASS_VALKYRIE")
  elseif classType == eClassType.ClassType_NinjaWomen then
    buttonData.className = PAGetString(Defines.StringSheet_RESOURCE, "UI_CHARACTERCREATE_SELECTCLASS_KUNOICHI")
  elseif classType == eClassType.ClassType_NinjaMan then
    buttonData.className = PAGetString(Defines.StringSheet_RESOURCE, "UI_CHARACTERCREATE_SELECTCLASS_NINJA")
  elseif classType == eClassType.ClassType_Orange then
    buttonData.className = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_ORANGE")
  elseif classType == eClassType.ClassType_ShyWomen then
    buttonData.className = PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_CLASSTYPE_SHYWOMEN")
  else
    buttonData = nil
  end
  return buttonData
end
function PaGlobalFunc_PearlShop_ClassSelectButton_Show(index)
end
function PaGlobalFunc_PearlShop_SetClassInfo()
  pearlShop:setClassInfo()
end
local classFilterAllString = PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKETNEW_FILTER_ALL")
function pearlShop:setClassInfo()
  local buttonData = {}
  for classIdx = 0, self._classCount - 1 do
    self._classButton[classIdx]:SetShow(false)
    classType = getPossibleClassTypeFromIndex(classIdx)
    if nil ~= self:getClassButtonData(classType) then
      table.insert(buttonData, classType)
    end
  end
  local index = 0
  for _key, classType in pairs(buttonData) do
    local classData = self:getClassButtonData(classType)
    if nil ~= classData then
      self._classButton[index]:SetShow(true)
      self._classButton[index]:SetText(classData.className)
      self._classButton[index]:addInputEvent("Mouse_LUp", "PaGlobalFunc_setClassFilter(" .. classType .. ")")
      index = index + 1
    end
  end
  self._classButton[index]:SetShow(true)
  self._classButton[index]:SetText(classFilterAllString)
  self._classButton[index]:addInputEvent("Mouse_LUp", "PaGlobalFunc_setClassFilter(" .. -1 .. ")")
end
function PaGlobalFunc_setClassFilter(classType)
  pearlShop:setClassFilter(classType)
  pearlShop:hideDesc()
  pearlShop:update()
  local self = pearlShop
  local classString = CppEnums.ClassType2String[classType]
  if -1 == classType then
    self._ui._classValueControl:SetText(classFilterAllString)
  else
    self._ui._classValueControl:SetText(classString)
  end
  PaGlobalFunc_PearlShopOpen()
end
function pearlShop:setClassFilter(classType)
  self._currentClass = classType
end
function PaGlobalFunc_getClassFilter()
  return pearlShop._currentClass
end
function PaGlobalFunc_PearlShop_CameraInput()
  pearlShop:cameraInput()
end
function pearlShop:cameraInput()
  if not PaGlobalFunc_WebControl_GetShow() and not PaGlobalFunc_PearlShopDisplayController_GetOutfitLBDown() then
    if isPadPressed(__eJoyPadInputType_RightStick_Up) then
      self:cameraControl_Rotate("Up")
    elseif isPadPressed(__eJoyPadInputType_RightStick_Down) then
      self:cameraControl_Rotate("Down")
    end
    if isPadPressed(__eJoyPadInputType_RightStick_Left) then
      self:cameraControl_Rotate("Left")
    elseif isPadPressed(__eJoyPadInputType_RightStick_Right) then
      self:cameraControl_Rotate("Right")
    end
  end
  if isPadPressed(__eJoyPadInputType_X) then
    if isPadPressed(__eJoyPadInputType_DPad_Up) then
      self:cameraControl_Move("Up")
    elseif isPadPressed(__eJoyPadInputType_DPad_Down) then
      self:cameraControl_Move("Down")
    elseif isPadPressed(__eJoyPadInputType_DPad_Left) then
      self:cameraControl_Move("Left")
    elseif isPadPressed(__eJoyPadInputType_DPad_Right) then
      self:cameraControl_Move("Right")
    end
  end
  if isPadUp(__eJoyPadInputType_RightTrigger) then
    self:cameraControl_doAction()
  end
end
function pearlShop:cameraControl_doAction()
  if 0 < getIngameCashMall():getCharacterActionCount() then
    local randValue = math.random(0, getIngameCashMall():getCharacterActionCount() - 1)
    getIngameCashMall():setCharacterActionKey(randValue, 0)
  end
end
function pearlShop:cameraControl_Zoom(strDir)
  local upValue = 0
  if strDir == "Up" then
    upValue = -30
  elseif strDir == "Down" then
    upValue = 30
  end
  getIngameCashMall():varyCameraZoom(upValue)
end
function PaGlobalFunc_PearlShop_CamraControl_Zoom(strDir)
  pearlShop:cameraControl_Zoom(strDir)
end
function pearlShop:cameraControl_Rotate(strDir)
  if true == isPadPressed(__eJoyPadInputType_LeftTrigger) then
    self:cameraControl_Zoom(strDir)
    return
  end
  local radianAngle = 0
  local cameraPitch = 0
  if strDir == "Up" then
    cameraPitch = -0.1
  elseif strDir == "Down" then
    cameraPitch = 0.1
  elseif strDir == "Left" then
    radianAngle = 0.1
  elseif strDir == "Right" then
    radianAngle = -0.1
  end
  getIngameCashMall():rotateViewCharacter(radianAngle)
  getIngameCashMall():varyCameraPitch(cameraPitch)
end
function PaGlobalFunc_PearlShop_CamraControl_Rotate(strDir)
  pearlShop:cameraControl_Rotate(strDir)
end
function pearlShop:cameraControl_Move(strDir)
  local radianAngle = 0
  local cameraPitch = 0
  if strDir == "Up" then
    cameraPitch = 1
  elseif strDir == "Down" then
    cameraPitch = -1
  elseif strDir == "Left" then
    radianAngle = -1
  elseif strDir == "Right" then
    radianAngle = 1
  end
  getIngameCashMall():varyCameraPositionByUpAndRightVector(radianAngle, cameraPitch)
end
function PaGlobalFunc_PearlShop_CamraControl_Move(strDir)
  pearlShop:cameraControl_Move(strDir)
end
function PaGlobalFunc_PearlShopCheckShow()
  return pearlShop:checkShow()
end
function PaGlobalFunc_PearlShopUpdate()
  return pearlShop:update()
end
function pearlShop:checkShow()
  return self._panel:GetShow()
end
function PaGlobalFunc_PearlShopBack()
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  if pearlShop:back() then
    return pearlShop:update()
  end
end
function pearlShop:back()
  if nil ~= Panel_PearlShop_Coupon and true == Panel_PearlShop_Coupon:GetShow() then
    PaGlobal_PearlShopCoupon_Close()
    return false
  end
  if true == self._classFilter:GetShow() then
    self:classFilterMenuClose()
    return true
  end
  if self:hideDesc() then
    return true
  end
  PaGlobalFunc_PearlShopCategoryOpen(false)
  self:close()
end
function pearlShop:open(showPanel, productNo)
  if nil ~= Panel_Window_DailyStamp_Renew and true == Panel_Window_DailyStamp_Renew:GetShow() then
    PaGlobalFunc_PearlShopCategory_CheckDailyStampOpened(true)
    PaGlobalFunc_DailyStamp_Close()
  end
  local categoryTitle = PaGlobalFunc_PearlShopCategoryGetCurrentCategoryTitle()
  self._ui._categoryTitleControl:SetText(categoryTitle)
  self._ui._categoryTitleControl:SetShow(true)
  self._productInfoOffset = 0
  self._frameContentOffset = 0
  self._productControlOffset = 0
  self._showingDescIndex = -1
  self._showingSubProductIndex = -1
  getIngameCashMall():setSearchText("")
  getIngameCashMall():setCurrentClass(self._currentClass)
  getIngameCashMall():setCurrentSort(-1)
  getIngameCashMall():setCurrentSubFilter(-1)
  getIngameCashMall():setCashProductNoRawFilterList()
  self._list = {}
  self._infoListSize = getIngameCashMall():getCashProductFilterListCount()
  for i = 0, self._infoListSize - 1 do
    table.insert(self._list, i)
  end
  local contentSizeY = (self._productControlSmallSize + self._listItemGapY) * self._infoListSize
  self:initContentSize(contentSizeY)
  PaGlobalFunc_PearlShopDisplayController_Open()
  getIngameCashMall():clearEquipViewList()
  getIngameCashMall():changeViewMyCharacter()
  getIngameCashMall():hide()
  getIngameCashMall():show()
  PaGlobalFunc_ConsoleKeyGuide_SetGuide(Defines.ConsoleKeyGuideType.pearlShop)
  PaGlobalFunc_PearlShopSetBKeyGuide()
  if false ~= showPanel then
    self._panel:SetShow(true)
  end
  if nil ~= productNo then
    local index
    index = self:getIndexByProductNo(productNo)
    if nil ~= index then
      local controlIndex = self:getControlIndexByIndex(index)
      local control = self:getProductControlByControlIndex(controlIndex)
      PaGlobalFunc_PearlShopSelect(controlIndex)
      ToClient_padSnapChangeToTarget(control)
      return
    end
  end
  self:update()
end
function pearlShop:initContentSize(size)
  self._ui._frameContentControl:SetSize(self._ui._frameContentControl:GetSizeX(), size)
  self._ui._bgControl:SetSize(self._ui._bgControl:GetSizeX(), size)
  self._ui._frameControl:UpdateContentScroll()
  local scrollAreaSizeY = size - self._ui._frameControl:GetSizeY()
  local scrollUnitSizeY = self._productControlSmallSize + self._listItemGapY
  local scrollInterval = scrollAreaSizeY / scrollUnitSizeY
  self._ui._scrollControl:SetInterval(scrollInterval)
  self._ui._scrollControl:SetControlPos(0)
  self._ui._frameControl:UpdateContentPos()
  self._scrollContentSize = size
end
function pearlShop:addContentSize(sizeOffset)
  local scrollPos = self._ui._scrollControl:GetControlPos()
  local scrollPosY = scrollPos * self._scrollContentSize
  local nextScrollContentSize = self._scrollContentSize + sizeOffset
  local nextScrollPos = scrollPosY / nextScrollContentSize
  if nextScrollPos > 1 then
    nextScrollPos = 1
  end
  if -1 < self._showingDescIndex then
    local listSize = getIngameCashMall():getCashProductFilterListCount()
    local index = self._productInfoOffset + self._showingDescIndex + 1
    if index > listSize - 4 then
      local scrollpos = index / listSize
      if scrollpos > 1 then
        scrollpos = 1
      end
      self._ui._scrollControl:SetControlPos(scrollpos)
    end
  end
  self._ui._frameContentControl:SetSize(self._ui._frameContentControl:GetSizeX(), nextScrollContentSize)
  self._ui._bgControl:SetSize(self._ui._bgControl:GetSizeX(), nextScrollContentSize)
  self._ui._frameControl:UpdateContentScroll()
  self._ui._frameControl:UpdateContentPos()
  self._ui._frameControl:UpdateContentPosWithSnap()
  self._scrollContentSize = nextScrollContentSize
end
function pearlShop:close()
  self._panel:SetShow(false)
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  FGlobal_Panel_Radar_Show(true, false)
  Panel_TimeBar:SetShow(true, false)
  FGlobal_QuestWidget_Open()
  getIngameCashMall():setCurrentClass(-1)
  PaGlobalFunc_PearlShopDisplayController_Close()
  self._currentClass = -1
end
function PaGlobalFunc_PearlShopClose()
  pearlShop:close()
end
function pearlShop:getProductInfoByIndex(index)
  if index < 0 or index >= self._ui._productControlListSize then
    return
  end
  local infoIndex = self._productInfoOffset + index + 1
  if infoIndex > self._infoListSize then
    return
  end
  if nil == self._list[infoIndex] then
    return
  end
  local productNoRaw = getIngameCashMall():getCashProductNoRawFromFilterList(self._list[infoIndex])
  if nil == productNoRaw then
    return
  end
  local productInfo = getIngameCashMall():getCashProductStaticStatusByProductNoRaw(productNoRaw)
  return productInfo
end
function pearlShop:getIndexByProductNo(productNo)
  if nil == productNo then
    return
  end
  self:update()
  for index = 0, self._infoListSize - 1 do
    local infoIndex = self._productInfoOffset + index + 1
    if nil ~= self._list[infoIndex] then
      local productNoRaw = getIngameCashMall():getCashProductNoRawFromFilterList(self._list[infoIndex])
      if nil ~= productNoRaw and productNoRaw == productNo then
        return index
      end
    end
  end
  return nil
end
function pearlShop:frameUpdate(delta)
  local frameTop = self._ui._frameControl:GetParentPosY()
  local frameShowingTop = frameTop - self._productControlSmallSize
  local frameBottom = frameTop + self._ui._frameControl:GetSizeY()
  if 0 <= self._showingDescIndex then
    local showingControl = self:getProductControlByIndex(self._showingDescIndex)
    local showingTop = showingControl:GetParentPosY()
    local showingBottom = showingTop + showingControl:GetSizeY()
    if frameBottom < showingTop or frameTop > showingBottom then
      self:hideDesc()
      return true
    end
  end
  local hideIndex = -1
  for i = 0, self._ui._productControlListSize - 1 do
    local control = self:getProductControlByIndex(i)
    local controlBottom = control:GetParentPosY() + control:GetSizeY()
    if frameShowingTop > controlBottom then
      hideIndex = i
      break
    end
  end
  if hideIndex >= 0 then
    local sizeStackToScrollUp = 0
    for i = 0, hideIndex do
      local control = self:getProductControlByIndex(i)
      sizeStackToScrollUp = sizeStackToScrollUp + control:GetSizeY() + self._listItemGapY
    end
    self._frameContentOffset = self._frameContentOffset + sizeStackToScrollUp
    self:addProductInfoOffset(hideIndex + 1)
    return true
  end
  local firstControlTop = self:getProductControlByIndex(0):GetParentPosY()
  if frameShowingTop < firstControlTop then
    local gapSizeY = firstControlTop - frameShowingTop
    local showCount = math.ceil(gapSizeY / (self._productControlSmallSize + self._listItemGapY))
    if showCount > self._productInfoOffset then
      showCount = self._productInfoOffset
    end
    if self:addProductInfoOffset(-1 * showCount) then
      self._frameContentOffset = self._frameContentOffset - showCount * (self._productControlSmallSize + self._listItemGapY)
    end
    return true
  end
  if frameShowingTop > firstControlTop then
    return true
  end
end
function PaGlobalFunc_PearlShopProductListPerFrameUpdate(delta)
  if pearlShop:frameUpdate(delta) then
    pearlShop:update()
  end
  if nil ~= pearlShop._showingDescIndex and pearlShop._showingDescIndex > -1 and pearlShop:updateControlInfo(pearlShop._showingDescIndex) then
    pearlShop:showDescXXX(pearlShop._showingDescIndex)
  end
end
function pearlShop:changePlatformSpecKey()
  if not self._init then
    return
  end
end
function FromClient_PearlShopInit()
  pearlShop:initialize()
end
function pearlShop:showDesc(index)
  if self._showingDescIndex == index then
    return false
  end
  if self._showingDescIndex >= 0 then
    self:hideDesc()
  end
  local info = self:getProductInfoByIndex(index)
  if not info then
    return false
  end
  self._showingDescIndex = index
  local groupIndex = info:getOfferGroup()
  local subInfoListSize = getIngameCashMall():getCashProductStaticStatusGroupListCount(groupIndex)
  if subInfoListSize > 1 then
    self:selectSubProduct(0)
  else
    PaGlobalFunc_PearlShopDisplayController_SetProductNoRaw(info:getNoRaw())
  end
  return true
end
function pearlShop:showDescXXX(index)
  local control = self:getProductControlByIndex(index)
  local beforeSizeY = control:GetSizeY()
  UI.getChildControl(control, "Static_BG1"):SetShow(true)
  UI.getChildControl(control, "StaticText_SubProductName"):SetShow(false)
  UI.getChildControl(control, "StaticText_ProductDesc"):SetShow(true)
  UI.getChildControl(control, "Static_ItemSlot"):SetShow(false)
  UI.getChildControl(control, "Static_ItemSlotBG"):SetShow(false)
  local buttombg = UI.getChildControl(control, "Static_ConsoleBottomBg")
  UI.getChildControl(buttombg, "Button_XboxBuy_ConsoleUI"):SetShow(true)
  UI.getChildControl(buttombg, "Button_XboxProductSelect_ConsoleUI"):SetShow(true)
  UI.getChildControl(control, "Static_BG2"):SetShow(true)
  local topPosY = -1
  local bottomPosY = -1
  local subProductNameBaseControl = UI.getChildControl(control, "StaticText_SubProductName")
  for i = 0, self._ui._subProductNameControlListSize - 1 do
    local subControl = UI.getChildControl(control, "StaticText_SubProductName" .. i)
    subControl:SetPosX(subProductNameBaseControl:GetPosX() + 255 * (i % 3))
    subControl:SetPosY(subProductNameBaseControl:GetPosY() + 35 * math.floor(i / 3))
    if 0 < string.len(subControl:GetText()) then
      subControl:SetShow(true)
      if topPosY < 0 then
        topPosY = subControl:GetPosY()
      end
      bottomPosY = subControl:GetPosY() + subControl:GetSizeY()
    end
  end
  local showSubProductFlag = topPosY > 0 and bottomPosY > 0
  UI.getChildControl(control, "StaticText_ProductSubSetName"):SetShow(showSubProductFlag)
  if false == PaGlobalFunc_PearlShopDisplayController_GetOutfitLBDown() then
    UI.getChildControl(control, "Static_ProductSubSetLeftIcon"):SetShow(showSubProductFlag)
    UI.getChildControl(control, "Static_ProductSubSetRightIcon"):SetShow(showSubProductFlag)
  end
  local subProductBgControl = UI.getChildControl(control, "Static_BG2")
  subProductBgControl:SetShow(showSubProductFlag)
  local descPosY = -1
  if showSubProductFlag then
    subProductBgControl:SetSize(subProductBgControl:GetSizeX(), bottomPosY - topPosY + 20)
    local bottomLineControl = UI.getChildControl(subProductBgControl, "Static_HorizontalLine2")
    bottomLineControl:SetPosY(subProductBgControl:GetSizeY())
    descPosY = subProductBgControl:GetPosY() + subProductBgControl:GetSizeY() + 10
  else
    subProductBgControl:SetSize(subProductBgControl:GetSizeX(), 0)
    descPosY = UI.getChildControl(control, "Static_ProductSubSetLeftIcon"):GetPosY()
  end
  local descControl = UI.getChildControl(control, "StaticText_ProductDesc")
  descControl:SetPosY(descPosY)
  local subItemPosY = descControl:GetPosY() + descControl:GetTextSizeY() + 10
  local info = self:getProductInfoByIndex(index)
  local subItemBgControl = UI.getChildControl(control, "Static_ItemSlot")
  subItemBgControl:SetPosY(subItemPosY)
  for i = 0, self._ui._subItemControlListSize - 1 do
    local subControl = UI.getChildControl(control, "Static_ItemSlot" .. i)
    subControl:SetPosX(subItemBgControl:GetPosX() + i * self._itemSlotGapX)
    subControl:SetPosY(subItemPosY + 10)
    subControl:SetShow(i < info:getItemListCount() + info:getSubItemListCount())
  end
  local subItemBaseControl = UI.getChildControl(control, "Static_ItemSlotBG")
  subItemBaseControl:SetPosY(subItemPosY)
  for i = 0, self._ui._subItemControlListSize - 1 do
    local subControl = UI.getChildControl(control, "Static_ItemSlotBG" .. i)
    subControl:SetPosX(subItemBaseControl:GetPosX() + i * self._itemSlotGapX + 1)
    subControl:SetPosY(subItemPosY + 12)
    subControl:SetShow(i < info:getItemListCount() + info:getSubItemListCount())
  end
  local bgPosY = subItemBaseControl:GetPosY() + subItemBaseControl:GetSizeY() + 68
  local staticText_LimitDesc = UI.getChildControl(control, "StaticText_LimitDesc")
  staticText_LimitDesc:SetShow(false)
  local limitType = info:getCashPurchaseLimitType()
  if CppEnums.CashPurchaseLimitType.None ~= limitType then
    local limitCount = info:getCashPurchaseCount()
    local mylimitCount = getIngameCashMall():getRemainingLimitCount(info:getNoRaw())
    local typeString = ""
    if CppEnums.CashPurchaseLimitType.AtCharacter == limitType then
      typeString = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_CHARACTER")
    elseif CppEnums.CashPurchaseLimitType.AtAccount == limitType then
      typeString = PAGetString(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_FAMILY")
    end
    staticText_LimitDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    staticText_LimitDesc:SetText(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_PURCHASELIMIT", "typeString", typeString, "limitCount", limitCount, "mylimitCount", mylimitCount) .. " (" .. info:getLimitedTypeDesc() .. ")")
    staticText_LimitDesc:SetFontColor(Defines.Color.C_FFF26A6A)
    staticText_LimitDesc:SetShow(true)
    staticText_LimitDesc:SetPosY(bgPosY)
    bgPosY = bgPosY + staticText_LimitDesc:GetTextSizeY() + 68
  end
  local bgControl = UI.getChildControl(control, "Static_BG1")
  bgControl:SetSize(bgControl:GetSizeX(), bgPosY - bgControl:GetPosY())
  local buttonPosY = bgControl:GetPosY() + bgControl:GetSizeY() - 48
  UI.getChildControl(control, "Button_Buy"):SetPosY(buttonPosY)
  local buttombg = UI.getChildControl(control, "Static_ConsoleBottomBg")
  UI.getChildControl(buttombg, "Button_XboxBuy_ConsoleUI"):SetPosY(buttonPosY - 5)
  UI.getChildControl(buttombg, "Button_XboxProductSelect_ConsoleUI"):SetPosY(buttonPosY - 5)
  local totalSizeY = buttonPosY + UI.getChildControl(control, "Button_Buy"):GetSizeY() + 10
  control:SetSize(control:GetSizeX(), totalSizeY)
  local diffSizeY = control:GetSizeY() - beforeSizeY
  return diffSizeY
end
function pearlShop:hideDescXXXXX(control)
  local beforeSizeY = control:GetSizeY()
  UI.getChildControl(control, "Static_BG1"):SetShow(false)
  UI.getChildControl(control, "StaticText_ProductSubSetName"):SetShow(false)
  UI.getChildControl(control, "Static_ProductSubSetLeftIcon"):SetShow(false)
  UI.getChildControl(control, "Static_ProductSubSetRightIcon"):SetShow(false)
  UI.getChildControl(control, "StaticText_SubProductName"):SetShow(false)
  UI.getChildControl(control, "StaticText_ProductDesc"):SetShow(false)
  UI.getChildControl(control, "Static_ItemSlot"):SetShow(false)
  UI.getChildControl(control, "Static_ItemSlotBG"):SetShow(false)
  UI.getChildControl(control, "Button_Buy"):SetShow(false)
  UI.getChildControl(control, "Button_Gift"):SetShow(false)
  UI.getChildControl(control, "Button_Cart"):SetShow(false)
  local buttombg = UI.getChildControl(control, "Static_ConsoleBottomBg")
  UI.getChildControl(buttombg, "Button_XboxBuy_ConsoleUI"):SetShow(false)
  UI.getChildControl(buttombg, "Button_XboxGift_ConsoleUI"):SetShow(false)
  UI.getChildControl(buttombg, "Button_XboxProductSelect_ConsoleUI"):SetShow(false)
  UI.getChildControl(control, "Static_BG2"):SetShow(false)
  UI.getChildControl(control, "StaticText_LimitDesc"):SetShow(false)
  for i = 0, self._ui._subProductNameControlListSize - 1 do
    local subControl = UI.getChildControlNoneAssert(control, "StaticText_SubProductName" .. i)
    if subControl then
      subControl:SetShow(false)
    end
  end
  for i = 0, self._ui._subItemControlListSize - 1 do
    local subbgControl = UI.getChildControlNoneAssert(control, "Static_ItemSlot" .. i)
    if subbgControl then
      subbgControl:SetShow(false)
    end
  end
  for i = 0, self._ui._subItemControlListSize - 1 do
    local subControl = UI.getChildControlNoneAssert(control, "Static_ItemSlotBG" .. i)
    if subControl then
      subControl:SetShow(false)
    end
  end
  control:SetSize(control:GetSizeX(), self._productControlSmallSize)
  local diffSizeY = control:GetSizeY() - beforeSizeY
  return
end
function pearlShop:hideDescXXX(index)
  local control = self:getProductControlByIndex(index)
  local beforeSizeY = control:GetSizeY()
  self:hideDescXXXXX(control)
  local diffSizeY = control:GetSizeY() - beforeSizeY
  return diffSizeY
end
function pearlShop:hideDesc()
  if self._showingDescIndex < 0 then
    return false
  end
  self._showingDescIndex = -1
  self._showingSubProductIndex = -1
  self._ui._bottomKeyGuideA:SetShow(true)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui._bottomKeyGuide, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  return true
end
function pearlShop:select(controlIndex)
  local index = self:getIndexByControlIndex(controlIndex)
  if self._showingDescIndex == index then
    self:buy(controlIndex)
    return
  end
  return self:showDesc(index)
end
function PaGlobalFunc_PearlShopSelect(controlIndex)
  pearlShop._ui._bottomKeyGuideA:SetShow(false)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(pearlShop._keyGuideAlign, pearlShop._ui._bottomKeyGuide, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  if pearlShop:select(controlIndex) then
    return pearlShop:update()
  end
end
function pearlShop:showDetail()
  if self._showingDescIndex < 0 then
    return
  end
  local info = self:getProductInfoByIndex(self._showingDescIndex)
  if not info then
    return
  end
  local groupIndex = info:getOfferGroup()
  local subInfoListSize = getIngameCashMall():getCashProductStaticStatusGroupListCount(groupIndex)
  if 0 <= self._showingSubProductIndex and subInfoListSize > self._showingSubProductIndex then
    info = getIngameCashMall():getCashProductStaticStatusGroupByIndex(groupIndex, self._showingSubProductIndex)
  end
  pearlShop._ui._bottomKeyGuideB:SetShow(false)
  PaGlobalFunc_PearlShopProductInfoOpen(info)
  PaGlobalFunc_PearlShopDisplayController_LBInput(false)
end
function PaGlobalFunc_PearlShopShowDetail()
  return pearlShop:showDetail()
end
function pearlShop:selectSubProduct(index)
  local info = self:getProductInfoByIndex(self._showingDescIndex)
  if not info then
    return
  end
  local groupIndex = info:getOfferGroup()
  local subInfoListSize = getIngameCashMall():getCashProductStaticStatusGroupListCount(groupIndex)
  if index >= subInfoListSize then
    return
  end
  local subInfo = getIngameCashMall():getCashProductStaticStatusGroupByIndex(groupIndex, index)
  if not subInfo then
    return
  end
  PaGlobalFunc_PearlShopDisplayController_SetProductNoRaw(subInfo:getNoRaw())
  self._showingSubProductIndex = index
  return true
end
function PaGlobalFunc_PearlShopSelectSubProduct(index)
  if pearlShop:selectSubProduct(index) then
    return pearlShop:update()
  end
end
function pearlShop:changeSubProduct(diffIndex)
  if self._showingSubProductIndex < 0 then
    return
  end
  local index = self._showingSubProductIndex + diffIndex
  if index < 0 then
    return
  end
  local info = self:getProductInfoByIndex(self._showingDescIndex)
  if not info then
    return
  end
  local groupIndex = info:getOfferGroup()
  local subInfoListSize = getIngameCashMall():getCashProductStaticStatusGroupListCount(groupIndex)
  if index >= subInfoListSize then
    return
  end
  return self:selectSubProduct(index)
end
function PaGlobalFunc_PearlShopSetBKeyGuide()
  local self = pearlShop
  self._ui._bottomKeyGuideB:SetShow(true)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui._bottomKeyGuide, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function PaGlobalFunc_PearlShopChangeSubProduct(diffIndex)
  if pearlShop:changeSubProduct(diffIndex) then
    _AudioPostEvent_SystemUiForXBOX(51, 4)
    return pearlShop:update()
  end
end
function pearlShop:buy(controlIndex)
  local index = self:getIndexByControlIndex(controlIndex)
  local info = self:getProductInfoByIndex(index)
  if not info then
    return
  end
  local groupIndex = info:getOfferGroup()
  local subInfoListSize = getIngameCashMall():getCashProductStaticStatusGroupListCount(groupIndex)
  if 0 <= self._showingSubProductIndex and subInfoListSize > self._showingSubProductIndex then
    info = getIngameCashMall():getCashProductStaticStatusGroupByIndex(groupIndex, self._showingSubProductIndex)
  end
  pearlShop._ui._bottomKeyGuideB:SetShow(false)
  PaGlobalFunc_PearlShopProductBuyOpen(info)
end
function PaGlobalFunc_PearlShopBuy(controlIndex)
  return pearlShop:buy(controlIndex)
end
function PaGlobalFunc_PearlShopEnableKeyGuide(isShow)
  local self = pearlShop
  self._ui._bottomKeyGuideA:SetShow(isShow)
  local control = self:getProductControlByIndex(self._showingDescIndex)
  UI.getChildControl(control, "Static_ConsoleBottomBg"):SetShow(isShow)
  UI.getChildControl(control, "Static_ProductSubSetLeftIcon"):SetShow(isShow)
  UI.getChildControl(control, "Static_ProductSubSetRightIcon"):SetShow(isShow)
  if true == isShow then
    self._panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobalFunc_PearlShopShowDetail()")
  else
    self._panel:registerPadEvent(__eConsoleUIPadEvent_Up_X, "")
  end
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuideAlign, self._ui._bottomKeyGuide, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function pearlShop:addProductInfoOffset(offset)
  if self._productInfoOffset + offset < 0 then
    return false
  end
  self._productInfoOffset = self._productInfoOffset + offset
  self._productControlOffset = (self._productControlOffset + offset) % self._ui._productControlListSize
  if 0 <= self._showingDescIndex then
    self._showingDescIndex = self._showingDescIndex - offset
  end
  return true
end
function pearlShop:getControlIndexByIndex(index)
  local controlIndex = self._productControlOffset + index
  controlIndex = controlIndex % self._ui._productControlListSize
  return controlIndex
end
function pearlShop:getIndexByControlIndex(controlIndex)
  local index = controlIndex - self._productControlOffset
  index = (index + self._ui._productControlListSize) % self._ui._productControlListSize
  return index
end
function pearlShop:getProductControlByIndex(index)
  local controlIndex = self:getControlIndexByIndex(index)
  return self:getProductControlByControlIndex(controlIndex)
end
function pearlShop:getProductControlByControlIndex(index)
  if index >= 0 and index < self._ui._productControlListSize then
    return self._ui._productControlList[index]
  end
end
function IngameCashShop_SortCash_Byindex(lhs, rhs)
  local lhsRaw = getIngameCashMall():getCashProductNoRawFromFilterList(lhs)
  local rhsRaw = getIngameCashMall():getCashProductNoRawFromFilterList(rhs)
  if nil == rhsRaw or nil == lhsRaw then
    return false
  end
  return IngameCashShop_SortCash(lhsRaw, rhsRaw)
end
function pearlShop:update()
  if not self._init then
    return
  end
  local pos = self._frameContentOffset
  local diffSizeY = 0
  for i = 0, self._ui._productControlListSize - 1 do
    local control = self:getProductControlByIndex(i)
    control:SetPosY(pos)
    if self:updateControlInfo(i) then
      if self._showingDescIndex == i then
        diffSizeY = diffSizeY + self:showDescXXX(i)
      else
        diffSizeY = diffSizeY + self:hideDescXXX(i)
      end
      pos = pos + control:GetSizeY() + self._listItemGapY
    end
  end
  if 0 ~= diffSizeY then
    self:addContentSize(diffSizeY)
  end
  self._ui._noProductInfo:SetShow(0 == listSize)
  local pearl = toInt64(0, 0)
  local pearlItem = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, getPearlSlotNo())
  if pearlItem then
    pearl = pearlItem:get():getCount_s64()
  end
  self._ui._pearlPriceControl:SetText(makeDotMoney(pearl))
  local mileage = toInt64(0, 0)
  local mileageItem = getInventoryItemByType(CppEnums.ItemWhereType.eCashInventory, getMileageSlotNo())
  if mileageItem then
    mileage = mileageItem:get():getCount_s64()
  end
  self._ui._mileagePriceControl:SetText(makeDotMoney(mileage))
end
function pearlShop:updateControlInfo(index)
  local control = self:getProductControlByIndex(index)
  if not control then
    return false
  end
  local info = self:getProductInfoByIndex(index)
  if not info then
    control:SetShow(false)
    return false
  end
  control:SetShow(true)
  local nameControl = UI.getChildControl(control, "StaticText_ProductName")
  nameControl:SetText(info:getDisplayName())
  local subTitleControl = UI.getChildControl(control, "StaticText_ProductSubSetName")
  subTitleControl:SetText(info:getDisplaySubName())
  local tagTexture = {
    [0] = {
      0,
      0,
      0,
      0
    },
    {
      1,
      1,
      230,
      60
    },
    {
      1,
      61,
      230,
      120
    },
    {
      231,
      1,
      460,
      60
    },
    {
      231,
      121,
      460,
      180
    },
    {
      231,
      61,
      460,
      120
    },
    {
      1,
      121,
      230,
      180
    }
  }
  local imageControl = UI.getChildControl(control, "Static_ProductBannerImage")
  if info:getPackageIcon() then
    imageControl:ChangeTextureInfoNameAsync(info:getPackageIcon())
  else
    imageControl:ChangeTextureInfoNameAsync(nil)
  end
  local soldOutTexture = UI.getChildControl(control, "Static_SoldOut")
  control:SetMonoTone(false)
  control:SetEnable(true)
  soldOutTexture:SetShow(false)
  local limitType = info:getCashPurchaseLimitType()
  if CppEnums.CashPurchaseLimitType.None ~= limitType then
    local limitCount = info:getCashPurchaseCount()
    local mylimitCount = getIngameCashMall():getRemainingLimitCount(info:getNoRaw())
    if limitCount > 0 and mylimitCount == 0 then
      control:SetMonoTone(true)
      control:SetEnable(false)
      soldOutTexture:SetShow(true)
    end
  end
  local tagControl = UI.getChildControl(control, "Static_ProductBannerSaleType")
  local tagType = info:getTag()
  tagControl:ChangeTextureInfoNameAsync("renewal/ETC/Console_ETC_CashShop_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(tagControl, tagTexture[tagType][1], tagTexture[tagType][2], tagTexture[tagType][3], tagTexture[tagType][4])
  tagControl:getBaseTexture():setUV(x1, y1, x2, y2)
  tagControl:setRenderTexture(tagControl:getBaseTexture())
  local tagType = info:getTag()
  if (4 == tagType or 5 == tagType) and not info:isApplyDiscount() and info:isDefinedDiscount() then
    tagControl:SetShow(false)
  else
    tagControl:SetShow(true)
  end
  local pearlPriceControl = UI.getChildControl(control, "StaticText_ProductPearlPrice")
  local mileagePriceControl = UI.getChildControl(control, "StaticText_ProductMileagePrice")
  local discountControl = UI.getChildControl(control, "StaticText_DiscountPrice")
  local discountIcon = UI.getChildControl(control, "StaticText_DiscountIcon")
  local discountDescControl = UI.getChildControl(control, "StaticText_ProductSaleDate")
  if info:isApplyDiscount() then
    local endDiscountTimeValue = PATime(info:getEndDiscountTime():get_s64())
    local endDiscountTimeStr = ""
    if isGameTypeEnglish() then
      endDiscountTimeStr = convertStringFromDatetime(info:getRemainDiscountTime())
    else
      endDiscountTimeStr = PAGetStringParam3(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_GOODSDETAILINFO_DISCOUNTTIME", "GetYear", tostring(endDiscountTimeValue:GetYear()), "GetMonth", tostring(endDiscountTimeValue:GetMonth()), "GetDay", tostring(endDiscountTimeValue:GetDay())) .. " " .. string.format("%.02d", endDiscountTimeValue:GetHour()) .. ":" .. string.format("%.02d", endDiscountTimeValue:GetMinute())
    end
    discountDescControl:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_INGAMECASHSHOP_DISCOUNT", "endDiscountTime", endDiscountTimeStr))
    discountDescControl:SetShow(true)
    discountControl:SetText(makeDotMoney(info:getOriginalPrice()))
    discountControl:SetShow(true)
    local frameTop = self._ui._frameControl:GetParentPosY()
    local frameShowingTop = frameTop - self._productControlSmallSize
    local frameBottom = frameTop + self._ui._frameControl:GetSizeY()
    local discountControlPosY = control:GetParentPosY() + discountControl:GetPosY()
    if frameTop < discountControlPosY and frameBottom > discountControlPosY then
      discountControl:SetLineRender(true)
    else
      discountControl:SetLineRender(false)
    end
    discountIcon:SetShow(0 ~= info:getDiscountPercent())
    discountIcon:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_CASHSHOP_DISPLAYPERCET", "percent", info:getDiscountPercent()))
  else
    discountControl:SetShow(false)
    discountDescControl:SetShow(false)
    discountIcon:SetShow(false)
  end
  if info:isApplyDiscount() then
    pearlPriceControl:SetText(makeDotMoney(info:getPearlPrice()))
    pearlPriceControl:SetShow(toInt64(0, 0) < info:getPearlPrice())
    mileagePriceControl:SetText(makeDotMoney(info:getMileagePrice()))
    mileagePriceControl:SetShow(toInt64(0, 0) < info:getMileagePrice())
    if true == pearlPriceControl:GetShow() then
      pearlPriceControl:SetText(makeDotMoney(info:getDiscountPrice()))
      pearlPriceControl:SetShow(true)
    else
      mileagePriceControl:SetText(makeDotMoney(info:getDiscountPrice()))
      mileagePriceControl:SetShow(true)
    end
  else
    pearlPriceControl:SetText(makeDotMoney(info:getPearlPrice()))
    pearlPriceControl:SetShow(toInt64(0, 0) < info:getPearlPrice())
    mileagePriceControl:SetText(makeDotMoney(info:getMileagePrice()))
    mileagePriceControl:SetShow(toInt64(0, 0) < info:getMileagePrice())
  end
  UI.getChildControl(control, "StaticText_ProductDesc"):SetText(info:getDescription())
  local groupIndex = info:getOfferGroup()
  local subInfoListSize = getIngameCashMall():getCashProductStaticStatusGroupListCount(groupIndex)
  for i = 0, self._ui._subProductNameControlListSize - 1 do
    local subControl = UI.getChildControl(control, "StaticText_SubProductName" .. i)
    local subName = ""
    local subInfo
    if i < subInfoListSize and subInfoListSize > 1 then
      subInfo = getIngameCashMall():getCashProductStaticStatusGroupByIndex(groupIndex, i)
      subName = subInfo:getDisplaySubName()
      if subInfo:isApplyDiscount() then
        subName = "<PAColor0xfface400>" .. subName
      elseif 5 == subInfo:getTag() then
        subName = "<PAColor0xff33c5b3>" .. subName
      end
    end
    subControl:SetText(subName)
    if i == self._showingSubProductIndex and index == self._showingDescIndex then
      subInfo = getIngameCashMall():getCashProductStaticStatusGroupByIndex(groupIndex, i)
      pearlPriceControl:SetText(makeDotMoney(subInfo:getPearlPrice()))
      subTitleControl:SetText(subName)
      subControl:SetText("<PAColor0xffeeeeee>" .. subName)
      local leftIcon = UI.getChildControl(control, "Static_ProductSubSetLeftIcon")
      local rightIcon = UI.getChildControl(control, "Static_ProductSubSetRightIcon")
      if 350 < subTitleControl:GetTextSizeX() then
        leftIcon:SetSpanSize(-300, 0)
        rightIcon:SetSpanSize(300, 0)
      else
        leftIcon:SetSpanSize(-200, 0)
        rightIcon:SetSpanSize(200, 0)
      end
      if info:isApplyDiscount() then
        discountControl:SetText(makeDotMoney(subInfo:getPearlPrice()))
        pearlPriceControl:SetText(makeDotMoney(subInfo:getDiscountPrice()))
      end
    end
  end
  local subItemCount = info:getItemListCount()
  for i = 0, self._ui._subItemControlListSize - 1 do
    local subControl = UI.getChildControl(control, "Static_ItemSlotBG" .. i)
    local showFlag = i < subItemCount
    subControl:SetShow(showFlag)
    if showFlag then
      local subItemInfo = info:getItemByIndex(i)
      subControl:ChangeTextureInfoNameAsync("icon/" .. subItemInfo:getIconPath())
    end
  end
  local aditionalSubItemCount = info:getSubItemListCount()
  for i = 0, aditionalSubItemCount - 1 do
    local controlIndex = i + subItemCount
    local subControl = UI.getChildControl(control, "Static_ItemSlotBG" .. controlIndex)
    local subItemInfo = info:getSubItemByIndex(i)
    subControl:SetShow(true)
    subControl:ChangeTextureInfoNameAsync("icon/" .. subItemInfo:getIconPath())
  end
  return true
end
function pearlShop:handleCompleteBuy()
  if PaGlobalFunc_PearlShopProductBuyCheckShow() then
    PaGlobalFunc_PearlShopProductBuyClose()
  end
  return true
end
function PaGlobalFunc_PearlShopHandleCompleteBuy()
  if pearlShop:handleCompleteBuy() then
    return pearlShop:update()
  end
end
registerEvent("FromClient_luaLoadComplete", "FromClient_PearlShopInit")
registerEvent("FromClient_UpdateCashShop", "PaGlobalFunc_PearlShopUpdate")
registerEvent("FromClient_UpdateCash", "PaGlobalFunc_PearlShopUpdate")
registerEvent("FromClient_InventoryUpdate", "PaGlobalFunc_PearlShopUpdate")
registerEvent("FromClient_NotifyCompleteBuyProduct", "PaGlobalFunc_PearlShopHandleCompleteBuy")

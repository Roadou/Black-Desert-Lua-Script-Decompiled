local UI_LifeString = CppEnums.LifeExperienceString
local debugValue = 0
local last_Tooltip
local index_Tooltip = {}
Panel_Trade_Market_Graph_Window:setGlassBackground(true)
local tradeGraphMode = {eGraphMode_NormalShopGraph = 0, eGraphMode_TendGraph = 1}
local tradeGraph = {
  slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = false,
    createCash = true
  },
  _itemMaxCount = 9,
  _isNodeLinked = false,
  _isRefreshData = false,
  _commerceGraph_Max = 2,
  _currentCommerceIndex = 1,
  _currentCommerceSize = 1,
  _buyFromNPCOrSellToNPCOrAll = 3,
  _currentScrollIndex = 0,
  _commerceItemCount = 0,
  _commerceFirstSelct = 1,
  _graphDisplayIndex = {},
  _graphBackSizeY = 0,
  _intervalValue = 60,
  _graphIntervalValue = 8,
  _graphMode = tradeGraphMode.eGraphMode_NormalShopGraph,
  _isMouseOn = false,
  _mouseOnIndex = 0,
  _mouseOnCommerceIndexForAll = {},
  _mouseOnOrderIndexForAll = {},
  _buttonExit = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Button_Win_Close"),
  _buttonQuestion = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Button_Question"),
  _buttonTradeList = {
    [enCommerceType.enCommerceType_Luxury_Miscellaneous] = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Button_category_miscellaneous"),
    [enCommerceType.enCommerceType_Luxury] = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Button_category_luxury"),
    [enCommerceType.enCommerceType_Grocery] = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Button_category_grocery"),
    [enCommerceType.enCommerceType_Cloth] = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Button_category_cloth"),
    [enCommerceType.enCommerceType_ObjectSaint] = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Button_category_objetSaint"),
    [enCommerceType.enCommerceType_MilitarySupplies] = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Button_category_militarySupplies"),
    [enCommerceType.enCommerceType_Medicine] = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Button_category_medicine"),
    [enCommerceType.enCommerceType_SeaFood] = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Button_category_SeaFood"),
    [enCommerceType.enCommerceType_RawMaterial] = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Button_category_RawMaterial"),
    [enCommerceType.enCommerceType_Max] = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Button_category_all")
  },
  _dialogSceneIndex = {
    [enCommerceType.enCommerceType_Luxury_Miscellaneous] = 8,
    [enCommerceType.enCommerceType_Luxury] = 7,
    [enCommerceType.enCommerceType_Grocery] = 5,
    [enCommerceType.enCommerceType_Cloth] = 10,
    [enCommerceType.enCommerceType_ObjectSaint] = 11,
    [enCommerceType.enCommerceType_MilitarySupplies] = 12,
    [enCommerceType.enCommerceType_Medicine] = 6,
    [enCommerceType.enCommerceType_SeaFood] = 14,
    [enCommerceType.enCommerceType_RawMaterial] = 13,
    [enCommerceType.enCommerceType_Max] = 0
  },
  _buttonTradePosition = {},
  _staticLines = {
    [enCommerceType.enCommerceType_Luxury_Miscellaneous] = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Line_category_miscellaneous"),
    [enCommerceType.enCommerceType_Luxury] = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Line_category_luxury"),
    [enCommerceType.enCommerceType_Grocery] = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Line_category_grocery"),
    [enCommerceType.enCommerceType_Cloth] = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Line_category_cloth"),
    [enCommerceType.enCommerceType_ObjectSaint] = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Line_category_objetSaint"),
    [enCommerceType.enCommerceType_MilitarySupplies] = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Line_category_militarySupplies"),
    [enCommerceType.enCommerceType_Medicine] = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Line_category_medicine"),
    [enCommerceType.enCommerceType_SeaFood] = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Line_category_seaFood"),
    [enCommerceType.enCommerceType_RawMaterial] = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Line_category_rawMaterial"),
    [enCommerceType.enCommerceType_Max] = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Line_category_All")
  },
  _graphMiniPanel = {},
  _staticCommerceGraphs = {},
  _staticCurrentPoint = {},
  _staticHighPoint = {},
  _staticLowPoint = {},
  _staticCommceName = {},
  _staticText_PermissionMsg = {},
  _staticPriceRate = {},
  _static_PriceIcon = {},
  _static_OriginalPrice = {},
  _static_SupplyCount = {},
  _static_Condition = {},
  _static_GraphBaseLine = {},
  _icons = {},
  _currentBar,
  _graphInfoText = UI.getChildControl(Panel_Trade_Market_Graph_Window, "StaticText_GraphInfo"),
  _staticTitle = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Panel_Title"),
  _staticRectangle = UI.getChildControl(Panel_Trade_Market_Graph_Window, "graphFrame"),
  _staticMiniPanel = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Static_MiniPanel"),
  _staticGraph = UI.getChildControl(Panel_Trade_Market_Graph_Window, "graph_panel"),
  _staticBaseCurrentPoint = UI.getChildControl(Panel_Trade_Market_Graph_Window, "graph_currentPoint"),
  _staticBaseHighPoint = UI.getChildControl(Panel_Trade_Market_Graph_Window, "graph_LowestPoint"),
  _staticBaseLowPoint = UI.getChildControl(Panel_Trade_Market_Graph_Window, "graph_highestPoint"),
  _staticBaseCommerceName = UI.getChildControl(Panel_Trade_Market_Graph_Window, "item_name"),
  _staticTextPermission = UI.getChildControl(Panel_Trade_Market_Graph_Window, "StaticText_Permission"),
  _staticBasePriceRate = UI.getChildControl(Panel_Trade_Market_Graph_Window, "item_quotationRate"),
  _static_BasePriceIcon = UI.getChildControl(Panel_Trade_Market_Graph_Window, "item_sellPrice_goldIcon"),
  _static_OriginalPriceIcon = UI.getChildControl(Panel_Trade_Market_Graph_Window, "item_originalPrice_goldIcon"),
  _static_SupplyCountText = UI.getChildControl(Panel_Trade_Market_Graph_Window, "item_supply_count"),
  _static_ConditionText = UI.getChildControl(Panel_Trade_Market_Graph_Window, "StaticText_ConditionValue"),
  _static_BaseLine = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Static_BasePosition"),
  _scroll = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Scroll_Slot_List"),
  _currentBar = UI.getChildControl(Panel_Trade_Market_Graph_Window, "graph_currentPosition"),
  _button_BuyFromNPC = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Button_BuyFromNPC"),
  _button_SellToNPC = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Button_SellToNPC"),
  _staticTradeItemName = UI.getChildControl(Panel_Trade_Market_Graph_Window, "StaticText_TradeItemName"),
  _staticText_EnableSupplyCount = UI.getChildControl(Panel_Trade_Market_Graph_Window, "StaticText_EnableSupplyCount"),
  _selectTerritory = 0,
  _territoryCount = 0,
  _buttonTerritory = {},
  _buttonGoBackGraph = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Button_Back"),
  _supplyCountPosX = 0
}
tradeGraph._staticBaseCommerceName:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
tradeGraph._staticText_EnableSupplyCount:SetIgnore(false)
tradeGraph._staticText_EnableSupplyCount:addInputEvent("Mouse_On", "TradeSupply_EnableCount_Tooltip(true)")
tradeGraph._staticText_EnableSupplyCount:addInputEvent("Mouse_Out", "TradeSupply_EnableCount_Tooltip(false)")
function TradeSupply_EnableCount_Tooltip(isShow)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name = ""
  local desc = PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarketGraph_DailySupplyCountDesc")
  local uiControl = tradeGraph._staticText_EnableSupplyCount
  TooltipSimple_Show(uiControl, name, desc)
end
local territoryCount = 8
for countIndex = 1, territoryCount do
  tradeGraph._buttonTerritory[countIndex] = UI.getChildControl(Panel_Trade_Market_Graph_Window, "Button_category_Territory_" .. countIndex - 1)
  tradeGraph._buttonTerritory[countIndex]:addInputEvent("Mouse_LUp", "buttonLupTradeGraph_Territory(" .. countIndex .. ")")
end
tradeGraph._buttonGoBackGraph:addInputEvent("Mouse_LUp", "buttonLupGoBackTradeGraph()")
tradeGraph._buttonGoBackGraph:SetShow(false)
local _miniPanel = {}
local _byWorldmapForGraph = false
local miniPanelPosY = 0
local _graphPosY = 0
function tradeGraph:registUIControl()
  local sizeRow = tradeGraph._staticGraph:GetSizeX()
  local sizeCol = tradeGraph._staticGraph:GetSizeY()
  local graphPanelPosX = tradeGraph._staticGraph:GetPosX() - tradeGraph._staticMiniPanel:GetPosX()
  local graphPanelPosY = tradeGraph._staticGraph:GetPosY() - tradeGraph._staticMiniPanel:GetPosY()
  local itemNamePosX = tradeGraph._staticBaseCommerceName:GetPosX() - tradeGraph._staticMiniPanel:GetPosX()
  local itemNamePosY = tradeGraph._staticBaseCommerceName:GetPosY() - tradeGraph._staticMiniPanel:GetPosY()
  local ratePosX = tradeGraph._staticBasePriceRate:GetPosX() - tradeGraph._staticMiniPanel:GetPosX()
  local ratePosY = tradeGraph._staticBasePriceRate:GetPosY() - tradeGraph._staticMiniPanel:GetPosY()
  local currentPricePosX = tradeGraph._static_BasePriceIcon:GetPosX() - tradeGraph._staticMiniPanel:GetPosX()
  local currentPricePosY = tradeGraph._static_BasePriceIcon:GetPosY() - tradeGraph._staticMiniPanel:GetPosY()
  local OriginalPricePosX = tradeGraph._static_OriginalPriceIcon:GetPosX() - tradeGraph._staticMiniPanel:GetPosX()
  local OriginalPricePosY = tradeGraph._static_OriginalPriceIcon:GetPosY() - tradeGraph._staticMiniPanel:GetPosY()
  local permissionMsgPosX = graphPanelPosX
  local permissionMsgPosY = graphPanelPosY + sizeCol / 2 - 15
  for count = 1, tradeGraph._itemMaxCount do
    local miniPanel = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_Trade_Market_Graph_Window, "static_MiniPanel_" .. count)
    CopyBaseProperty(tradeGraph._staticMiniPanel, miniPanel)
    _miniPanel[count] = miniPanel
    miniPanel:SetPosX(tradeGraph._staticRectangle:GetPosX() + 183)
    local staticSizeInterval = tradeGraph._staticRectangle:GetPosY() + sizeCol * (count - 1)
    local posY = staticSizeInterval + tradeGraph._intervalValue * (count - 1)
    miniPanel:SetPosY(posY + 3)
    miniPanel:SetShow(false)
    tradeGraph._graphMiniPanel[count] = miniPanel
    basePosX = miniPanel:GetPosX()
    basePosY = miniPanel:GetPosY()
    local staticGraph = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, miniPanel, "static_Graph" .. count)
    CopyBaseProperty(tradeGraph._staticGraph, staticGraph)
    tradeGraph._staticCommerceGraphs[count] = staticGraph
    tradeGraph._staticCommerceGraphs[count]:addInputEvent("Mouse_On", "NpcTradeGraph_StaticMouseOn(" .. count .. ")")
    tradeGraph._staticCommerceGraphs[count]:addInputEvent("Mouse_Out", "NpcTradeGraph_StaticMouseOut(" .. count .. ")")
    tradeGraph._staticCommerceGraphs[count]:addInputEvent("Mouse_UpScroll", "NpcTradeGraph_ScrollEvent(true)")
    tradeGraph._staticCommerceGraphs[count]:addInputEvent("Mouse_DownScroll", "NpcTradeGraph_ScrollEvent(false)")
    staticGraph:SetPosX(graphPanelPosX - 2)
    staticGraph:SetPosY(graphPanelPosY)
    local slot = {}
    slot.icon = {}
    SlotItem.new(slot.icon, "GraphItem_" .. count, count, miniPanel, tradeGraph.slotConfig)
    slot.icon:createChild()
    slot.icon.icon:addInputEvent("Mouse_On", "Tooltip_Item_Show_TradeMarket(" .. count .. ", true)")
    slot.icon.icon:addInputEvent("Mouse_Out", "Tooltip_Item_Show_TradeMarket(" .. count .. ", false)")
    slot.icon.icon:addInputEvent("Mouse_UpScroll", "NpcTradeGraph_ScrollEvent(true)")
    slot.icon.icon:addInputEvent("Mouse_DownScroll", "NpcTradeGraph_ScrollEvent(false)")
    tradeGraph._icons[count] = slot
    slot.icon.icon:SetPosX(3)
    slot.icon.icon:SetPosY(3)
    local staticCommerceName = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, miniPanel, "static_ItemName" .. count)
    CopyBaseProperty(tradeGraph._staticBaseCommerceName, staticCommerceName)
    tradeGraph._staticCommceName[count] = staticCommerceName
    staticCommerceName:SetPosX(slot.icon.icon:GetPosX() + slot.icon.icon:GetSizeX() + 3)
    staticCommerceName:SetPosY(-4)
    local staticTextPermission = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, miniPanel, "StaticText_Permission" .. count)
    CopyBaseProperty(tradeGraph._staticTextPermission, staticTextPermission)
    tradeGraph._staticText_PermissionMsg[count] = staticTextPermission
    staticTextPermission:SetPosX(permissionMsgPosX)
    staticTextPermission:SetPosY(permissionMsgPosY)
    staticTextPermission:SetShow(false)
    local staticPriceRate = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, miniPanel, "item_quotationRate" .. count)
    CopyBaseProperty(tradeGraph._staticBasePriceRate, staticPriceRate)
    tradeGraph._staticPriceRate[count] = staticPriceRate
    staticPriceRate:SetPosX(ratePosX + 30)
    staticPriceRate:SetPosY(ratePosY - 1)
    staticPriceRate:SetShow(false)
    staticPriceRate:SetIgnore(false)
    local static_PriceIcon = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, miniPanel, "item_sellPrice_goldIcon_" .. count)
    CopyBaseProperty(tradeGraph._static_BasePriceIcon, static_PriceIcon)
    tradeGraph._static_PriceIcon[count] = static_PriceIcon
    static_PriceIcon:SetPosX(ratePosX + 110)
    static_PriceIcon:SetPosY(ratePosY - 5)
    static_PriceIcon:SetShow(false)
    if isGameTypeSA() then
      static_PriceIcon:ChangeTextureInfoName("")
      static_PriceIcon:SetTextSpan(0, 0)
    end
    local static_OriginalPrice = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, miniPanel, "item_Original_goldIcon_" .. count)
    CopyBaseProperty(tradeGraph._static_OriginalPriceIcon, static_OriginalPrice)
    tradeGraph._static_OriginalPrice[count] = static_OriginalPrice
    static_OriginalPrice:SetPosX(OriginalPricePosX)
    static_OriginalPrice:SetPosY(OriginalPricePosY - 3)
    static_OriginalPrice:SetShow(false)
    if isGameTypeSA() then
      static_OriginalPrice:ChangeTextureInfoName("")
      static_OriginalPrice:SetTextSpan(5, 0)
    end
    local static_SupplyCount = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, miniPanel, "item_Supply_count_" .. count)
    CopyBaseProperty(tradeGraph._static_SupplyCountText, static_SupplyCount)
    tradeGraph._static_SupplyCount[count] = static_SupplyCount
    static_SupplyCount:SetPosX(OriginalPricePosX + static_OriginalPrice:GetSizeX())
    static_SupplyCount:SetPosY(OriginalPricePosY + 14)
    static_SupplyCount:SetShow(false)
    local static_ConditionText = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, miniPanel, "item_Condition_" .. count)
    CopyBaseProperty(tradeGraph._static_ConditionText, static_ConditionText)
    tradeGraph._static_Condition[count] = static_ConditionText
    static_ConditionText:SetPosX(ratePosX - 30)
    static_ConditionText:SetPosY(OriginalPricePosY + 14)
    static_ConditionText:SetShow(false)
    local staticCurrentPoint = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, miniPanel, "static_CurrentPoint" .. count)
    CopyBaseProperty(tradeGraph._staticBaseCurrentPoint, staticCurrentPoint)
    tradeGraph._staticCurrentPoint[count] = staticCurrentPoint
    local staticHighPoint = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, miniPanel, "static_HigePoint" .. count)
    CopyBaseProperty(tradeGraph._staticBaseHighPoint, staticHighPoint)
    tradeGraph._staticHighPoint[count] = staticHighPoint
    local staticLowPoint = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, miniPanel, "static_LowPoint" .. count)
    CopyBaseProperty(tradeGraph._staticBaseLowPoint, staticLowPoint)
    tradeGraph._staticLowPoint[count] = staticLowPoint
    local staticBaseLine = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, miniPanel, "static_BaseLine" .. count)
    CopyBaseProperty(tradeGraph._static_BaseLine, staticBaseLine)
    tradeGraph._static_GraphBaseLine[count] = staticBaseLine
  end
  tradeGraph._supplyCountPosX = tradeGraph._static_SupplyCount[1]:GetPosX()
  tradeGraph._graphBackSizeY = tradeGraph._staticCommerceGraphs[1]:GetSizeY()
  miniPanelPosY = _miniPanel[1]:GetPosY()
  _graphPosY = tradeGraph._staticCommerceGraphs[1]:GetPosY()
  for btnIndex = 1, enCommerceType.enCommerceType_Max - 1 do
    local position = {x = 0, y = 0}
    position.x = tradeGraph._buttonTradeList[btnIndex]:GetPosX()
    position.y = tradeGraph._buttonTradeList[btnIndex]:GetPosY()
    tradeGraph._buttonTradePosition[btnIndex] = position
  end
  tradeGraph._scroll:SetPosX(tradeGraph._staticRectangle:GetPosX() + tradeGraph._staticRectangle:GetSizeX() - 10)
  tradeGraph._scroll:SetPosY(tradeGraph._staticRectangle:GetPosY())
  tradeGraph._scroll:SetControlPos(0)
  tradeGraph._staticGraph:SetShow(false)
  Panel_Trade_Market_Graph_Window:SetChildIndex(tradeGraph._graphInfoText, 9999)
end
local function setGraphMiniPanel(index, isShow)
  tradeGraph._graphMiniPanel[index]:SetShow(isShow)
  local staticGraph = tradeGraph._staticCommerceGraphs[index]
  staticGraph:SetShow(isShow)
  staticGraph:SetGraphMode(isShow)
  tradeGraph._icons[index].icon.icon:SetShow(isShow)
  tradeGraph._staticCurrentPoint[index]:SetShow(isShow)
  tradeGraph._staticLowPoint[index]:SetShow(isShow)
  tradeGraph._staticHighPoint[index]:SetShow(isShow)
  tradeGraph._staticCommceName[index]:SetShow(isShow)
  tradeGraph._staticText_PermissionMsg[index]:SetShow(isShow)
  tradeGraph._staticPriceRate[index]:SetShow(isShow)
  tradeGraph._static_PriceIcon[index]:SetShow(isShow)
  tradeGraph._static_OriginalPrice[index]:SetShow(isShow)
  tradeGraph._static_GraphBaseLine[index]:SetShow(isShow)
end
function NpcTradeGraph_StaticMouseOn(index)
  if false == isGraphMode(tradeGraphMode.eGraphMode_NormalShopGraph) then
    return
  end
  tradeGraph._isMouseOn = true
  tradeGraph._mouseOnIndex = index
  tradeGraph._currentBar:SetShow(true)
  tradeGraph._graphInfoText:SetShow(true)
end
function NpcTradeGraph_StaticMouseOut(index)
  if false == isGraphMode(tradeGraphMode.eGraphMode_NormalShopGraph) then
    return
  end
  tradeGraph._isMouseOn = false
  tradeGraph._mouseOnIndex = 0
  tradeGraph._currentBar:SetShow(false)
  tradeGraph._graphInfoText:SetShow(false)
end
function setChangeGraphMode(graphMode)
  tradeGraph._graphMode = graphMode
end
function isGraphMode(graphMode)
  if tradeGraph._graphMode == graphMode then
    return true
  end
  return false
end
function updateTradeMarketGraphData(deltaTime)
  if false == tradeGraph._isMouseOn then
    return
  end
  if false == isGraphMode(tradeGraphMode.eGraphMode_NormalShopGraph) then
    return
  end
  tradeGraph._staticTradeItemName:SetShow(false)
  local mousePosX = getMousePosX()
  local mousePosY = getMousePosY()
  local commerceUI = tradeGraph._staticCommerceGraphs[tradeGraph._mouseOnIndex]
  if nil == commerceUI then
    return
  end
  local mousePosXInUI = commerceUI:GetPosX() + mousePosX - commerceUI:GetParentPosX() - 3
  local mousePosYInUI = commerceUI:GetPosY()
  tradeGraph._currentBar:SetPosX(commerceUI:GetParentPosX() + mousePosXInUI)
  tradeGraph._currentBar:SetPosY(commerceUI:GetParentPosY())
  tradeGraph._graphInfoText:SetPosX(commerceUI:GetParentPosX() + mousePosXInUI + 8)
  tradeGraph._graphInfoText:SetPosY(commerceUI:GetParentPosY() + tradeGraph._currentBar:GetSizeY() / 2)
  local posIndex = math.floor(mousePosXInUI / tradeGraph._graphIntervalValue)
  if posIndex < 0 or posIndex > 30 then
    return
  end
  local findCommercetType = -1
  local findOrderIndex = -1
  if nil == tradeGraph._graphDisplayIndex[tradeGraph._mouseOnIndex] then
    return
  end
  findOrderIndex = tradeGraph._graphDisplayIndex[tradeGraph._mouseOnIndex]
  findCommercetType = tradeGraph._currentCommerceIndex
  if nil == findOrderIndex then
    return
  end
  local itemKey = npcShop_GetCommerceItemByIndexAndSellOrBuy(findCommercetType, tradeGraph._buyFromNPCOrSellToNPCOrAll, findOrderIndex - 1)
  if 0 ~= itemKey then
    local currentPosPrice = npcShop_getTadePastPrice(itemKey, posIndex)
    local itemESSW = getItemEnchantStaticStatus(ItemEnchantKey(itemKey))
    if -1 == currentPosPrice then
      if 1 == debugValue then
        local sellPrice = npcShop_getTradeItem(itemKey)
        tradeGraph._graphInfoText:SetText("PositionX : " .. mousePosXInUI .. [[

  posIndex : ]] .. posIndex .. [[

  Price : ]] .. tostring(sellPrice))
      else
        tradeGraph._graphInfoText:SetText("")
      end
      return
    end
    if 1 == debugValue then
      tradeGraph._graphInfoText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_GRAPH_NAME") .. itemESSW:getName() .. "(" .. itemKey .. ")" .. [[

 PositionX : ]] .. mousePosXInUI .. [[

  posIndex : ]] .. posIndex .. [[

  Price : ]] .. currentPosPrice .. [[

 commerceType : ]] .. findCommercetType .. [[

 index : ]] .. findOrderIndex)
    else
      tradeGraph._graphInfoText:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "Lua_TradeMarketGraph_currentPrice", "currentPosPrice", currentPosPrice))
    end
  end
end
local function commerceGraphInitialize()
  for count = 1, tradeGraph._itemMaxCount do
    setGraphMiniPanel(count, false)
  end
  tradeGraph._currentBar:SetShow(false)
end
function global_updateCommerceInfoByType(commerceIndex, isSellorBuy)
  Panel_Trade_Market_Graph_Window:ResetRadiobutton(tradeGraph._buttonTradeList[1]:GetGroupNumber())
  if 1 == isSellorBuy then
    tradeGraph._currentScrollIndex = 0
  end
  tradeGraph._buyFromNPCOrSellToNPCOrAll = isSellorBuy
  for lineCount = 1, enCommerceType.enCommerceType_Max - 1 do
    tradeGraph._staticLines[lineCount]:SetShow(false)
  end
  check_Empty_CommerceDataALL()
  tradeGraph.updateCommerceInfo(commerceIndex)
  local commerceCount = check_Empty_CommerceData(commerceIndex)
  if 0 == commerceCount then
    tradeGraph._staticLines[tradeGraph._currentCommerceIndex]:SetShow(false)
  end
  setBuySellButtonClick()
end
function tradeGraph.updateCommerceInfo(commerceIndex)
  commerceGraphInitialize()
  local commerceItemSize = npcShop_getCommerceItemSize(commerceIndex)
  if commerceItemSize <= 0 then
    return
  end
  tradeGraph._currentCommerceIndex = commerceIndex
  tradeGraph._currentCommerceSize = commerceItemSize
  setCommerceButtonClick(tradeGraph._currentCommerceIndex)
  tradeGraph.updateTradeProduct()
end
local territorySupplyCheck = false
local _byWorldmap = false
function global_CommerceGraphDataInit(byWorldmap)
  local characterStaticStatusWrapper = npcShop_getCurrentCharacterKeyForTrade()
  local characterStaticStatus = characterStaticStatusWrapper:get()
  local talker = dialog_getTalker()
  if nil ~= talker then
    local npcActorproxy = talker:get()
    if nil ~= npcActorproxy then
      local npcPosition = npcActorproxy:getPosition()
      local npcRegionInfo = getRegionInfoByPosition(npcPosition)
      local npcTradeNodeName = npcRegionInfo:getTradeExplorationNodeName()
      local npcTradeOriginRegion = npcRegionInfo:get():getTradeOriginRegion()
      tradeGraph._isNodeLinked = checkSelfplayerNode(npcTradeOriginRegion._waypointKey, true)
    end
  end
  setChangeGraphMode(tradeGraphMode.eGraphMode_NormalShopGraph)
  if characterStaticStatus:isTerritorySupplyMerchant() then
    tradeGraph._buyFromNPCOrSellToNPCOrAll = 2
    tradeGraph._button_SellToNPC:SetShow(false)
    tradeGraph._button_BuyFromNPC:SetShow(false)
    Panel_Trade_Market_BuyItemList:SetShow(false)
    territorySupplyCheck = true
    eventResetScreenSizeTrade(true)
  elseif characterStaticStatus:isTerritoryTradeMerchant() then
    tradeGraph._buyFromNPCOrSellToNPCOrAll = 1
    tradeGraph._button_SellToNPC:SetShow(true)
    tradeGraph._button_BuyFromNPC:SetShow(true)
    territorySupplyCheck = false
    eventResetScreenSizeTrade(false)
  elseif characterStaticStatus:isSupplyMerchant() or characterStaticStatus:isFishSupplyMerchant() or characterStaticStatus:isGuildSupplyShopMerchant() then
    tradeGraph._buyFromNPCOrSellToNPCOrAll = 3
    tradeGraph._button_SellToNPC:SetShow(false)
    tradeGraph._button_BuyFromNPC:SetShow(false)
    Panel_Trade_Market_BuyItemList:SetShow(false)
    territorySupplyCheck = true
    if characterStaticStatus:isGuildSupplyShopMerchant() then
      territorySupplyCheck = false
    end
    eventResetScreenSizeTrade(true)
    FGlobal_RemainItemDesc_Hide()
  else
    tradeGraph._buyFromNPCOrSellToNPCOrAll = 1
    tradeGraph._button_SellToNPC:SetShow(true)
    tradeGraph._button_BuyFromNPC:SetShow(true)
    territorySupplyCheck = false
    eventResetScreenSizeTrade(false)
  end
  if nil == byWorldmap then
    byWorldmap = false
  end
  if true == byWorldmap then
    Panel_Trade_Market_Graph_Window:SetPosX(getScreenSizeX() - Panel_Trade_Market_Graph_Window:GetSizeX())
    Panel_Trade_Market_Graph_Window:SetPosY(50)
  else
    Panel_Trade_Market_Graph_Window:SetPosX(0)
    Panel_Trade_Market_Graph_Window:SetPosY(0)
  end
  refreshGraphData()
  for countIndex = 1, territoryCount do
    local trendItemSizeInTerritory = ToClient_TrendTradeItemSize(countIndex - 1)
    tradeGraph._buttonTerritory[countIndex]:SetShow(false)
  end
  if isGraphMode(tradeGraphMode.eGraphMode_NormalShopGraph) then
    Panel_Trade_Market_Graph_Window:SetEnableArea(0, 0, Panel_Trade_Market_Graph_Window:GetSizeX(), Panel_Trade_Market_Graph_Window:GetSizeY())
    if characterStaticStatus:isNormalTradeMerchant() then
      resetTrendGraphButton(false)
      tradeGraph._buttonGoBackGraph:SetShow(false)
    end
  end
  _byWorldmap = byWorldmap
  tradeGraph.updateTradeProduct()
  Panel_Trade_Market_Graph_Window:ResetRadiobutton(tradeGraph._buttonTradeList[1]:GetGroupNumber())
  Panel_Trade_Market_Graph_Window:ResetRadiobutton(tradeGraph._button_BuyFromNPC:GetGroupNumber())
  setCommerceButtonClick(tradeGraph._currentCommerceIndex)
  setBuySellButtonClick()
  local typeIndex = tradeGraph._dialogSceneIndex[tradeGraph._currentCommerceIndex]
  if 0 ~= typeIndex and false == byWorldmap and true == tradeGraph._isNodeLinked and not characterStaticStatus:isTerritorySupplyMerchant() then
    global_buyListOpen(commerceCategory[typeIndex].Type)
  end
end
function tradeGraph.updateTradeProduct()
  tradeGraph._scroll:SetShow(true)
  local commerceCount = 0
  if 1 == tradeGraph._buyFromNPCOrSellToNPCOrAll then
    commerceCount = check_Empty_CommerceData(tradeGraph._currentCommerceIndex)
  else
    commerceCount = npcShop_getCommerceItemSize(tradeGraph._currentCommerceIndex)
  end
  local showCount = 0
  local scrollIndex = tradeGraph._currentScrollIndex
  index_Tooltip = {}
  for count = 1, commerceCount do
    if showCount == tradeGraph._commerceGraph_Max then
      break
    end
    local itemKey = npcShop_GetCommerceItemByIndexAndSellOrBuy(tradeGraph._currentCommerceIndex, tradeGraph._buyFromNPCOrSellToNPCOrAll, scrollIndex + count - 1)
    if 0 ~= itemKey then
      showCount = showCount + 1
      tradeGraph.tradeMarket_DrawGraph(tradeGraph._currentCommerceIndex, itemKey, showCount, scrollIndex + count)
      tradeGraph._graphDisplayIndex[showCount] = scrollIndex + count
    end
  end
  tradeGraph._commerceItemCount = commerceCount
  UIScroll.SetButtonSize(tradeGraph._scroll, tradeGraph._commerceGraph_Max, commerceCount)
  tradeGraph:registTradeGraphEvent()
  local characterStaticStatusWrapper = npcShop_getCurrentCharacterKeyForTrade()
  local characterStaticStatus = characterStaticStatusWrapper:get()
  if nil ~= characterStaticStatus then
    if characterStaticStatus:isSupplyMerchant() then
      local territoryKeyRaw = ToClient_getDefaultTerritoryKey()
      local explorePoint = ToClient_getExplorePointByTerritoryRaw(territoryKeyRaw)
      local maxExpPoint = explorePoint:getAquiredPoint()
      local leftCount = tostring(getSelfPlayer():get():getTradeSupplyCount()) .. " / " .. tostring(math.floor(maxExpPoint / FromClient_getTradeSupplyCount()))
      tradeGraph._staticText_EnableSupplyCount:SetShow(true)
      tradeGraph._staticText_EnableSupplyCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "Lua_TradeMarketGraph_DailySupplyCount", "count", tostring(leftCount)))
    else
      tradeGraph._staticText_EnableSupplyCount:SetShow(false)
    end
  else
    tradeGraph._staticText_EnableSupplyCount:SetShow(false)
  end
end
local itemset = {}
local itemsetIndex = 0
function global_TradeMarketGraph_StaticStatus(index)
  local itemKey = npcShop_GetCommerceItemByIndexAndSellOrBuy(itemset[index].commerceIndex, tradeGraph._buyFromNPCOrSellToNPCOrAll, itemset[index].index)
  if 0 == itemKey then
    return
  end
  return getItemEnchantStaticStatus(ItemEnchantKey(itemKey))
end
local calcuateY = function(src, dest)
  if src <= dest then
    dest = dest - src
  elseif src >= dest then
    dest = src - dest
  else
    dest = src
  end
  return dest
end
local miniPanelSizeY = tradeGraph._staticMiniPanel:GetSizeY()
function tradeGraph.tradeMarket_DrawGraph(commerceIndexForGraph, itemKey, UIIndex, itemOrderIndex)
  local commerceUI = tradeGraph._staticCommerceGraphs[UIIndex]
  commerceUI:ClearGraphList()
  local intervalPosY = tradeGraph._graphBackSizeY / 2
  commerceUI:setGraphBasePos(intervalPosY)
  tradeGraph._graphMiniPanel[UIIndex]:SetShow(true)
  local itemESSW = getItemEnchantStaticStatus(ItemEnchantKey(itemKey))
  local itemStatus = itemESSW:get()
  tradeGraph._icons[UIIndex].icon:setItemByStaticStatus(itemESSW)
  tradeGraph._icons[UIIndex].icon.icon:SetShow(true)
  itemset[itemsetIndex] = {
    commerceIndex = commerceIndexForGraph,
    index = itemOrderIndex - 1
  }
  Panel_Tooltip_Item_SetPosition(itemsetIndex, tradeGraph._icons[UIIndex].icon, "tradeMarket")
  index_Tooltip[UIIndex] = itemsetIndex
  itemsetIndex = itemsetIndex + 1
  local originalPrice = itemESSW:getOriginalPriceByInt64()
  tradeGraph._static_OriginalPrice[UIIndex]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "Lua_TradeMarketGraph_OriginalPrice", "OriginalPrice", makeDotMoney(originalPrice)))
  local tradeItemWrapper = npcShop_getTradeItem(itemKey)
  local sellPrice = tradeItemWrapper:getTradeSellPrice()
  tradeGraph._static_PriceIcon[UIIndex]:SetText(makeDotMoney(sellPrice))
  tradeGraph._static_PriceIcon[UIIndex]:SetPosX(tradeGraph._staticBasePriceRate:GetPosX() - tradeGraph._staticMiniPanel:GetPosX() + tradeGraph._static_PriceIcon[UIIndex]:GetTextSizeX() - 2 + 150)
  if true == territorySupplyCheck then
    local _s64_leftCount = tradeItemWrapper:getLeftCount()
    if Defines.s64_const.s64_0 == _s64_leftCount then
      tradeGraph._static_SupplyCount[UIIndex]:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_5"))
    else
      local _leftCount = Int64toInt32(_s64_leftCount)
      tradeGraph._static_SupplyCount[UIIndex]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEMARKET_GRAPH_SUPPLYCOUNT", "leftCount", _leftCount))
    end
    tradeGraph._static_SupplyCount[UIIndex]:SetShow(true)
    local _gap = tradeGraph._static_SupplyCount[UIIndex]:GetSizeY() + tradeGraph._static_SupplyCount[UIIndex]:GetPosY() - tradeGraph._static_OriginalPrice[UIIndex]:GetPosY()
    _miniPanel[UIIndex]:SetSize(_miniPanel[UIIndex]:GetSizeX(), miniPanelSizeY + _gap)
    _miniPanel[UIIndex]:SetPosY(miniPanelPosY + (UIIndex - 1) * (miniPanelSizeY + _gap))
    commerceUI:SetPosY(_graphPosY + _gap)
    tradeGraph._staticTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_7"))
    tradeGraph._staticTradeItemName:SetShow(false)
    tradeGraph._static_Condition[UIIndex]:SetShow(false)
  elseif 1 == tradeGraph._buyFromNPCOrSellToNPCOrAll and true == _byWorldmap then
    local buyableStack = tradeItemWrapper:getRemainStackCount()
    tradeGraph._static_SupplyCount[UIIndex]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEMARKET_GRAPH_BUYABLESTACK", "buyableStack", tostring(buyableStack)))
    tradeGraph._static_SupplyCount[UIIndex]:SetShow(true)
    local needLifeType = tradeItemWrapper:get():getNeedLifeType()
    local needLifeLevel = tradeItemWrapper:get():getNeedLifeLevel()
    local conditionLevel, conditionTypeName
    if _ContentsGroup_isUsedNewCharacterInfo == false then
      conditionLevel = FGlobal_CraftLevel_Replace(needLifeLevel + 1, needLifeType)
      conditionTypeName = FGlobal_CraftType_ReplaceName(needLifeType)
    else
      conditionLevel = FGlobal_UI_CharacterInfo_Basic_Global_CraftLevelReplace(needLifeLevel + 1)
      conditionTypeName = UI_LifeString[needLifeType]
    end
    local buyingConditionValue = ""
    if 0 == needLifeLevel or nil == needLifeLevel then
      buyingConditionValue = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_GRAPH_NOPE")
      tradeGraph._static_Condition[UIIndex]:SetText(buyingConditionValue)
      tradeGraph._static_Condition[UIIndex]:SetFontColor(Defines.Color.C_FFC4BEBE)
    else
      local player = getSelfPlayer()
      local playerGet = player:get()
      local playerThisCraftLevel = playerGet:getLifeExperienceLevel(needLifeType)
      if needLifeLevel < playerThisCraftLevel then
        tradeGraph._static_Condition[UIIndex]:SetFontColor(Defines.Color.C_FFC4BEBE)
        buyingConditionValue = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_TRADEMARKET_GRAPH_BUYINGCONDITION", "conditionTypeName", conditionTypeName, "conditionLevel", conditionLevel)
      else
        buyingConditionValue = PAGetStringParam2(Defines.StringSheet_GAME, "LUA_TRADEMARKET_GRAPH_BUYINGCONDITION", "conditionTypeName", conditionTypeName, "conditionLevel", conditionLevel)
        tradeGraph._static_Condition[UIIndex]:SetFontColor(Defines.Color.C_FF775555)
      end
      tradeGraph._static_Condition[UIIndex]:SetText(buyingConditionValue)
    end
    local conditionSizeX = tradeGraph._static_Condition[UIIndex]:GetTextSizeX()
    local conditionPosX = tradeGraph._static_Condition[UIIndex]:GetPosX()
    local supplySizeX = tradeGraph._static_SupplyCount[UIIndex]:GetTextSizeX()
    local supplyPosX = tradeGraph._static_SupplyCount[UIIndex]:GetPosX()
    if tradeGraph._supplyCountPosX < conditionSizeX + conditionPosX + 80 then
      tradeGraph._static_SupplyCount[UIIndex]:SetPosX(tradeGraph._supplyCountPosX + 10)
    else
      tradeGraph._static_SupplyCount[UIIndex]:SetPosX(tradeGraph._supplyCountPosX)
    end
    tradeGraph._static_Condition[UIIndex]:SetShow(true)
    local _gap = tradeGraph._static_SupplyCount[UIIndex]:GetSizeY()
    _miniPanel[UIIndex]:SetSize(_miniPanel[UIIndex]:GetSizeX(), miniPanelSizeY + _gap)
    _miniPanel[UIIndex]:SetPosY(miniPanelPosY + (UIIndex - 1) * (miniPanelSizeY + _gap))
    commerceUI:SetPosY(_graphPosY + _gap)
  else
    tradeGraph._static_SupplyCount[UIIndex]:SetShow(false)
    tradeGraph._static_Condition[UIIndex]:SetShow(false)
    _miniPanel[UIIndex]:SetSize(tradeGraph._staticMiniPanel:GetSizeX(), miniPanelSizeY)
    _miniPanel[UIIndex]:SetPosY(miniPanelPosY + (UIIndex - 1) * miniPanelSizeY)
    commerceUI:SetPosY(_graphPosY)
    tradeGraph._staticTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TERRITORYAUTHORITY_KEY_8"))
  end
  local sellRate = string.format("%.f", npcShop_GetTradeGraphRateOfPrice(itemKey))
  if 1 == debugValue then
    tradeGraph._staticPriceRate[UIIndex]:SetText("[ " .. tostring(sellRate) .. "% ]" .. "(" .. itemKey .. ")" .. commerceIndexForGraph .. " " .. itemOrderIndex)
    tradeGraph._staticPriceRate[UIIndex]:SetText("[ " .. tostring(sellRate) .. "% ]" .. "(" .. tostring(sellPrice) .. ")" .. tostring(originalPrice))
  else
    local priceRate_Value = PAGetStringParam1(Defines.StringSheet_GAME, "Lua_TradeMarketGraph_SellRate", "Percent", tostring(sellRate))
    if 100 < tonumber(tostring(sellRate)) then
      priceRate_Value = "<PAColor0xFFFFCE22>" .. priceRate_Value .. "\226\150\178<PAOldColor> / " .. makeDotMoney(sellPrice) .. ""
    else
      priceRate_Value = "<PAColor0xFFF26A6A>" .. priceRate_Value .. "\226\150\188<PAOldColor> / " .. makeDotMoney(sellPrice) .. ""
    end
    tradeGraph._staticPriceRate[UIIndex]:addInputEvent("Mouse_On", "NpcTradeGraph_SimpleToolTip( true, " .. UIIndex .. " )")
    tradeGraph._staticPriceRate[UIIndex]:addInputEvent("Mouse_Out", "NpcTradeGraph_SimpleToolTip( false, " .. UIIndex .. " )")
    tradeGraph._staticPriceRate[UIIndex]:SetText(priceRate_Value)
    tradeGraph._staticPriceRate[UIIndex]:SetPosX(tradeGraph._staticBasePriceRate:GetPosX() - tradeGraph._staticMiniPanel:GetPosX() + tradeGraph._static_PriceIcon[UIIndex]:GetTextSizeX() - 30)
  end
  tradeGraph._static_GraphBaseLine[UIIndex]:SetPosX(commerceUI:GetPosX())
  tradeGraph._static_GraphBaseLine[UIIndex]:SetPosY(commerceUI:GetPosY() + commerceUI:GetSizeY() / 2)
  tradeGraph._static_GraphBaseLine[UIIndex]:SetShow(true)
  commerceUI:SetGraphMode(true)
  commerceUI:SetShow(true)
  if 1 == debugValue then
    tradeGraph._staticCommceName[UIIndex]:SetText(itemESSW:getName() .. "(" .. itemKey .. ")")
  else
    tradeGraph._staticCommceName[UIIndex]:SetText(itemESSW:getName())
  end
  if itemStatus._tradeType == 1 then
    tradeGraph._staticCommceName[UIIndex]:SetFontColor(Defines.Color.C_FFB75EDD)
  else
    tradeGraph._staticCommceName[UIIndex]:SetFontColor(Defines.Color.C_FFE7E7E7)
  end
  tradeGraph._staticCommceName[UIIndex]:SetShow(true)
  tradeGraph._static_OriginalPrice[UIIndex]:SetShow(false)
  if true == tradeItemWrapper:isTradableItem() and (true == tradeGraph._isNodeLinked or true == _byWorldmap) then
    tradeGraph._staticPriceRate[UIIndex]:SetShow(true)
    tradeGraph._static_PriceIcon[UIIndex]:SetShow(true)
  else
    if itemStatus._tradeType == 1 then
      tradeGraph._staticText_PermissionMsg[UIIndex]:SetText(PAGetString(Defines.StringSheet_RESOURCE, "TRADEMARKET_GRAPH_TXT_PERMISSION2"))
    else
      tradeGraph._staticText_PermissionMsg[UIIndex]:SetText(PAGetString(Defines.StringSheet_RESOURCE, "TRADEMARKET_GRAPH_TXT_PERMISSION"))
    end
    tradeGraph._staticText_PermissionMsg[UIIndex]:SetShow(true)
  end
  tradeGraph.tradeMarket_DrawGraphXX(commerceUI, itemKey, UIIndex, tradeItemWrapper, intervalPosY)
end
function tradeGraph.tradeMarket_DrawGraphXX(commerceUI, itemKey, UIIndex, tradeItemWrapper, intervalPosY)
  local priceCountSize = tradeItemWrapper:getGraphSize()
  local minPosition = -1
  local checkMinPos = 9999999
  local maxPosition = -1
  local checkMaxPos = 0
  drawPos = tradeItemWrapper:getGraphPosAt(0)
  if nil == drawPos then
    return
  end
  if false == _byWorldmap and false == tradeGraph._isNodeLinked then
    return
  end
  minPosition = tradeGraph._graphIntervalValue
  maxPosition = tradeGraph._graphIntervalValue
  local value1 = 0
  local value2 = 0
  local value3 = 0
  for count = 1, priceCountSize do
    drawPos = tradeItemWrapper:getGraphPosAt(count - 1)
    if drawPos.y > 100 then
      drawPos.y = 100
    end
    if drawPos.y < -100 then
      drawPos.y = -100
    end
    drawPos.x = tradeGraph._graphIntervalValue * count
    drawPos.y = drawPos.y * intervalPosY
    drawPos.y = drawPos.y / 100
    drawPos.y = calcuateY(intervalPosY, drawPos.y)
    commerceUI:AddGraphPos(drawPos)
    if checkMaxPos <= drawPos.y then
      maxPosition = drawPos.x
      checkMaxPos = drawPos.y
    end
    if checkMinPos > drawPos.y then
      minPosition = drawPos.x
      checkMinPos = drawPos.y
    end
  end
  commerceUI:interpolationGraph()
  local curPostionUI = tradeGraph._staticCurrentPoint[UIIndex]
  curPostionUI:SetPosX(commerceUI:GetPosX() + drawPos.x - curPostionUI:GetSizeX() / 2)
  curPostionUI:SetPosY(commerceUI:GetPosY() + drawPos.y - curPostionUI:GetSizeX() / 2)
  curPostionUI:SetShow(tradeItemWrapper:isTradableItem())
  if priceCountSize > 2 then
    if drawPos.y ~= checkMinPos then
      local lowPostionUI = tradeGraph._staticLowPoint[UIIndex]
      local graphPosY = commerceUI:getinterpolationGraphValue(minPosition)
      lowPostionUI:SetPosX(commerceUI:GetPosX() + minPosition - lowPostionUI:GetSizeX() / 2)
      lowPostionUI:SetPosY(commerceUI:GetPosY() + graphPosY - lowPostionUI:GetSizeY() / 2)
      lowPostionUI:SetShow(true)
    end
    if drawPos.y ~= checkMaxPos then
      local highPostionUI = tradeGraph._staticHighPoint[UIIndex]
      graphPosY = commerceUI:getinterpolationGraphValue(maxPosition)
      highPostionUI:SetPosX(commerceUI:GetPosX() + maxPosition - highPostionUI:GetSizeX() / 2)
      highPostionUI:SetPosY(commerceUI:GetPosY() + graphPosY - highPostionUI:GetSizeY() / 2)
      highPostionUI:SetShow(true)
    end
  end
end
function tradeGraph.CommerceDataShowAll()
  commerceGraphInitialize()
  table.remove(tradeGraph._mouseOnCommerceIndexForAll)
  table.remove(tradeGraph._mouseOnOrderIndexForAll)
  local uiIndexAll = 1
  for commerceIndex = 1, enCommerceType.enCommerceType_Max - 1 do
    local commerceItemSize = npcShop_getCommerceItemSize(commerceIndex)
    for commerceItemCount = 1, commerceItemSize do
      local itemKey = npcShop_GetCommerceItemByIndexAndSellOrBuy(commerceIndex, tradeGraph._buyFromNPCOrSellToNPCOrAll, commerceItemCount - 1)
      if 0 ~= itemKey then
        tradeGraph._mouseOnCommerceIndexForAll[uiIndexAll] = commerceIndex
        tradeGraph._mouseOnOrderIndexForAll[uiIndexAll] = commerceItemCount
        uiIndexAll = uiIndexAll + 1
      end
    end
  end
  tradeGraph._currentCommerceSize = uiIndexAll
  local npcKey = dialog_getTalkNpcKey()
  if 0 ~= npcKey then
    tradeGraph.updateTradeProduct()
  end
end
function npcShop_luaGetCommerceItemByIndexAndCheckSellOrBuy(commerceType, index)
  local itemKey = npcShop_GetCommerceItemByIndex(commerceType, index - 1)
  local checkResult = false
  if 0 ~= itemKey then
    if 1 == tradeGraph._buyFromNPCOrSellToNPCOrAll then
      checkResult = npcShop_CheckBuyFromNPCItem(itemKey)
    elseif 2 == tradeGraph._buyFromNPCOrSellToNPCOrAll then
      checkResult = npcShop_CheckSellToNPCItem(itemKey)
    elseif 3 == tradeGraph._buyFromNPCOrSellToNPCOrAll then
      checkResult = true
    else
      UI.ASSERT(false, "\235\185\132\236\160\149\236\131\129\236\160\129\236\157\184 \234\176\146\236\158\133\235\139\136\235\139\164.")
    end
  end
  return checkResult
end
function check_Empty_CommerceData(commerceType)
  local commerceItemSize = npcShop_getCommerceItemSize(commerceType)
  local UICount = 0
  for ii = 1, commerceItemSize do
    local boolValue = npcShop_luaGetCommerceItemByIndexAndCheckSellOrBuy(commerceType, ii)
    if true == boolValue then
      UICount = UICount + 1
    end
  end
  return UICount
end
function check_Empty_CommerceDataALL()
  local commerceButtonIndex = 1
  local bFirstCommerceType = false
  for commerceIndex = 1, enCommerceType.enCommerceType_Max - 1 do
    local UICount = check_Empty_CommerceData(commerceIndex)
    local lineUI = tradeGraph._buttonTradeList[commerceIndex]
    if 0 == UICount then
      lineUI:SetShow(false)
    else
      if false == bFirstCommerceType then
        bFirstCommerceType = true
        tradeGraph._currentCommerceIndex = commerceIndex
      end
      lineUI:SetShow(true)
      lineUI:SetPosX(tradeGraph._buttonTradePosition[commerceButtonIndex].x)
      lineUI:SetPosY(tradeGraph._buttonTradePosition[commerceButtonIndex].y)
      tradeGraph._staticLines[commerceIndex]:SetPosX(tradeGraph._buttonTradePosition[commerceButtonIndex].x + lineUI:GetSizeX() - 5)
      tradeGraph._staticLines[commerceIndex]:SetPosY(tradeGraph._buttonTradePosition[commerceButtonIndex].y + 7)
      commerceButtonIndex = commerceButtonIndex + 1
    end
  end
end
function buttonLupTradeGraph_CommerceType(commerceIndex)
  if commerceIndex == tradeGraph._currentCommerceIndex then
    if 1 == tradeGraph._buyFromNPCOrSellToNPCOrAll then
      local typeIndex = tradeGraph._dialogSceneIndex[commerceIndex]
      if 0 ~= typeIndex and false == _byWorldmap and true == tradeGraph._isNodeLinked then
        global_buyListOpen(commerceCategory[typeIndex].Type)
      end
    end
    return
  end
  tradeGraph._scroll:SetControlPos(0)
  tradeGraph._currentScrollIndex = 0
  for lineCount = 1, enCommerceType.enCommerceType_Max - 1 do
    tradeGraph._staticLines[lineCount]:SetShow(false)
  end
  tradeGraph._currentCommerceIndex = commerceIndex
  local characterStaticStatusWrapper = npcShop_getCurrentCharacterKeyForTrade()
  if 0 ~= characterStaticStatusWrapper then
    tradeGraph.updateCommerceInfo(commerceIndex)
  end
  if 1 == tradeGraph._buyFromNPCOrSellToNPCOrAll then
    local typeIndex = tradeGraph._dialogSceneIndex[commerceIndex]
    if 0 ~= typeIndex and false == _byWorldmap and true == tradeGraph._isNodeLinked then
      global_buyListOpen(commerceCategory[typeIndex].Type)
    end
  end
end
function global_SellPanel_Refresh(Sell_itemSSS)
  local clickSellItemKey = Sell_itemSSS:get()._key:get()
  local clickSellCommerceType = Sell_itemSSS:getCommerceType()
  if 2 ~= tradeGraph._buyFromNPCOrSellToNPCOrAll then
    click_SellToNPC()
    setBuySellButtonClick()
  end
  local commerceItemSize = npcShop_getCommerceItemSize(clickSellCommerceType)
  local commerceCount = check_Empty_CommerceData(clickSellCommerceType)
  local tempScrollIndex = 0
  if commerceItemSize > tradeGraph._commerceGraph_Max then
    tempScrollIndex = npcShop_getTradeItemIndex(clickSellCommerceType, clickSellItemKey)
    if commerceItemSize < tempScrollIndex + tradeGraph._commerceGraph_Max - 1 then
      tempScrollIndex = commerceItemSize - tradeGraph._commerceGraph_Max
    end
  end
  tradeGraph._currentScrollIndex = tempScrollIndex
  UIScroll.ScrollEvent(tradeGraph._scroll, true, tradeGraph._commerceGraph_Max, commerceCount, tradeGraph._currentScrollIndex, 1)
  global_updateCommerceInfoByType(clickSellCommerceType, 2)
end
function global_updateCurrentCommerce()
  if nil == tradeGraph._currentCommerceIndex then
    return true
  end
  if false == isGraphMode(tradeGraphMode.eGraphMode_NormalShopGraph) then
    return false
  end
  if tradeGraph._currentCommerceIndex > 0 and tradeGraph._currentCommerceIndex < enCommerceType.enCommerceType_Max then
    tradeGraph.updateCommerceInfo(tradeGraph._currentCommerceIndex)
  end
  return true
end
function onScreenResizeTrade()
  eventResetScreenSizeTrade(nil, true)
end
function eventResetScreenSizeTrade(supplyShop, isResize)
  Panel_Trade_Market_Graph_Window:SetSize(Panel_Trade_Market_Graph_Window:GetSizeX(), getScreenSizeY() - Panel_Npc_Trade_Market:GetSizeY())
  tradeGraph._staticRectangle:SetPosY(93)
  local rtSizeY = Panel_Trade_Market_Graph_Window:GetSizeY() - 105
  tradeGraph._staticRectangle:SetSize(tradeGraph._staticRectangle:GetSizeX(), rtSizeY)
  tradeGraph._scroll:SetSize(tradeGraph._scroll:GetSizeX(), rtSizeY)
  local _gap = tradeGraph._static_SupplyCount[1]:GetSizeY() + tradeGraph._static_SupplyCount[1]:GetPosY() - tradeGraph._static_OriginalPrice[1]:GetPosY()
  if nil == supplyShop or not supplyShop then
    _gap = 0
  end
  local miniPanelSizeY = tradeGraph._staticMiniPanel:GetSizeY() + _gap
  local showMiniPanelCount = 0
  tradeGraph._commerceGraph_Max = 1
  for count = 1, tradeGraph._itemMaxCount do
    if rtSizeY > miniPanelSizeY * count then
      showMiniPanelCount = showMiniPanelCount + 1
    else
      break
    end
  end
  if true ~= isResize then
    for count = 1, tradeGraph._itemMaxCount do
      setGraphMiniPanel(count, false)
    end
  end
  tradeGraph._commerceGraph_Max = showMiniPanelCount
end
function refreshGraphData()
  check_Empty_CommerceDataALL()
  tradeGraph.CommerceDataShowAll()
  tradeGraph._scroll:SetControlPos(0)
  tradeGraph._currentScrollIndex = 0
  for lineCount = 1, enCommerceType.enCommerceType_Max - 1 do
    tradeGraph._staticLines[lineCount]:SetShow(false)
  end
  Panel_Trade_Market_Graph_Window:ResetRadiobutton(tradeGraph._buttonTradeList[1]:GetGroupNumber())
  setCommerceButtonClick(tradeGraph._currentCommerceIndex)
end
function setBuySellButtonClick()
  local buttonBaseTexture = tradeGraph._button_BuyFromNPC:getBaseTexture()
  local buttonClickTexture = tradeGraph._button_BuyFromNPC:getClickTexture()
  if 1 == tradeGraph._buyFromNPCOrSellToNPCOrAll then
    tradeGraph._button_BuyFromNPC:setRenderTexture(buttonClickTexture)
    tradeGraph._button_SellToNPC:setRenderTexture(buttonBaseTexture)
  elseif 2 == tradeGraph._buyFromNPCOrSellToNPCOrAll or 3 == tradeGraph._buyFromNPCOrSellToNPCOrAll then
    tradeGraph._button_BuyFromNPC:setRenderTexture(buttonBaseTexture)
    tradeGraph._button_SellToNPC:setRenderTexture(buttonClickTexture)
  else
    UI.ASSERT(false, "\235\185\132\236\160\149\236\131\129\236\160\129\236\157\184 \235\178\136\237\152\184 \236\158\133\235\139\136\235\139\164.")
  end
end
function setCommerceButtonClick(buttonIndex)
  local buttonUI = tradeGraph._buttonTradeList[buttonIndex]
  local btnClickTexture = buttonUI:getClickTexture()
  buttonUI:setRenderTexture(btnClickTexture)
end
function click_BuyFromNPC()
  tradeGraph._buyFromNPCOrSellToNPCOrAll = 1
  refreshGraphData()
  local typeIndex = tradeGraph._dialogSceneIndex[tradeGraph._currentCommerceIndex]
  if 0 ~= typeIndex and false == _byWorldmap and true == tradeGraph._isNodeLinked then
    global_buyListOpen(commerceCategory[typeIndex].Type)
  end
  commerceGraphInitialize()
  tradeGraph.updateTradeProduct()
end
function click_SellToNPC()
  tradeGraph._buyFromNPCOrSellToNPCOrAll = 2
  Panel_Trade_Market_BuyItemList:SetShow(false)
  refreshGraphData()
  commerceGraphInitialize()
  tradeGraph.updateTradeProduct()
end
function trendTradeItemInfoInShop()
  setChangeGraphMode(tradeGraphMode.eGraphMode_TendGraph)
  for count = 1, enCommerceType.enCommerceType_Max - 1 do
    tradeGraph._buttonTradeList[count]:SetShow(false)
  end
  tradeGraph._territoryCount = 8
  resetTrendGraphButton(true)
  Panel_Trade_Market_Graph_Window:SetEnableArea(-30000, -30000, 30000, 30000)
  commerceGraphInitialize()
  tradeGraph._currentScrollIndex = 0
  tradeGraph.updateTrendTradeItem()
  buttonLupTradeGraph_Territory(1)
end
function tradeGraph.updateTrendTradeItem()
  tradeGraph._staticTradeItemName:SetShow(true)
  local scrollIndex = tradeGraph._currentScrollIndex
  local UIIndex = 1
  tradeGraph._scroll:SetShow(true)
  local trendItemSizeInTerritory = ToClient_TrendTradeItemSize(tradeGraph._selectTerritory)
  local territoryInfoWrapper = getTerritoryInfoWrapperByIndex(tradeGraph._selectTerritory)
  tradeGraph._commerceItemCount = trendItemSizeInTerritory
  local territoryKey = territoryInfoWrapper:getKeyRaw()
  for itemCountInTerritory = 1, trendItemSizeInTerritory do
    if itemCountInTerritory + scrollIndex - 1 == trendItemSizeInTerritory then
      break
    end
    local tradeItemWrapper = ToClient_GetTrendTradeItemAt(territoryKey, itemCountInTerritory + scrollIndex - 1)
    if nil ~= tradeItemWrapper then
      local itemSS = tradeItemWrapper:getStaticStatus()
      local itemKey = itemSS:get()._key
      if UIIndex == tradeGraph._commerceGraph_Max + 1 then
        break
      end
      local commerceUI = tradeGraph._staticCommerceGraphs[UIIndex]
      commerceUI:ClearGraphList()
      local intervalPosY = tradeGraph._graphBackSizeY / 2
      commerceUI:setGraphBasePos(intervalPosY)
      tradeGraph._graphMiniPanel[UIIndex]:SetShow(true)
      local itemESSW = getItemEnchantStaticStatus(itemKey)
      local itemStatus = itemESSW:get()
      tradeGraph._icons[UIIndex].icon:setItemByStaticStatus(itemESSW)
      tradeGraph._icons[UIIndex].icon.icon:SetShow(true)
      tradeGraph._icons[UIIndex].icon.icon:addInputEvent("Mouse_On", "Tooltip_Item_Show_TradeMarket(" .. UIIndex .. ", true)")
      tradeGraph._icons[UIIndex].icon.icon:addInputEvent("Mouse_Out", "Tooltip_Item_Show_TradeMarket(" .. UIIndex .. ", false)")
      local originalPrice = itemESSW:getOriginalPriceByInt64()
      tradeGraph._static_OriginalPrice[UIIndex]:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "Lua_TradeMarketGraph_OriginalPrice", "OriginalPrice", makeDotMoney(originalPrice)))
      local sellPrice = tradeItemWrapper:getTradeSellPrice()
      tradeGraph._static_PriceIcon[UIIndex]:SetText(makeDotMoney(sellPrice))
      tradeGraph._static_PriceIcon[UIIndex]:SetPosX(tradeGraph._staticBasePriceRate:GetPosX() - tradeGraph._staticMiniPanel:GetPosX() + 10)
      tradeGraph._static_PriceIcon[UIIndex]:ChangeTextureInfoName("")
      tradeGraph._static_PriceIcon[UIIndex]:SetTextSpan(0, 0)
      local sellRate = Int64toInt32(sellPrice) / Int64toInt32(originalPrice) * 100
      local str_sellRate = string.format("%.f", sellRate)
      local priceRate_Value = PAGetStringParam1(Defines.StringSheet_GAME, "Lua_TradeMarketGraph_SellRate", "Percent", tostring(str_sellRate))
      if 100 < tonumber(tostring(str_sellRate)) then
        priceRate_Value = "(<PAColor0xFFFFCE22>" .. priceRate_Value .. "\226\150\178<PAOldColor>)"
      else
        priceRate_Value = "(<PAColor0xFFF26A6A>" .. priceRate_Value .. "\226\150\188<PAOldColor>)"
      end
      tradeGraph._staticPriceRate[UIIndex]:SetText(priceRate_Value)
      tradeGraph._staticPriceRate[UIIndex]:SetPosX(tradeGraph._static_PriceIcon[UIIndex]:GetPosX() + tradeGraph._static_PriceIcon[UIIndex]:GetSizeX())
      tradeGraph._staticPriceRate[UIIndex]:SetShow(false)
      tradeGraph._static_GraphBaseLine[UIIndex]:SetPosX(commerceUI:GetPosX())
      tradeGraph._static_GraphBaseLine[UIIndex]:SetPosY(commerceUI:GetPosY() + commerceUI:GetSizeY() / 2)
      tradeGraph._static_GraphBaseLine[UIIndex]:SetShow(true)
      commerceUI:SetGraphMode(true)
      commerceUI:SetShow(true)
      local trendItemRegion = tradeItemWrapper:getTrendRegionInfo()
      if 1 == debugValue then
        tradeGraph._staticCommceName[UIIndex]:SetText(trendItemRegion:getAreaName() .. "(" .. itemKey .. ")")
      else
        tradeGraph._staticCommceName[UIIndex]:SetText(trendItemRegion:getAreaName())
      end
      if itemStatus._tradeType == 1 then
        tradeGraph._staticCommceName[UIIndex]:SetFontColor(Defines.Color.C_FFB75EDD)
      else
        tradeGraph._staticCommceName[UIIndex]:SetFontColor(Defines.Color.C_FFE7E7E7)
      end
      tradeGraph._staticCommceName[UIIndex]:SetShow(true)
      tradeGraph._static_OriginalPrice[UIIndex]:SetShow(true)
      if true == tradeItemWrapper:isTradableItem() and (true == tradeGraph._isNodeLinked or true == _byWorldmap) then
        tradeGraph._staticPriceRate[UIIndex]:SetShow(true)
        tradeGraph._static_PriceIcon[UIIndex]:SetShow(true)
      else
        if itemStatus._tradeType == 1 then
          tradeGraph._staticText_PermissionMsg[UIIndex]:SetText(PAGetString(Defines.StringSheet_RESOURCE, "TRADEMARKET_GRAPH_TXT_PERMISSION2"))
        else
          tradeGraph._staticText_PermissionMsg[UIIndex]:SetText(PAGetString(Defines.StringSheet_RESOURCE, "TRADEMARKET_GRAPH_TXT_PERMISSION"))
        end
        tradeGraph._staticText_PermissionMsg[UIIndex]:SetShow(true)
      end
      local graphSize = tradeItemWrapper:getGraphSize()
      tradeGraph.tradeMarket_DrawGraphXX(commerceUI, itemKey:get(), UIIndex, tradeItemWrapper, intervalPosY)
      tradeGraph._graphDisplayIndex[UIIndex] = scrollIndex + UIIndex
      UIIndex = UIIndex + 1
    else
    end
  end
  local _tradeItemWrapper = ToClient_GetTrendTradeItemAt(territoryKey, 1 + scrollIndex)
  if nil ~= _tradeItemWrapper then
    local itemSS = _tradeItemWrapper:getStaticStatus()
    local itemKey = itemSS:get()._key
    local itemESSW = getItemEnchantStaticStatus(itemKey)
    local itemStatus = itemESSW:get()
    local trendName = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_GRAPH_TRENDNAME")
    tradeGraph._staticTradeItemName:SetText(trendName)
    tradeGraph._staticTradeItemName:SetShow(true)
  end
  UIScroll.SetButtonSize(tradeGraph._scroll, tradeGraph._commerceGraph_Max, trendItemSizeInTerritory)
end
function buttonLupTradeGraph_Territory(buttonIndex)
  tradeGraph._selectTerritory = buttonIndex - 1
  tradeGraph._currentScrollIndex = 0
  commerceGraphInitialize()
  for lineCount = 1, enCommerceType.enCommerceType_Max - 1 do
    tradeGraph._staticLines[lineCount]:SetShow(false)
  end
  tradeGraph.updateTrendTradeItem()
  tradeGraph._scroll:SetControlPos(0)
end
function buttonLupGoBackTradeGraph()
  tradeGraph._currentCommerceIndex = 1
  resetTrendGraphButton(false)
  click_BuyFromNPC()
  setChangeGraphMode(tradeGraphMode.eGraphMode_NormalShopGraph)
  Panel_Trade_Market_Graph_Window:SetEnableArea(0, 0, Panel_Trade_Market_Graph_Window:GetSizeX(), Panel_Trade_Market_Graph_Window:GetSizeY())
  npcShop_requestList()
end
function resetTrendGraphButton(isShow)
  if true == isShow then
    for countIndex = 1, tradeGraph._territoryCount do
      local trendItemSizeInTerritory = ToClient_TrendTradeItemSize(countIndex - 1)
      if trendItemSizeInTerritory - 1 >= 0 then
        local territoryInfoWrapper = getTerritoryInfoWrapperByIndex(countIndex - 1)
        tradeGraph._buttonTerritory[countIndex]:SetText(territoryInfoWrapper:getTerritoryName())
        local btnTradeTerritorySizeX = tradeGraph._buttonTerritory[countIndex]:GetSizeX() + 23
        local btnTradeTerritoryTextPosX = btnTradeTerritorySizeX - btnTradeTerritorySizeX / 2 - tradeGraph._buttonTerritory[countIndex]:GetTextSizeX() / 2
        tradeGraph._buttonTerritory[countIndex]:SetShow(true)
      else
        tradeGraph._buttonTerritory[countIndex]:SetShow(false)
      end
    end
  else
    for countIndex = 1, territoryCount do
      local trendItemSizeInTerritory = ToClient_TrendTradeItemSize(countIndex - 1)
      tradeGraph._buttonTerritory[countIndex]:SetShow(false)
    end
  end
  tradeGraph._buttonGoBackGraph:SetShow(isShow)
  tradeGraph._staticTradeItemName:SetShow(false)
  if true == isShow then
    tradeGraph._button_BuyFromNPC:SetShow(false)
    tradeGraph._button_SellToNPC:SetShow(false)
  else
    tradeGraph._button_BuyFromNPC:SetShow(true)
    tradeGraph._button_SellToNPC:SetShow(true)
  end
end
function tradeGraph:registTradeGraphEvent()
  Panel_Trade_Market_Graph_Window:RegisterUpdateFunc("updateTradeMarketGraphData")
  registerEvent("onScreenResize", "onScreenResizeTrade")
  tradeGraph._buttonExit:addInputEvent("Mouse_LUp", "closeNpcTrade_BasketByGraph()")
  local talker = dialog_getTalker()
  if nil ~= talker then
    local actorKeyRaw = talker:getActorKey()
    local actorProxyWrapper = getNpcActor(actorKeyRaw)
    local actorProxy = actorProxyWrapper:get()
    local characterStaticStatus = actorProxy:getCharacterStaticStatus()
    if characterStaticStatus:isSmuggleMerchant() then
      tradeGraph._button_SellToNPC:SetShow(false)
    end
    if characterStaticStatus:isTerritorySupplyMerchant() then
      tradeGraph._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"TerritorySupply\" )")
    elseif characterStaticStatus:isTerritoryTradeMerchant() then
      tradeGraph._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"TerritoryTrade\" )")
    else
      tradeGraph._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelTradeMarketGraph\" )")
    end
  else
    local characterStaticStatusWrapper = npcShop_getCurrentCharacterKeyForTrade()
    if nil == characterStaticStatusWrapper then
      return
    end
    local characterStaticStatus = characterStaticStatusWrapper:get()
    if characterStaticStatus:isTerritorySupplyMerchant() then
      tradeGraph._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"TerritorySupply\" )")
    elseif characterStaticStatus:isTerritoryTradeMerchant() then
      tradeGraph._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"TerritoryTrade\" )")
    else
      tradeGraph._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"PanelTradeMarketGraph\" )")
    end
  end
  tradeGraph._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"PanelTradeMarketGraph\", \"true\")")
  tradeGraph._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"PanelTradeMarketGraph\", \"false\")")
  tradeGraph._button_BuyFromNPC:addInputEvent("Mouse_LUp", "click_BuyFromNPC()")
  tradeGraph._button_SellToNPC:addInputEvent("Mouse_LUp", "click_SellToNPC()")
  UIScroll.InputEvent(tradeGraph._scroll, "NpcTradeGraph_ScrollEvent")
  tradeGraph._staticRectangle:addInputEvent("Mouse_UpScroll", "NpcTradeGraph_ScrollEvent(true)")
  tradeGraph._staticRectangle:addInputEvent("Mouse_DownScroll", "NpcTradeGraph_ScrollEvent(false)")
  for count = 1, enCommerceType.enCommerceType_Max - 1 do
    tradeGraph._buttonTradeList[count]:addInputEvent("Mouse_LUp", "buttonLupTradeGraph_CommerceType(" .. count .. ")")
  end
  registerEvent("FromClient_TrendInfoInShop", "trendTradeItemInfoInShop")
end
function NpcTradeGraph_ScrollEvent(isUpScroll)
  local pre_Index = tradeGraph._currentScrollIndex
  tradeGraph._currentScrollIndex = UIScroll.ScrollEvent(tradeGraph._scroll, isUpScroll, tradeGraph._commerceGraph_Max, tradeGraph._commerceItemCount, tradeGraph._currentScrollIndex, 1)
  local cur_Index = tradeGraph._currentScrollIndex
  commerceGraphInitialize()
  if isGraphMode(tradeGraphMode.eGraphMode_NormalShopGraph) then
    tradeGraph.updateTradeProduct()
  elseif isGraphMode(tradeGraphMode.eGraphMode_TendGraph) then
    tradeGraph.updateTrendTradeItem()
  end
  if last_Tooltip ~= nil and Panel_Tooltip_Item:GetShow() == true then
    Tooltip_Item_Show_TradeMarket(last_Tooltip, true)
  end
end
function Tooltip_Item_Show_TradeMarket(UIIndex, isShow)
  if false == isGraphMode(tradeGraphMode.eGraphMode_NormalShopGraph) then
    return
  end
  if true == isShow then
    last_Tooltip = UIIndex
  elseif false == isShow then
    if last_Tooltip ~= UIIndex then
      return
    end
    last_Tooltip = nil
  end
  local _itemsetIndex = index_Tooltip[UIIndex]
  if _itemsetIndex ~= nil then
    Panel_Tooltip_Item_Show_GeneralStatic(_itemsetIndex, "tradeMarket", isShow)
  end
end
function closeNpcTrade_BasketByGraph()
  if Defines.UIMode.eUIMode_Trade == GetUIMode() then
    closeNpcTrade_Basket()
  else
    WorldMapPopupManager:pop()
  end
end
function NpcTradeGraph_SimpleToolTip(isShow, index)
  if not isShow then
    TooltipSimple_Hide()
    return
  end
  local name, desc, control
  name = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEMARKET_GRAPH_SIMPLETOOLTIP_NAME")
  control = tradeGraph._staticPriceRate[index]
  TooltipSimple_Show(control, name, desc)
end
tradeGraph:registUIControl()
tradeGraph:registTradeGraphEvent()

Panel_WorkerTrade_Caravan:SetShow(false, false)
Panel_WorkerTrade_Caravan:setGlassBackground(true)
Panel_WorkerTrade_Caravan:SetDragAll(true)
Panel_WorkerTrade_Caravan:RegisterShowEventFunc(true, "Panel_WorkerTrade_Caravan_ShowAni()")
Panel_WorkerTrade_Caravan:RegisterShowEventFunc(false, "Panel_WorkerTrade_Caravan_HideAni()")
local UI_TM = CppEnums.TextMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
function Panel_WorkerTrade_Caravan_ShowAni()
  UIAni.fadeInSCR_Down(Panel_WorkerTrade_Caravan)
  local aniInfo1 = Panel_WorkerTrade_Caravan:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_WorkerTrade_Caravan:GetSizeX() / 2
  aniInfo1.AxisY = Panel_WorkerTrade_Caravan:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_WorkerTrade_Caravan:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_WorkerTrade_Caravan:GetSizeX() / 2
  aniInfo2.AxisY = Panel_WorkerTrade_Caravan:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_WorkerTrade_Caravan_HideAni()
  Panel_WorkerTrade_Caravan:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_WorkerTrade_Caravan:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local workerTradeCaravan = {
  control = {
    _closeBtn = UI.getChildControl(Panel_WorkerTrade_Caravan, "Button_Close"),
    _questionBtn = UI.getChildControl(Panel_WorkerTrade_Caravan, "Button_Question"),
    _caravanStatBg = UI.getChildControl(Panel_WorkerTrade_Caravan, "Static_CaravanStatBg"),
    _workerBg = UI.getChildControl(Panel_WorkerTrade_Caravan, "Static_WorkerBg"),
    _assetBg = UI.getChildControl(Panel_WorkerTrade_Caravan, "Static_AssetBg"),
    _itemSetBg = UI.getChildControl(Panel_WorkerTrade_Caravan, "Static_ItemSetBg"),
    _itemWeight = UI.getChildControl(Panel_WorkerTrade_Caravan, "StaticText_WeightIcon"),
    _routerNode = {
      _btnStartNode = UI.getChildControl(Panel_WorkerTrade_Caravan, "Button_StartNode"),
      _btnArrivalNode = UI.getChildControl(Panel_WorkerTrade_Caravan, "Button_ArrivalNode"),
      _btnRouterNode = {
        [1] = UI.getChildControl(Panel_WorkerTrade_Caravan, "Button_RouteNode1"),
        [2] = UI.getChildControl(Panel_WorkerTrade_Caravan, "Button_RouteNode2"),
        [3] = UI.getChildControl(Panel_WorkerTrade_Caravan, "Button_RouteNode3"),
        [4] = UI.getChildControl(Panel_WorkerTrade_Caravan, "Button_RouteNode4"),
        [5] = UI.getChildControl(Panel_WorkerTrade_Caravan, "Button_RouteNode5")
      }
    },
    _list2TradeWorker = UI.getChildControl(Panel_WorkerTrade_Caravan, "List2_TradeWorkerList"),
    _list2TradeItem = UI.getChildControl(Panel_WorkerTrade_Caravan, "List2_TradeItemList"),
    _list2ArrivalNode = UI.getChildControl(Panel_WorkerTrade_Caravan, "List2_ArrivalNodeList"),
    _list2RouteNode = UI.getChildControl(Panel_WorkerTrade_Caravan, "List2_RouteNodeList"),
    _itemListBg = UI.getChildControl(Panel_WorkerTrade_Caravan, "Static_ItemListBg"),
    _tradeItemSlotBg = {},
    _tradeItemSlot = {},
    _tradePrice = UI.getChildControl(Panel_WorkerTrade_Caravan, "StaticText_TradePrice"),
    _btnTradeStart = UI.getChildControl(Panel_WorkerTrade_Caravan, "Button_TradeStart"),
    _tooltip = UI.getChildControl(Panel_WorkerTrade_Caravan, "Static_ItemTooltipBg"),
    _caravanStat = {},
    _worker = {},
    _asset = {},
    _itemSet = {},
    _tooltipItem = {}
  },
  _selectedWorker = {
    [0] = Defines.u64_const.u64_0,
    [1] = Defines.u64_const.u64_0
  },
  _caravanIndex = -1,
  _selectIndex = -1,
  _selectArrNodeIndex = -1,
  _routeNodeIndex = 0,
  _selectRouteNodeIndex = 0,
  _currentSelectRouteNodeCount = 0,
  _currentSelectRouteNodeList = {},
  _allWeight = 0,
  _allPrice = 0,
  _maxCarriageCount = 5,
  _minCarriageCount = 1,
  _maxWorkerCount = 3,
  _minWorkerCount = 2,
  _maxGuardCount = 3,
  _maxFACount = 3,
  tradeItemInfo = {},
  _maxItemCount = 30,
  _itemCountInSlot = {}
}
function workerTradeCaravan:ControlInit()
  local control = self.control
  control._caravanStat = {
    _image = UI.getChildControl(control._caravanStatBg, "Static_CaravanImage"),
    _name = UI.getChildControl(control._caravanStatBg, "StaticText_CaravanName"),
    _speed = UI.getChildControl(control._caravanStatBg, "StaticText_Speed"),
    _luck = UI.getChildControl(control._caravanStatBg, "StaticText_Luck"),
    _defence = UI.getChildControl(control._caravanStatBg, "StaticText_Deffence")
  }
  control._worker = {
    _image = {
      [1] = UI.getChildControl(control._workerBg, "Static_WorkerImage1"),
      [2] = UI.getChildControl(control._workerBg, "Static_WorkerImage2")
    }
  }
  control._asset = {
    _carriage = UI.getChildControl(control._assetBg, "StaticText_Carriage"),
    _worker = UI.getChildControl(control._assetBg, "StaticText_Worker"),
    _guard = UI.getChildControl(control._assetBg, "StaticText_Guard"),
    _FA = UI.getChildControl(control._assetBg, "StaticText_FortuneAmulet"),
    _btnCarriage = UI.getChildControl(control._assetBg, "Static_CarriageIcon"),
    _btnWorker = UI.getChildControl(control._assetBg, "Static_WorkerIcon"),
    _btnGuard = UI.getChildControl(control._assetBg, "Static_GuardIcon"),
    _btnFA = UI.getChildControl(control._assetBg, "Static_FAIcon"),
    _carriageCount = UI.getChildControl(control._assetBg, "StaticText_CarriageCount"),
    _workerCount = UI.getChildControl(control._assetBg, "StaticText_WorkerCount"),
    _guardCount = UI.getChildControl(control._assetBg, "StaticText_GuardCount"),
    _FACount = UI.getChildControl(control._assetBg, "StaticText_FACount")
  }
  control._itemSet = {
    _itemSlotBg = {
      [1] = UI.getChildControl(control._itemSetBg, "Static_ItemSlotBg"),
      [2] = UI.getChildControl(control._itemSetBg, "Static_ItemSlotBg2"),
      [3] = UI.getChildControl(control._itemSetBg, "Static_ItemSlotBg3"),
      [4] = UI.getChildControl(control._itemSetBg, "Static_ItemSlotBg4"),
      [5] = UI.getChildControl(control._itemSetBg, "Static_ItemSlotBg5")
    },
    _itemSetBg = {
      [1] = {},
      [2] = {},
      [3] = {},
      [4] = {},
      [5] = {}
    },
    _btnClose = UI.getChildControl(control._itemListBg, "Button_ItemListClose")
  }
  control._itemListBg:SetShow(false)
  control._itemSlotBg = UI.getChildControl(control._itemListBg, "Static_SlotBg")
  control._itemSlotBg:SetShow(false)
  control._itemSlot = UI.getChildControl(control._itemListBg, "Static_Slot")
  local rowCount = math.ceil(self._maxItemCount / 4)
  for index = 0, rowCount - 1 do
    for cIndex = 0, 3 do
      local realIndex = index * 4 + cIndex
      if realIndex < self._maxItemCount then
        control._tradeItemSlotBg[realIndex] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, control._itemListBg, "TradeItemBg_" .. realIndex)
        CopyBaseProperty(control._itemSlotBg, control._tradeItemSlotBg[realIndex])
        control._tradeItemSlotBg[realIndex]:SetPosX(10 + 60 * cIndex)
        control._tradeItemSlotBg[realIndex]:SetPosY(50 + 60 * index)
        control._tradeItemSlotBg[realIndex]:SetShow(false)
        control._tradeItemSlot[realIndex] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, control._tradeItemSlotBg[realIndex], "TradeItemSlot_" .. realIndex)
        CopyBaseProperty(control._itemSlot, control._tradeItemSlot[realIndex])
        control._tradeItemSlot[realIndex]:SetPosX(2)
        control._tradeItemSlot[realIndex]:SetPosY(2)
      end
    end
  end
  for index = 1, 5 do
    control._itemSet._itemSetBg[index]._itemSlotBg = {}
    control._itemSet._itemSetBg[index]._itemSlotBg[1] = UI.getChildControl(control._itemSet._itemSlotBg[index], "Static_ItemSlotBg1")
    control._itemSet._itemSetBg[index]._itemSlotBg[2] = UI.getChildControl(control._itemSet._itemSlotBg[index], "Static_ItemSlotBg2")
    control._itemSet._itemSetBg[index]._itemSlot = {}
    control._itemSet._itemSetBg[index]._itemSlot[1] = UI.getChildControl(control._itemSet._itemSetBg[index]._itemSlotBg[1], "Static_Slot")
    control._itemSet._itemSetBg[index]._itemSlot[2] = UI.getChildControl(control._itemSet._itemSetBg[index]._itemSlotBg[2], "Static_Slot")
    control._itemSet._itemSetBg[index]._plus = {}
    control._itemSet._itemSetBg[index]._plus[1] = UI.getChildControl(control._itemSet._itemSlotBg[index], "StaticText_Plus1")
    control._itemSet._itemSetBg[index]._plus[2] = UI.getChildControl(control._itemSet._itemSlotBg[index], "StaticText_Plus2")
    control._itemSet._itemSetBg[index]._count = {}
    control._itemSet._itemSetBg[index]._count[1] = UI.getChildControl(control._itemSet._itemSlotBg[index], "StaticText_Count1")
    control._itemSet._itemSetBg[index]._count[2] = UI.getChildControl(control._itemSet._itemSlotBg[index], "StaticText_Count2")
    control._itemSet._itemSetBg[index]._noCarriage = UI.getChildControl(control._itemSet._itemSlotBg[index], "StaticText_NoCarriage")
    self._itemCountInSlot[(index - 1) * 2 + 1] = {}
    self._itemCountInSlot[(index - 1) * 2 + 1]._count = 0
    self._itemCountInSlot[(index - 1) * 2 + 1]._key = 0
    self._itemCountInSlot[(index - 1) * 2 + 2] = {}
    self._itemCountInSlot[(index - 1) * 2 + 2]._count = 0
    self._itemCountInSlot[(index - 1) * 2 + 2]._key = 0
  end
  control._tooltipItem = {
    _slotBg = UI.getChildControl(control._tooltip, "Static_ItemSlotBg"),
    _slot = UI.getChildControl(control._tooltip, "Static_ItemSlot"),
    _name = UI.getChildControl(control._tooltip, "StaticText_ItemName"),
    _price = UI.getChildControl(control._tooltip, "StaticText_Price"),
    _weight = UI.getChildControl(control._tooltip, "StaticText_Weight")
  }
end
function workerTradeCaravan:tradeItemInit()
  for index = 1, 10 do
    self._itemCountInSlot[index]._count = 0
    self._itemCountInSlot[index]._key = 0
  end
end
function workerTradeCaravan:Show(index)
  WorldMapPopupManager:increaseLayer(true)
  WorldMapPopupManager:push(Panel_WorkerTrade_Caravan, true)
  ToClient_RequestClearTempInfo()
  self._selectArrNodeIndex = -1
  self._currentSelectRouteNodeList = {}
  self:tradeItemInit()
  self:SetData(index)
end
function workerTradeCaravan:SetData(index)
  local player = getSelfPlayer()
  if not player then
    return
  end
  local control = self.control
  local tradeCompanyWrapper = ToClient_GetTradeCompanyWrapper()
  local tradeGroupWrapper = tradeCompanyWrapper:getGroup(index - 1)
  if nil == tradeGroupWrapper then
    return
  end
  self._selectIndex = index - 1
  local stat = control._caravanStat
  local familyName = player:getUserNickname()
  local moveSpeed = tradeGroupWrapper:getTradeGroupMoveSpeed()
  local luck = tradeGroupWrapper:getTradeGroupLuck()
  local deffence = tradeGroupWrapper:getTradeGroupDefense()
  stat._name:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_FAMILY", "name", familyName))
  stat._speed:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_SPEED", "speed", tostring(moveSpeed)))
  stat._luck:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_LUCK", "luck", tostring(luck)))
  stat._defence:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_DEFFENCE", "deffence", tostring(deffence)))
  self._selectedWorker[0] = tradeGroupWrapper:getWorkerNo(0)
  if 0 < Int64toInt32(self._selectedWorker[0]) then
    local workerWrapper = getWorkerWrapper(self._selectedWorker[0], true)
    local workerName = workerWrapper:getName()
    control._worker._image[1]:ChangeTextureInfoName(workerWrapper:getWorkerIcon())
    local x1, y1, x2, y2 = setTextureUV_Func(control._worker._image[1], 14, 0, 294, 280)
    control._worker._image[1]:getBaseTexture():setUV(x1, y1, x2, y2)
    control._worker._image[1]:setRenderTexture(control._worker._image[1]:getBaseTexture())
  else
    control._worker._image[1]:ChangeTextureInfoName("/new_ui_common_forlua/window/trade/workertrade_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control._worker._image[1], 1, 1, 121, 121)
    control._worker._image[1]:getBaseTexture():setUV(x1, y1, x2, y2)
    control._worker._image[1]:setRenderTexture(control._worker._image[1]:getBaseTexture())
  end
  self._selectedWorker[1] = tradeGroupWrapper:getWorkerNo(1)
  if 0 < Int64toInt32(self._selectedWorker[1]) then
    local workerWrapper = getWorkerWrapper(self._selectedWorker[1], true)
    local workerName = workerWrapper:getName()
    control._worker._image[2]:ChangeTextureInfoName(workerWrapper:getWorkerIcon())
    local x1, y1, x2, y2 = setTextureUV_Func(control._worker._image[2], 14, 0, 294, 280)
    control._worker._image[2]:getBaseTexture():setUV(x1, y1, x2, y2)
    control._worker._image[2]:setRenderTexture(control._worker._image[2]:getBaseTexture())
  else
    control._worker._image[2]:ChangeTextureInfoName("/new_ui_common_forlua/window/trade/workertrade_00.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(control._worker._image[2], 1, 1, 121, 121)
    control._worker._image[2]:getBaseTexture():setUV(x1, y1, x2, y2)
    control._worker._image[2]:setRenderTexture(control._worker._image[2]:getBaseTexture())
  end
  self:AssetUpdate(index)
  local startRegionInfo = tradeGroupWrapper:getStartRegion()
  if nil ~= startRegionInfo then
    control._routerNode._btnStartNode:SetText(startRegionInfo:getAreaName())
  end
  local arrivalRegionInfo = tradeCompanyWrapper:ToClient_getDestinationRegion()
  if nil ~= arrivalRegionInfo then
    control._routerNode._btnArrivalNode:SetText(arrivalRegionInfo:getAreaName())
  end
  local routeNodeCount = tradeCompanyWrapper:ToClient_getEventNodeCount()
  for rIndex = 1, routeNodeCount do
    local routeNodeInfo = tradeCompanyWrapper:ToClient_getEventNodeRegion(rIndex - 1)
    control._routerNode._btnRouterNode[rIndex]:SetText(routeNodeInfo:getAreaName())
  end
  if routeNodeCount < 5 then
    for rIndex = routeNodeCount + 1, 5 do
      control._routerNode._btnRouterNode[rIndex]:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORKERTRADECARAVAN_ROUTENODETITLE_" .. rIndex))
    end
  end
  local startWayPointKey = WorkerTradeCaravan_StartWayPointKey()
  local carriageCount = tradeGroupWrapper:getTradeGroupCarriage()
  local slotCount, totalWeight = 0, 0
  local totalPrice = makeDotMoney(tradeGroupWrapper:getConsumePrice())
  for iIndex = 1, 5 do
    for slotIndex = 1, 2 do
      if carriageCount < iIndex then
        control._itemSet._itemSetBg[iIndex]._itemSlotBg[slotIndex]:SetShow(false)
        control._itemSet._itemSetBg[iIndex]._itemSlot[slotIndex]:SetShow(false)
        control._itemSet._itemSetBg[iIndex]._plus[slotIndex]:SetShow(false)
        control._itemSet._itemSetBg[iIndex]._count[slotIndex]:SetShow(false)
        control._itemSet._itemSetBg[iIndex]._noCarriage:SetShow(true)
        control._itemSet._itemSetBg[iIndex]._itemSlot[slotIndex]:addInputEvent("Mouse_LUp", "")
      else
        control._itemSet._itemSetBg[iIndex]._itemSlotBg[slotIndex]:SetShow(true)
        control._itemSet._itemSetBg[iIndex]._itemSlot[slotIndex]:SetShow(true)
        control._itemSet._itemSetBg[iIndex]._noCarriage:SetShow(false)
        local itemIndex = (iIndex - 1) * 2 + (slotIndex - 1)
        local tradeItemWrapper = tradeCompanyWrapper:getTempInventoryItem(itemIndex)
        if nil ~= tradeItemWrapper then
          local itemCount = Int64toInt32(tradeItemWrapper:getCount())
          if itemCount > 0 then
            control._itemSet._itemSetBg[iIndex]._itemSlot[slotIndex]:ChangeTextureInfoName("Icon/" .. tradeItemWrapper:getIconPath())
            control._itemSet._itemSetBg[iIndex]._count[slotIndex]:SetShow(true)
            control._itemSet._itemSetBg[iIndex]._count[slotIndex]:SetText(itemCount)
            control._itemSet._itemSetBg[iIndex]._plus[slotIndex]:SetShow(false)
            slotCount = slotCount + 1
            totalWeight = totalWeight + tradeItemWrapper:getWeight() * itemCount
          else
            control._itemSet._itemSetBg[iIndex]._itemSlot[slotIndex]:ChangeTextureInfoName("")
            control._itemSet._itemSetBg[iIndex]._count[slotIndex]:SetShow(false)
            control._itemSet._itemSetBg[iIndex]._plus[slotIndex]:SetShow(true)
          end
        else
          control._itemSet._itemSetBg[iIndex]._itemSlot[slotIndex]:ChangeTextureInfoName("")
          control._itemSet._itemSetBg[iIndex]._count[slotIndex]:SetShow(false)
          control._itemSet._itemSetBg[iIndex]._plus[slotIndex]:SetShow(true)
        end
        control._itemSet._itemSetBg[iIndex]._itemSlot[slotIndex]:addInputEvent("Mouse_LUp", "WorkerTradeCaravan_SelectItem(" .. itemIndex .. ")")
        control._itemSet._itemSetBg[iIndex]._itemSlot[slotIndex]:addInputEvent("Mouse_RUp", "WorkerTradeCaravan_DecreaseItem(" .. itemIndex .. ")")
      end
    end
  end
  local maxWeight = tradeGroupWrapper:getTradeGroupTransportCapacity()
  control._itemWeight:SetText(makeDotMoney(totalWeight) .. " / " .. makeDotMoney(maxWeight))
  control._tradePrice:SetText(makeDotMoney(totalPrice))
  control._list2TradeWorker:SetShow(false)
  control._list2TradeItem:SetShow(false)
  control._list2ArrivalNode:SetShow(false)
  control._list2RouteNode:SetShow(false)
  control._itemListBg:SetShow(false)
  self._currentSelectRouteNodeCount = ToClient_GetWorkerTradeEventNodeCount(startWayPointKey)
  self._routeNodeIndex = 0
  self._currentSelectRouteNodeList = {}
end
function workerTradeCaravan:AssetUpdate(index)
  local tradeCompanyWrapper = ToClient_GetTradeCompanyWrapper()
  local tradeGroupWrapper = tradeCompanyWrapper:getGroup(index - 1)
  if nil == tradeGroupWrapper then
    return
  end
  local groupPorterCount = tradeCompanyWrapper:getTradeCompanyPorter()
  local groupGuardCount = tradeCompanyWrapper:getTradeCompanyGuard()
  local groupCarriageCount = tradeCompanyWrapper:getTradeCompanyCarriage()
  local groupAmuletCount = tradeCompanyWrapper:getTradeCompanyAmulet()
  local porterCount = tradeGroupWrapper:getTradeGroupPorter()
  local guardCount = tradeGroupWrapper:getTradeGroupGuard()
  local carriageCount = tradeGroupWrapper:getTradeGroupCarriage()
  local amuletCount = tradeGroupWrapper:getTradeGroupAmulet()
  local control = self.control
  control._asset._carriage:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_CARRIAGE", "count", groupCarriageCount))
  control._asset._worker:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_PORTER", "count", groupPorterCount))
  control._asset._guard:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_GUARD", "count", groupGuardCount))
  control._asset._FA:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_FA", "count", groupAmuletCount))
  control._asset._carriageCount:SetText(carriageCount)
  control._asset._workerCount:SetText(porterCount)
  control._asset._guardCount:SetText(guardCount)
  control._asset._FACount:SetText(amuletCount)
  local maxPorterCount = carriageCount * self._maxWorkerCount
  if porterCount > maxPorterCount then
    ToClient_RequestSetPorterInTradeGroup(self._selectIndex, maxPorterCount)
  end
end
function WorkerTrade_SetAsset(assetType, increaseCount)
  local self = workerTradeCaravan
  local tradeCompanyWrapper = ToClient_GetTradeCompanyWrapper()
  local tradeGroupWrapper = tradeCompanyWrapper:getGroup(self._selectIndex)
  if nil == tradeGroupWrapper then
    return
  end
  local groupPorterCount = tradeCompanyWrapper:getTradeCompanyPorter()
  local groupGuardCount = tradeCompanyWrapper:getTradeCompanyGuard()
  local groupCarriageCount = tradeCompanyWrapper:getTradeCompanyCarriage()
  local groupAmuletCount = tradeCompanyWrapper:getTradeCompanyAmulet()
  local porterCount = tradeGroupWrapper:getTradeGroupPorter()
  local guardCount = tradeGroupWrapper:getTradeGroupGuard()
  local carriageCount = tradeGroupWrapper:getTradeGroupCarriage()
  local amuletCount = tradeGroupWrapper:getTradeGroupAmulet()
  if 0 == assetType then
    if carriageCount > 0 and increaseCount < 0 then
      local countIndex = (carriageCount - 1) * 2
      if 0 < self._itemCountInSlot[countIndex + 1]._count or 0 < self._itemCountInSlot[countIndex + 2]._count then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_SETALERT_0"))
        return
      end
    end
    carriageCount = carriageCount + increaseCount
    if carriageCount < 0 and -1 == increaseCount then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_SETALERT_1"))
      return
    end
    if carriageCount > self._maxCarriageCount then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_SETALERT_2"))
      return
    end
    if 0 == groupCarriageCount and 1 == increaseCount then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_SETALERT_3"))
      return
    end
    ToClient_RequestSetCarriageInTradeGroup(self._selectIndex, carriageCount)
  elseif 1 == assetType then
    porterCount = porterCount + increaseCount
    if porterCount < 0 and -1 == increaseCount then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_SETALERT_4"))
      return
    end
    if porterCount > carriageCount * self._maxWorkerCount then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_SETALERT_5"))
      return
    end
    if 0 == groupPorterCount and 1 == increaseCount then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_SETALERT_6"))
      return
    end
    ToClient_RequestSetPorterInTradeGroup(self._selectIndex, porterCount)
  elseif 2 == assetType then
    guardCount = guardCount + increaseCount
    if guardCount < 0 and -1 == increaseCount then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_SETALERT_7"))
      return
    end
    if guardCount > self._maxGuardCount then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_SETALERT_8"))
      return
    end
    if 0 == groupGuardCount and 1 == increaseCount then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_SETALERT_9"))
      return
    end
    ToClient_RequestSetGuardInTradeGroup(self._selectIndex, guardCount)
  elseif 3 == assetType then
    amuletCount = amuletCount + increaseCount
    if amuletCount < 0 and -1 == increaseCount then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_SETALERT_10"))
      return
    end
    if amuletCount > self._maxFACount then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_SETALERT_11"))
      return
    end
    if 0 == groupAmuletCount and 1 == increaseCount then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_SETALERT_12"))
      return
    end
    ToClient_RequestSetAmuletInTradeGroup(self._selectIndex, amuletCount)
  end
end
function FGlobal_WorkerTradeCaravan_SetData()
  local self = workerTradeCaravan
  self:SetData(self._selectIndex + 1)
end
function FGlobal_WorkerTradeCaravan_Show(index)
  workerTradeCaravan:Show(index)
end
function workerTradeCaravan:Hide()
  WorldMapPopupManager:pop()
  WorkerTradeCaravan_TooltipHide()
  self.control._routerNode._btnArrivalNode:SetText("\235\170\169\236\160\129\236\167\128")
end
function FGlobal_WorkerTradeCaravan_Hide()
  workerTradeCaravan:Hide()
end
function WorkerTradeCaravan_Set(index)
  local self = workerTradeCaravan
  local tradeCompanyWrapper = ToClient_GetTradeCompanyWrapper()
  local tradeGroupWrapper = tradeCompanyWrapper:getGroup(index - 1)
  self:SetData(index)
end
local clickedWorkerIndex = 0
local setableWorkerCount = 0
function WorkerTradeCaravan_SetWorker(index)
  if workerTradeCaravan.control._list2TradeWorker:GetShow() then
    workerTradeCaravan.control._list2TradeWorker:SetShow(false)
    return
  end
  if not isChangeableState() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_WORKERALERT_1"))
    return
  end
  local self = workerTradeCaravan
  local control = self.control
  local plantConut = ToCleint_getHomePlantKeyListCount()
  local startWayPointKey = 1101
  setableWorkerCount = 0
  control._list2TradeWorker:getElementManager():clearKey()
  for plantIdx = 0, plantConut - 1 do
    local plantKeyRaw = ToCleint_getHomePlantKeyListByIndex(plantIdx)
    if startWayPointKey == plantKeyRaw then
      local plantKey = ToClient_convertWaypointKeyToPlantKey(startWayPointKey)
      local waitWorkerCount = ToClient_getPlantWaitWorkerListCount(plantKey, 0)
      local maxWorkerCount = ToClient_getTownWorkerMaxCapacity(plantKey)
      for workerIndex = 0, waitWorkerCount - 1 do
        local workerNoRaw = ToClient_getPlantWaitWorkerNoRawByIndex(plantKey, workerIndex)
        if self._selectedWorker[0] ~= workerNoRaw and self._selectedWorker[1] ~= workerNoRaw then
          control._list2TradeWorker:getElementManager():pushKey(toInt64(0, workerIndex))
        end
        setableWorkerCount = setableWorkerCount + 1
      end
    end
  end
  if 0 < Int64toInt32(self._selectedWorker[index]) then
    setableWorkerCount = setableWorkerCount + 1
    control._list2TradeWorker:getElementManager():pushKey(toInt64(0, setableWorkerCount))
  elseif 0 == setableWorkerCount then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_WORKERALERT_2"))
    return
  end
  control._list2TradeWorker:SetShow(true)
  control._list2TradeItem:SetShow(false)
  control._list2ArrivalNode:SetShow(false)
  control._list2RouteNode:SetShow(false)
  control._itemListBg:SetShow(false)
  clickedWorkerIndex = index
end
local tempWorkerNo = {}
function TradeWorkerListControlCreate(content, key)
  local workerListBg = UI.getChildControl(content, "List2_OptionList_Bg")
  local tradeWorkerName = UI.getChildControl(content, "List2_OptionList_Desc")
  local self = workerTradeCaravan
  local _key = Int64toInt32(key)
  local plantConut = ToCleint_getHomePlantKeyListCount()
  local startWayPointKey = 1101
  for plantIdx = 0, plantConut - 1 do
    local plantKeyRaw = ToCleint_getHomePlantKeyListByIndex(plantIdx)
    if startWayPointKey == plantKeyRaw then
      local plantKey = ToClient_convertWaypointKeyToPlantKey(startWayPointKey)
      local waitWorkerCount = ToClient_getPlantWaitWorkerListCount(plantKey, 0)
      local maxWorkerCount = ToClient_getTownWorkerMaxCapacity(plantKey)
      for workerIndex = 0, waitWorkerCount - 1 do
        if self._selectedWorker[0] ~= workerNoRaw and self._selectedWorker[1] ~= workerNoRaw and _key == workerIndex then
          local workerNoRaw = ToClient_getPlantWaitWorkerNoRawByIndex(plantKey, workerIndex)
          local workerWrapperLua = getWorkerWrapper(workerNoRaw, true)
          tradeWorkerName:SetText(tostring(workerWrapperLua:getName()))
          tempWorkerNo[workerIndex] = {}
          tempWorkerNo[workerIndex] = workerNoRaw
          workerListBg:addInputEvent("Mouse_LUp", "TradeWorker_SetWorker(" .. tostring(workerIndex) .. ")")
          break
        end
      end
      if _key == setableWorkerCount then
        tradeWorkerName:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_BUTTONFIRE"))
        workerListBg:addInputEvent("Mouse_LUp", "TradeWorker_FireWorker(" .. clickedWorkerIndex .. ")")
      end
    end
  end
end
function TradeWorker_SetWorker(workerIndex)
  local self = workerTradeCaravan
  ToClient_RequestSetWorker(self._selectIndex, clickedWorkerIndex, tempWorkerNo[workerIndex])
  self.control._list2TradeWorker:SetShow(false)
end
function TradeWorker_FireWorker(index)
  local self = workerTradeCaravan
  ToClient_RequestUnsetWorker(self._selectIndex, index)
end
function WorkerTradeCaravan_ShowArrivalNodeList()
  if workerTradeCaravan.control._list2ArrivalNode:GetShow() then
    workerTradeCaravan.control._list2ArrivalNode:SetShow(false)
    return
  end
  if not isChangeableState() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_ARRIVALALERT_1"))
    return
  end
  local self = workerTradeCaravan
  local control = self.control
  local startWayPointKey = WorkerTradeCaravan_StartWayPointKey()
  control._list2ArrivalNode:getElementManager():clearKey()
  local arrivalNodeCount = ToClient_GetWorkerTradeMainNodeCount(startWayPointKey)
  local count = 0
  for index = 0, arrivalNodeCount - 1 do
    local regionInfo = ToClient_GetWorkerTradeMainNodeByIndex(startWayPointKey, index)
    if nil ~= regionInfo then
      control._list2ArrivalNode:getElementManager():pushKey(toInt64(0, index))
      count = count + 1
    end
  end
  if 0 == count then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_ARRIVALALERT_2"))
    return
  end
  control._list2TradeWorker:SetShow(false)
  control._list2ArrivalNode:SetShow(true)
  control._list2RouteNode:SetShow(false)
  control._list2TradeItem:SetShow(false)
  control._itemListBg:SetShow(false)
end
function ArrivalNodeList_Set(index)
  local self = workerTradeCaravan
  local control = self.control
  local startWayPointKey = WorkerTradeCaravan_StartWayPointKey()
  local regionInfo = ToClient_GetWorkerTradeMainNodeByIndex(startWayPointKey, index)
  control._routerNode._btnArrivalNode:SetText(regionInfo:getAreaName())
  control._list2ArrivalNode:SetShow(false)
  self._selectArrNodeIndex = index
  ToClient_RequestSetDestination(regionInfo:getExplorationKey())
end
function ArrivalNodeListControlCreate(content, key)
  local arrivalNodeBg = UI.getChildControl(content, "List2_OptionList_Bg")
  local arrivalNodeName = UI.getChildControl(content, "List2_OptionList_Desc")
  local self = workerTradeCaravan
  local _key = Int64toInt32(key)
  local startWayPointKey = WorkerTradeCaravan_StartWayPointKey()
  local arrivalNodeCount = ToClient_GetWorkerTradeMainNodeCount(startWayPointKey)
  for index = 0, arrivalNodeCount - 1 do
    if index == _key then
      local regionInfo = ToClient_GetWorkerTradeMainNodeByIndex(startWayPointKey, index)
      if nil ~= regionInfo then
        arrivalNodeName:SetText(regionInfo:getAreaName())
        arrivalNodeBg:addInputEvent("Mouse_LUp", "ArrivalNodeList_Set(" .. index .. ")")
        break
      end
    end
  end
end
function WorkerTradeCaravan_RouteNodeSet(nodeIndex)
  if workerTradeCaravan.control._list2RouteNode:GetShow() then
    workerTradeCaravan.control._list2RouteNode:SetShow(false)
    return
  end
  if not isChangeableState() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_ROUTEALERT_1"))
    return
  end
  local self = workerTradeCaravan
  local control = self.control
  local startWayPointKey = WorkerTradeCaravan_StartWayPointKey()
  local count = 0
  control._list2RouteNode:getElementManager():clearKey()
  local routeNodeCount = ToClient_GetWorkerTradeEventNodeCount(startWayPointKey)
  for index = 0, routeNodeCount - 1 do
    local regionInfo = ToClient_GetWorkerTradeEventNodeByIndex(startWayPointKey, index)
    if nil ~= regionInfo and RouteNodeCompare(regionInfo:getAreaName()) then
      control._list2RouteNode:getElementManager():pushKey(toInt64(0, index))
      count = count + 1
    end
  end
  if 0 == count then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_ROUTEALERT_2"))
    return
  end
  self._selectRouteNodeIndex = nodeIndex
  control._list2TradeWorker:SetShow(false)
  control._list2ArrivalNode:SetShow(false)
  control._list2RouteNode:SetShow(true)
  control._list2TradeItem:SetShow(false)
  control._itemListBg:SetShow(false)
end
function RouteNodeList_Set(index)
  local self = workerTradeCaravan
  local control = self.control
  local startWayPointKey = WorkerTradeCaravan_StartWayPointKey()
  local regionInfo = ToClient_GetWorkerTradeEventNodeByIndex(startWayPointKey, index)
  if self._routeNodeIndex < self._selectRouteNodeIndex then
    self._routeNodeIndex = self._routeNodeIndex + 1
    control._routerNode._btnRouterNode[self._routeNodeIndex]:SetText(regionInfo:getAreaName())
    control._list2RouteNode:SetShow(false)
    self._currentSelectRouteNodeList[self._routeNodeIndex] = regionInfo:getAreaName()
    ToClient_RequestSetEventNode(self._routeNodeIndex - 1, regionInfo:getExplorationKey())
  else
    control._routerNode._btnRouterNode[self._selectRouteNodeIndex]:SetText(regionInfo:getAreaName())
    control._list2RouteNode:SetShow(false)
    self._currentSelectRouteNodeList[self._selectRouteNodeIndex] = regionInfo:getAreaName()
    ToClient_RequestSetEventNode(self._selectRouteNodeIndex - 1, regionInfo:getExplorationKey())
  end
end
function RouteNodeListControlCreate(content, key)
  local optionListBg = UI.getChildControl(content, "List2_OptionList_Bg")
  local optionListDesc = UI.getChildControl(content, "List2_OptionList_Desc")
  local self = workerTradeCaravan
  local _key = Int64toInt32(key)
  local startWayPointKey = WorkerTradeCaravan_StartWayPointKey()
  local routeNodeCount = ToClient_GetWorkerTradeEventNodeCount(startWayPointKey)
  for index = 0, routeNodeCount - 1 do
    if index == _key then
      local regionInfo = ToClient_GetWorkerTradeEventNodeByIndex(startWayPointKey, index)
      if nil ~= regionInfo then
        optionListDesc:SetText(regionInfo:getAreaName())
        optionListBg:addInputEvent("Mouse_LUp", "RouteNodeList_Set(" .. index .. ")")
        self._currentSelectRouteNodeCount = self._currentSelectRouteNodeCount - 1
        break
      end
    end
  end
end
function RouteNodeCompare(areaName)
  local self = workerTradeCaravan
  if nil == self._currentSelectRouteNodeList then
    return true
  end
  for v, name in pairs(self._currentSelectRouteNodeList) do
    if areaName == name then
      return false
    end
  end
  return true
end
local _slotIndex
function WorkerTradeCaravan_SelectItem(slotIndex)
  if not isChangeableState() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_ITEMALERT"))
    return
  end
  _slotIndex = slotIndex
  ToClient_RequestOpenWorkerTradeList()
end
function WorkerTradeCaravan_DecreaseItem(slotIndex)
  local self = workerTradeCaravan
  local control = self.control
  local _slotIndex = slotIndex
  local countIndex = _slotIndex + 1
  local carriageIndex = math.ceil(countIndex / 2)
  local uiIndex = slotIndex % 2 + 1
  if 0 == self._itemCountInSlot[countIndex]._count then
    return
  end
  local startWayPointKey = WorkerTradeCaravan_StartWayPointKey()
  local destWayPointKey
  if -1 == self._selectArrNodeIndex then
    destWayPointKey = startWayPointKey
  else
    local regionInfo = ToClient_GetWorkerTradeMainNodeByIndex(startWayPointKey, self._selectArrNodeIndex)
    destWayPointKey = regionInfo:getExplorationKey()
  end
  local itemKey = self._itemCountInSlot[countIndex]._key
  local rv = self._itemCountInSlot[countIndex]._count - 1
  if 0 == rv then
    self._itemCountInSlot[countIndex]._key = rv
    self._itemCountInSlot[countIndex]._count = rv
    control._itemSet._itemSetBg[carriageIndex]._count[uiIndex]:SetShow(false)
    control._itemSet._itemSetBg[carriageIndex]._plus[uiIndex]:SetShow(true)
    control._itemSet._itemSetBg[carriageIndex]._itemSlot[uiIndex]:ChangeTextureInfoName("")
    ToClient_RequestAddCart(workerTradeCaravan._selectIndex, _slotIndex, itemKey, rv, startWayPointKey, destWayPointKey)
  else
    local canBuyItem = ToClient_RequestAddCart(workerTradeCaravan._selectIndex, _slotIndex, itemKey, rv, startWayPointKey, destWayPointKey)
    if canBuyItem then
      self._itemCountInSlot[countIndex]._count = rv
      control._itemSet._itemSetBg[carriageIndex]._count[uiIndex]:SetText(self._itemCountInSlot[countIndex]._count)
    end
  end
  local tradeCompanyWrapper = ToClient_GetTradeCompanyWrapper()
  local tradeGroupWrapper = tradeCompanyWrapper:getGroup(workerTradeCaravan._selectIndex)
  local maxWeight = tradeGroupWrapper:getTradeGroupTransportCapacity()
  local totalPrice = tradeCompanyWrapper:getTempTotalPrice()
  local totalWeight = tradeCompanyWrapper:getTempTotalWeight()
  control._itemWeight:SetText(makeDotMoney(totalWeight) .. " / " .. makeDotMoney(maxWeight))
  control._tradePrice:SetText(makeDotMoney(totalPrice))
end
function FromClient_OpenWorkerTradeItemList()
  if workerTradeCaravan.control._list2TradeItem:GetShow() then
    workerTradeCaravan.control._list2TradeItem:SetShow(false)
    return
  end
  local self = workerTradeCaravan
  local control = self.control
  local startWayPointKey = WorkerTradeCaravan_StartWayPointKey()
  local destWayPointKey
  if -1 == self._selectArrNodeIndex then
    destWayPointKey = startWayPointKey
  else
    local regionInfo = ToClient_GetWorkerTradeMainNodeByIndex(startWayPointKey, self._selectArrNodeIndex)
    destWayPointKey = regionInfo:getExplorationKey()
  end
  control._list2TradeItem:getElementManager():clearKey()
  local buyableItemCount = ToClient_RequestBuyableWorkerTradeItemCount(startWayPointKey)
  local startWayPointKey = WorkerTradeCaravan_StartWayPointKey()
  for index = 0, self._maxItemCount - 1 do
    if index < buyableItemCount then
      control._tradeItemSlotBg[index]:SetShow(true)
      control._tradeItemSlot[index]:SetShow(true)
      local tradeItemWrapper = ToClient_RequestWorkerTradeItemMaster(startWayPointKey, index)
      if nil ~= tradeItemWrapper then
        local itemKey = tradeItemWrapper:getKey()
        control._tradeItemSlot[index]:ChangeTextureInfoName("Icon/" .. tradeItemWrapper:getIconPath())
        control._tradeItemSlot[index]:addInputEvent("Mouse_On", "WorkerTradeCaravan_TooltipShow(" .. index .. ",nil," .. itemKey .. ")")
        control._tradeItemSlot[index]:addInputEvent("Mouse_Out", "WorkerTradeCaravan_TooltipHide()")
        control._tradeItemSlot[index]:addInputEvent("Mouse_LUp", "WorkerTradeCaravan_SetItem(" .. index .. "," .. 1 .. ")")
        control._tradeItemSlot[index]:addInputEvent("Mouse_RUp", "WorkerTradeCaravan_SetItem(" .. index .. "," .. -1 .. ")")
      end
    else
      control._tradeItemSlotBg[index]:SetShow(false)
      control._tradeItemSlot[index]:SetShow(false)
    end
  end
  control._itemListBg:SetShow(true)
  control._itemListBg:SetSize(control._itemListBg:GetSizeX(), 50 + math.ceil(buyableItemCount / 4) * 60 + 40)
  control._itemListBg:ComputePos()
  control._itemSet._btnClose:ComputePos()
  control._list2TradeWorker:SetShow(false)
  control._list2ArrivalNode:SetShow(false)
  control._list2RouteNode:SetShow(false)
  control._list2TradeItem:SetShow(false)
end
function WorkerTradeCaravan_ItemListClose()
  local self = workerTradeCaravan
  local control = self.control
  control._itemListBg:SetShow(false)
end
function WorkerTradeCaravan_SetItem(index, value)
  local self = workerTradeCaravan
  local control = self.control
  local tradeCompanyWrapper = ToClient_GetTradeCompanyWrapper()
  local tradeGroupWrapper = tradeCompanyWrapper:getGroup(workerTradeCaravan._selectIndex)
  if nil == tradeGroupWrapper then
    return
  end
  local carriageCount = tradeGroupWrapper:getTradeGroupCarriage()
  if 0 == carriageCount then
    return
  end
  local startWayPointKey = WorkerTradeCaravan_StartWayPointKey()
  local destWayPointKey
  if -1 == self._selectArrNodeIndex then
    destWayPointKey = startWayPointKey
  else
    local regionInfo = ToClient_GetWorkerTradeMainNodeByIndex(startWayPointKey, self._selectArrNodeIndex)
    destWayPointKey = regionInfo:getExplorationKey()
  end
  local tradeItemWrapper = ToClient_RequestWorkerTradeItemMaster(startWayPointKey, index)
  local itemKey = tradeItemWrapper:getKey()
  local maxWeight = tradeGroupWrapper:getTradeGroupTransportCapacity()
  local _slotIndex = -1
  local isSameItem = false
  for carriageIndex = 1, carriageCount do
    for uiIndex = 1, 2 do
      local countIndex = (carriageIndex - 1) * 2 + uiIndex
      local _slotIndex = countIndex - 1
      if itemKey == self._itemCountInSlot[countIndex]._key then
        local rv = self._itemCountInSlot[countIndex]._count + value
        if 0 == rv then
          self._itemCountInSlot[countIndex]._key = rv
          self._itemCountInSlot[countIndex]._count = rv
          control._itemSet._itemSetBg[carriageIndex]._count[uiIndex]:SetShow(false)
          control._itemSet._itemSetBg[carriageIndex]._plus[uiIndex]:SetShow(true)
          control._itemSet._itemSetBg[carriageIndex]._itemSlot[uiIndex]:ChangeTextureInfoName("")
          control._itemSet._itemSetBg[carriageIndex]._itemSlot[uiIndex]:addInputEvent("Mouse_On", "")
          control._itemSet._itemSetBg[carriageIndex]._itemSlot[uiIndex]:addInputEvent("Mouse_Out", "WorkerTradeCaravan_TooltipHide()")
          ToClient_RequestAddCart(workerTradeCaravan._selectIndex, _slotIndex, itemKey, rv, startWayPointKey, destWayPointKey)
        else
          local canBuyItem = ToClient_RequestAddCart(workerTradeCaravan._selectIndex, _slotIndex, itemKey, rv, startWayPointKey, destWayPointKey)
          if canBuyItem then
            self._itemCountInSlot[countIndex]._count = rv
            control._itemSet._itemSetBg[carriageIndex]._count[uiIndex]:SetText(self._itemCountInSlot[countIndex]._count)
          end
        end
        isSameItem = true
        break
      end
    end
    if isSameItem then
      break
    end
  end
  if not isSameItem and value > 0 then
    local isEmptySlot = false
    for carriageIndex = 1, carriageCount do
      for uiIndex = 1, 2 do
        local countIndex = (carriageIndex - 1) * 2 + uiIndex
        local _slotIndex = countIndex - 1
        if 0 == self._itemCountInSlot[countIndex]._count then
          local canBuyItem = ToClient_RequestAddCart(workerTradeCaravan._selectIndex, _slotIndex, itemKey, value, startWayPointKey, destWayPointKey)
          if canBuyItem then
            self._itemCountInSlot[countIndex]._key = itemKey
            self._itemCountInSlot[countIndex]._count = self._itemCountInSlot[countIndex]._count + value
            control._itemSet._itemSetBg[carriageIndex]._count[uiIndex]:SetText(self._itemCountInSlot[countIndex]._count)
            control._itemSet._itemSetBg[carriageIndex]._count[uiIndex]:SetShow(true)
            control._itemSet._itemSetBg[carriageIndex]._plus[uiIndex]:SetShow(false)
            control._itemSet._itemSetBg[carriageIndex]._itemSlot[uiIndex]:ChangeTextureInfoName("Icon/" .. tradeItemWrapper:getIconPath())
            isEmptySlot = true
            control._itemSet._itemSetBg[carriageIndex]._itemSlot[uiIndex]:addInputEvent("Mouse_On", "WorkerTradeCaravan_TooltipShow(" .. carriageIndex .. "," .. uiIndex .. "," .. itemKey .. ")")
            control._itemSet._itemSetBg[carriageIndex]._itemSlot[uiIndex]:addInputEvent("Mouse_Out", "WorkerTradeCaravan_TooltipHide()")
            break
          end
        end
      end
      if isEmptySlot then
        break
      end
    end
  end
  local maxWeight = tradeGroupWrapper:getTradeGroupTransportCapacity()
  local totalPrice = tradeCompanyWrapper:getTempTotalPrice()
  local totalWeight = tradeCompanyWrapper:getTempTotalWeight()
  control._itemWeight:SetText(makeDotMoney(totalWeight) .. " / " .. makeDotMoney(maxWeight))
  control._tradePrice:SetText(makeDotMoney(totalPrice))
end
function WorkerTradeCaravan_ItemCheck(index)
  local self = workerTradeCaravan
  for slotIndex = 0, #self.tradeItemInfo do
    if index == self.tradeItemInfo[slotIndex] then
      return false
    end
  end
  return true
end
function TradeItemListControlCreate(content, key)
  local optionListBg = UI.getChildControl(content, "List2_OptionList_Bg")
  local slotBg = UI.getChildControl(content, "Static_Slot_BG")
  local slot = UI.getChildControl(content, "Static_Slot")
  local itemName = UI.getChildControl(content, "List2_OptionList_Name")
  local priceRate = UI.getChildControl(content, "List2_OptionList_PriceRate")
  local sellPrice = UI.getChildControl(content, "List2_OptionList_SellPrice")
  local weight = UI.getChildControl(content, "List2_OptionList_Weight")
  local btnPlus = UI.getChildControl(content, "Static_Plus")
  local btnMinus = UI.getChildControl(content, "Static_Minus")
  local self = workerTradeCaravan
  local _key = Int64toInt32(key)
  local startWayPointKey = WorkerTradeCaravan_StartWayPointKey()
  local destWayPointKey
  if -1 == self._selectArrNodeIndex then
    destWayPointKey = startWayPointKey
  else
    local regionInfo = ToClient_GetWorkerTradeMainNodeByIndex(startWayPointKey, self._selectArrNodeIndex)
    destWayPointKey = regionInfo:getExplorationKey()
  end
  local buyableItemCount = ToClient_RequestBuyableWorkerTradeItemCount(startWayPointKey)
  for index = 0, buyableItemCount - 1 do
    if index == _key then
      local tradeItemWrapper = ToClient_RequestWorkerTradeItemMaster(startWayPointKey, index)
      if nil ~= tradeItemWrapper then
        slot:ChangeTextureInfoName("Icon/" .. tradeItemWrapper:getIconPath())
        itemName:SetText(tradeItemWrapper:getName())
        priceRate:SetText("\236\139\156\236\132\184 : " .. makeDotMoney(tradeItemWrapper:getPriceRate() + 100) .. "%")
        sellPrice:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_BUYPRICE", "price", makeDotMoney(tradeItemWrapper:getBuyPrice())))
        weight:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_WEIGHT", "weight", makeDotMoney(tradeItemWrapper:getWeight())))
        btnPlus:addInputEvent("Mouse_LUp", "WorkerTradeCaravan_BuyItem(" .. index .. "," .. 1 .. ")")
        btnMinus:addInputEvent("Mouse_LUp", "WorkerTradeCaravan_BuyItem(" .. index .. "," .. -1 .. ")")
        local arrivalNode_TradeItemWrapper = ToClient_RequestWorkerTradeItemMaster(destWayPointKey, index)
        break
      end
    end
  end
end
function WorkerTradeCaravan_BuyItem(index, addCount)
  local self = workerTradeCaravan
  local tradeCompanyWrapper = ToClient_GetTradeCompanyWrapper()
  local tradeGroupWrapper = tradeCompanyWrapper:getGroup(workerTradeCaravan._selectIndex)
  local coinCount = tradeCompanyWrapper:getTradeCompanyMoney()
  local canBuyItem = false
  local startWayPointKey = WorkerTradeCaravan_StartWayPointKey()
  local destWayPointKey
  if -1 == self._selectArrNodeIndex then
    destWayPointKey = startWayPointKey
  else
    local regionInfo = ToClient_GetWorkerTradeMainNodeByIndex(startWayPointKey, self._selectArrNodeIndex)
    destWayPointKey = regionInfo:getExplorationKey()
  end
  local tradeItemWrapper = ToClient_RequestWorkerTradeItemMaster(startWayPointKey, index)
  local maxCount = math.floor(Int64toInt32(coinCount / tradeItemWrapper:getBuyPrice()))
  local function setTradeItem(inputNumber)
    if nil == _slotIndex then
      return
    end
    local slotIndex = math.floor(_slotIndex / 2) + 1
    local uiIndex = math.floor(_slotIndex % 2) + 1
    local itemKey = tradeItemWrapper:getKey()
    local maxWeight = tradeGroupWrapper:getTradeGroupTransportCapacity()
    canBuyItem = ToClient_RequestAddCart(workerTradeCaravan._selectIndex, _slotIndex, itemKey, inputNumber, startWayPointKey, destWayPointKey)
    if true == canBuyItem then
      local control = self.control
      if inputNumber > toInt64(0, 0) then
        control._itemSet._itemSetBg[slotIndex]._itemSlot[uiIndex]:ChangeTextureInfoName("Icon/" .. tradeItemWrapper:getIconPath())
        control._itemSet._itemSetBg[slotIndex]._count[uiIndex]:SetShow(true)
        control._itemSet._itemSetBg[slotIndex]._count[uiIndex]:SetText(tostring(inputNumber))
        control._itemSet._itemSetBg[slotIndex]._plus[uiIndex]:SetShow(false)
        self.tradeItemInfo[_slotIndex] = index
      else
        control._itemSet._itemSetBg[slotIndex]._itemSlot[uiIndex]:ChangeTextureInfoName("")
        control._itemSet._itemSetBg[slotIndex]._count[uiIndex]:SetShow(false)
        control._itemSet._itemSetBg[slotIndex]._plus[uiIndex]:SetShow(true)
        self.tradeItemInfo[_slotIndex] = nil
      end
      local totalPrice = tradeCompanyWrapper:getTempTotalPrice()
      local totalWeight = tradeCompanyWrapper:getTempTotalWeight()
      control._itemWeight:SetText(makeDotMoney(totalWeight) .. " / " .. makeDotMoney(maxWeight))
      control._tradePrice:SetText(makeDotMoney(totalPrice))
      control._list2TradeItem:SetShow(false)
    end
  end
  if addCount > 0 then
    Panel_NumberPad_Show(true, toInt64(0, maxCount), 0, setTradeItem)
  else
    setTradeItem(toInt64(0, 0))
  end
end
function WorkerTradeCaravan_Go()
  if not isChangeableState() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_STARTALERT_1"))
    return
  end
  local tradeCompanyWrapper = ToClient_GetTradeCompanyWrapper()
  local tradeGroupWrapper = tradeCompanyWrapper:getGroup(workerTradeCaravan._selectIndex)
  if nil == tradeGroupWrapper then
    return
  end
  local carriageCount = tradeGroupWrapper:getTradeGroupCarriage()
  local porterCount = tradeGroupWrapper:getTradeGroupPorter()
  if 0 == carriageCount then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_STARTALERT_2"))
    return
  end
  if porterCount < carriageCount * workerTradeCaravan._minWorkerCount then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_STARTALERT_3"))
    return
  end
  ToClient_RequestStartTradeGroup(workerTradeCaravan._selectIndex)
end
function WorkerTradeCaravan_TooltipShow(uiIndex, slotIndex, itemKey)
  local self = workerTradeCaravan
  local control = self.control
  local startWayPointKey = WorkerTradeCaravan_StartWayPointKey()
  for index = 0, self._maxItemCount - 1 do
    local tradeItemWrapper = ToClient_RequestWorkerTradeItemMaster(startWayPointKey, index)
    local tradeItemKey = tradeItemWrapper:getKey()
    if itemKey == tradeItemKey then
      control._tooltipItem._slot:ChangeTextureInfoName("Icon/" .. tradeItemWrapper:getIconPath())
      control._tooltipItem._name:SetText(tradeItemWrapper:getName())
      control._tooltipItem._price:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_ITEMTOOLTIP_PRICE", "price", tostring(makeDotMoney(tradeItemWrapper:getBuyPrice()))))
      control._tooltipItem._weight:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_WORKERTRADECARAVAN_ITEMTOOLTIP_WEIGHT", "weight", tostring(makeDotMoney(tradeItemWrapper:getWeight()))))
      break
    end
  end
  if 150 < control._tooltipItem._name:GetTextSizeX() then
    control._tooltip:SetSize(control._tooltipItem._name:GetTextSizeX() + 20, 90)
  else
    control._tooltip:SetSize(170, 90)
  end
  local basePosX, basePosY
  if nil == slotIndex then
    basePosX = control._itemListBg:GetPosX() + control._tradeItemSlotBg[uiIndex]:GetPosX()
    basePosY = control._itemListBg:GetPosY() + control._tradeItemSlotBg[uiIndex]:GetPosY()
  else
    basePosX = control._itemSetBg:GetPosX() + control._itemSet._itemSlotBg[uiIndex]:GetPosX() + control._itemSet._itemSetBg[uiIndex]._itemSlotBg[slotIndex]:GetPosX()
    basePosY = control._itemSetBg:GetPosY() + control._itemSet._itemSlotBg[uiIndex]:GetPosY()
  end
  if basePosX + Panel_WorkerTrade_Caravan:GetPosX() < getScreenSizeX() / 2 - control._tooltip:GetSizeX() / 2 then
    control._tooltip:SetPosX(basePosX + 60)
  else
    control._tooltip:SetPosX(basePosX - control._tooltip:GetSizeX() - 10)
  end
  if basePosY > getScreenSizeY() then
    control._tooltip:SetPosY(basePosY - 90)
  else
    control._tooltip:SetPosY(basePosY)
  end
  control._tooltip:SetShow(true)
end
function WorkerTradeCaravan_TooltipHide()
  local self = workerTradeCaravan
  local control = self.control
  control._tooltip:SetShow(false)
end
function WorkerTradeCaravan_StartWayPointKey()
  local self = workerTradeCaravan
  local tradeCompanyWrapper = ToClient_GetTradeCompanyWrapper()
  local tradeGroupWrapper = tradeCompanyWrapper:getGroup(self._selectIndex)
  if nil == tradeGroupWrapper then
    return
  end
  local startRegionInfo = tradeGroupWrapper:getCurrentRegion()
  local startWayPointKey = startRegionInfo:getExplorationKey()
  return startWayPointKey
end
function isChangeableState()
  local tradeCompanyWrapper = ToClient_GetTradeCompanyWrapper()
  local tradeGroupWrapper = tradeCompanyWrapper:getGroup(workerTradeCaravan._selectIndex)
  local currentState = tradeGroupWrapper:getState()
  if 4 == currentState then
    return true
  else
    return false
  end
end
function FGlobal_WorkerTradeCaraven_Open(index)
  if Panel_WorkerTrade_Caravan:GetShow() then
    workerTradeCaravan:Hide()
  else
    workerTradeCaravan._caravanIndex = index
    workerTradeCaravan:Show(index)
  end
end
function WorkerTradeCaravan_Close()
  workerTradeCaravan:Hide()
end
function workerTradeCaravan:registerEvent()
  local control = self.control
  control._worker._image[1]:addInputEvent("Mouse_LUp", "WorkerTradeCaravan_SetWorker(" .. 0 .. ")")
  control._worker._image[2]:addInputEvent("Mouse_LUp", "WorkerTradeCaravan_SetWorker(" .. 1 .. ")")
  control._asset._btnCarriage:addInputEvent("Mouse_LUp", "WorkerTrade_SetAsset(" .. 0 .. "," .. 1 .. ")")
  control._asset._btnCarriage:addInputEvent("Mouse_RUp", "WorkerTrade_SetAsset(" .. 0 .. "," .. -1 .. ")")
  control._asset._btnWorker:addInputEvent("Mouse_LUp", "WorkerTrade_SetAsset(" .. 1 .. "," .. 1 .. ")")
  control._asset._btnWorker:addInputEvent("Mouse_RUp", "WorkerTrade_SetAsset(" .. 1 .. "," .. -1 .. ")")
  control._asset._btnGuard:addInputEvent("Mouse_LUp", "WorkerTrade_SetAsset(" .. 2 .. "," .. 1 .. ")")
  control._asset._btnGuard:addInputEvent("Mouse_RUp", "WorkerTrade_SetAsset(" .. 2 .. "," .. -1 .. ")")
  control._asset._btnFA:addInputEvent("Mouse_LUp", "WorkerTrade_SetAsset(" .. 3 .. "," .. 1 .. ")")
  control._asset._btnFA:addInputEvent("Mouse_RUp", "WorkerTrade_SetAsset(" .. 3 .. "," .. -1 .. ")")
  control._list2TradeWorker:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "TradeWorkerListControlCreate")
  control._list2TradeWorker:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  control._routerNode._btnArrivalNode:addInputEvent("Mouse_LUp", "WorkerTradeCaravan_ShowArrivalNodeList()")
  control._list2ArrivalNode:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "ArrivalNodeListControlCreate")
  control._list2ArrivalNode:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  for index = 1, 5 do
    control._routerNode._btnRouterNode[index]:addInputEvent("Mouse_LUp", "WorkerTradeCaravan_RouteNodeSet(" .. index .. ")")
  end
  control._list2RouteNode:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "RouteNodeListControlCreate")
  control._list2RouteNode:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  control._itemSet._btnClose:addInputEvent("Mouse_LUp", "WorkerTradeCaravan_ItemListClose()")
  control._list2TradeItem:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "TradeItemListControlCreate")
  control._list2TradeItem:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  control._btnTradeStart:addInputEvent("Mouse_LUp", "WorkerTradeCaravan_Go()")
  registerEvent("FromClient_OpenWorkerTradeItemList", "FromClient_OpenWorkerTradeItemList")
  control._closeBtn:addInputEvent("Mouse_LUp", "WorkerTradeCaravan_Close()")
  control._questionBtn:addInputEvent("Mouse_LUp", "")
  control._questionBtn:SetShow(false)
end
workerTradeCaravan:ControlInit()
workerTradeCaravan:registerEvent()

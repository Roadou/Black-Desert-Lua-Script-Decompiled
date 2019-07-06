local _panel = Panel_Window_Warehouse
local eWarehouseTypeNpc = CppEnums.WarehoouseFromType.eWarehoouseFromType_Npc
local eWarehouseTypeInstallation = CppEnums.WarehoouseFromType.eWarehoouseFromType_Installation
local eWarehouseTypeWorldmap = CppEnums.WarehoouseFromType.eWarehoouseFromType_Worldmap
local eWarehouseTypeGuildHouse = CppEnums.WarehoouseFromType.eWarehoouseFromType_GuildHouse
local eWarehouseTypeMaid = CppEnums.WarehoouseFromType.eWarehoouseFromType_Maid
local eWarehouseTypeManufacture = CppEnums.WarehoouseFromType.eWarehoouseFromType_Manufacture
local eWarehouseTypeFurniture = CppEnums.WarehoouseFromType.eWarehoouseFromType_Furniture
local Warehouse = {
  _ui = {
    stc_TopBg = UI.getChildControl(_panel, "Static_TopBg"),
    stc_CenterBg = UI.getChildControl(_panel, "Static_CenterBg"),
    stc_LeftBg = UI.getChildControl(_panel, "Static_LeftBg"),
    stc_BottomBg = UI.getChildControl(_panel, "Static_BottomBg")
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCooltime = true,
    createExpiration = true,
    createExpirationBG = true,
    createExpiration2h = true,
    createClassEquipBG = true,
    createEnduranceIcon = true,
    createCash = true,
    createBagIcon = true,
    createEnduranceIcon = true,
    createCheckBox = true
  },
  _config = {
    slotCount = 90,
    slotCols = 10,
    slotRows = 0,
    slotStartX = 15,
    slotStartY = 15,
    slotGapX = 53,
    slotGapY = 53
  },
  _buttonData = {
    selectItem = false,
    marketRegist = true,
    manufacture = true,
    delivery = true,
    guildUpdate = true,
    sendMoney = true
  },
  _slotBgData = {},
  _slotItemData = {},
  _slotFilterEffect = {},
  _slotNilEffect = {},
  _maxSlotRow = 0,
  _currentWaypointKey = 0,
  _currentRegionName = "None",
  _fromType = CppEnums.WarehoouseFromType.eWarehoouseFromType_Worldmap,
  _installationActorKeyRaw = 0,
  _targetActorKeyRaw = nil,
  _startSlotIndex = 0,
  _myAsset = toInt64(0, 0),
  _tooltipSlotNo = nil,
  _defaultKeyGuideXpos = 0,
  _manufactureFilterFunc = nil,
  _manufactureRclickFunc = nil,
  _itemMarketFilterFunc = nil,
  _itemMarketRclickFunc = nil,
  _invenFilterFunc = nil,
  _lastMaidUsedTick = nil,
  _sellCheck = false,
  _isSorted = false,
  _isCanUseMaid = true,
  _panelSizeX = 0,
  _topBGSizeX = 0,
  _centerBGSizeX = 0
}
local WarehouseListMenu = {
  _list = nil,
  _warehouseInfo = {
    territoryCount = 0,
    territoryGroup = {}
  },
  _territoryNameInfo = {},
  _maxTerritoryKeyCount = 10,
  _separatorNumber = 100,
  _currentTerritoryKey = -1,
  _selectWaypointKey = -1,
  _isFirstOpened = false,
  _isSetWarehouseList = nil
}
function Warehouse:isNpc()
  return eWarehouseTypeNpc == self._fromType
end
function Warehouse:isInstallation()
  return eWarehouseTypeInstallation == self._fromType
end
function Warehouse:isWorldMapNode()
  return eWarehouseTypeWorldmap == self._fromType
end
function Warehouse:isGuildHouse()
  return eWarehouseTypeGuildHouse == self._fromType
end
function Warehouse:isMaid()
  return eWarehouseTypeMaid == self._fromType
end
function Warehouse:isManufacture()
  return eWarehouseTypeManufacture == self._fromType
end
function Warehouse:isFurnitureWareHouse()
  if true == _ContentsGroup_isFurnitureWarehouse then
    return eWarehouseTypeFurniture == self._fromType
  else
    return false
  end
end
function Warehouse:isDeliveryWindow()
  if true == _ContentsGroup_RenewUI_Delivery then
    return PaGlobalFunc_PanelDelivery_GetShow()
  else
    return (Panel_Window_Delivery_Request:GetShow())
  end
end
function Warehouse:init()
  self._ui.txt_WarehouseTitle = UI.getChildControl(self._ui.stc_TopBg, "StaticText_Icon_WareHouse")
  self._ui.txt_WarehouseTitle:SetText(PAGetString(Defines.StringSheet_GAME, "HTML_PRODUCTNOTE_STRING_DEPOT"))
  self._ui.txt_WarehouseName = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_Name")
  self._ui.txt_WarehouseCapacity = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_Capacity")
  self._ui.txt_MoneyTitle = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_MoneyTitle")
  self._ui.txt_MoneyTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_WAREHOUSE_HAVE_MONEY"))
  self._ui.txt_MoneyValue = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_Value_Money")
  self._ui.txt_AssetTitle = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_AssetTitle")
  self._ui.txt_AssetValue = UI.getChildControl(self._ui.stc_CenterBg, "StaticText_Value_Asset")
  self._ui.stc_ItemSlotFrame = UI.getChildControl(self._ui.stc_CenterBg, "Static_ItemSlotFrame")
  self._ui.scroll_Warehouse = UI.getChildControl(self._ui.stc_CenterBg, "Scroll_Warehouse")
  self._ui.list_Warehouse = UI.getChildControl(self._ui.stc_LeftBg, "List2_WareHouse")
  self._ui.txt_NotAvaliable = UI.getChildControl(self._ui.stc_LeftBg, "StaticText_NotAvaliable")
  self._ui.txt_NotAvaliable:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.txt_NotAvaliable:SetText(self._ui.txt_NotAvaliable:GetText())
  self._ui.txt_Close = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_B")
  self._ui.txt_Select = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_A")
  self._ui.txt_Silver = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_Y")
  self._ui.txt_Manufacture = UI.getChildControl(self._ui.stc_BottomBg, "Button_Manufacture")
  self._ui.txt_Manufacture:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_MANUFACTURE_TITLE"))
  self._ui.txt_sort = UI.getChildControl(self._ui.stc_BottomBg, "StaticText_LSClick")
  self._keyGuides = {
    self._ui.txt_Manufacture,
    self._ui.txt_sort,
    self._ui.txt_Select,
    self._ui.txt_Silver,
    self._ui.txt_Close
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuides, self._ui.stc_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self._config.slotRows = self._config.slotCount / self._config.slotCols
  self._maxSlotRow = math.floor((self._config.slotCount - 1) / self._config.slotCols)
  for slotIdx = 0, self._config.slotCount - 1 do
    local slot = {}
    slot.base = UI.createAndCopyBasePropertyControl(self._ui.stc_ItemSlotFrame, "Static_ItemSlotBg_Template", self._ui.stc_ItemSlotFrame, "Warehouse_EmptySlot_" .. slotIdx)
    slot.lock = UI.createAndCopyBasePropertyControl(self._ui.stc_ItemSlotFrame, "Static_ItemSlotBg_LockIcon", self._ui.stc_ItemSlotFrame, "Warehouse_LockSlot_" .. slotIdx)
    local row = math.floor(slotIdx / self._config.slotCols)
    local column = slotIdx % self._config.slotCols
    local lockGapX = slot.base:GetSizeX() / 2 - slot.lock:GetSizeX() / 2
    local lockGapY = slot.base:GetSizeY() / 2 - slot.lock:GetSizeY() / 2
    slot.base:SetPosX(self._config.slotStartX + self._config.slotGapX * column)
    slot.base:SetPosY(self._config.slotStartY + self._config.slotGapY * row)
    slot.lock:SetPosXY(slot.base:GetPosX() + lockGapX, slot.base:GetPosY() + lockGapY)
    slot.base:SetShow(true)
    slot.lock:SetShow(false)
    if true == ToClient_isConsole() then
      if 0 == row then
        slot.base:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "PaGlobalFunc_Warehouse_Scroll(true)")
      elseif self._maxSlotRow == row then
        slot.base:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "PaGlobalFunc_Warehouse_Scroll(false)")
      end
    end
    slot.base:registerPadEvent(__eConsoleUIPadEvent_Up_X, "Input_Warehouse_ShowTooltip(" .. slotIdx .. ", true)")
    slot.base:addInputEvent("Mouse_On", "InputMO_Warehouse_ShowSlotHighlight(true, " .. slotIdx .. ")")
    slot.base:addInputEvent("Mouse_Out", "InputMO_Warehouse_ShowSlotHighlight(false, " .. slotIdx .. ")")
    self._slotBgData[slotIdx] = slot
  end
  for slotIdx = 0, self._config.slotCount - 1 do
    local slot = {}
    SlotItem.new(slot, "WarehouseItem_" .. slotIdx, slotIdx, self._ui.stc_ItemSlotFrame, self._slotConfig)
    slot:createChild()
    local row = math.floor(slotIdx / self._config.slotCols)
    local column = slotIdx % self._config.slotCols
    slot.icon:SetPosX(self._config.slotStartX + self._config.slotGapX * column + 2)
    slot.icon:SetPosY(self._config.slotStartY + self._config.slotGapY * row + 2)
    slot.icon:SetEnableDragAndDrop(true)
    slot.icon:SetAutoDisableTime(0.5)
    if true == ToClient_isConsole() then
      slot.icon:addInputEvent("Mouse_LUp", "InputMRUp_Warehouse_WarehouseItemClicked(" .. slotIdx .. ")")
    else
      slot.icon:addInputEvent("Mouse_RUp", "InputMRUp_Warehouse_WarehouseItemClicked(" .. slotIdx .. ")")
    end
    slot.icon:addInputEvent("Mouse_On", "InputMO_Warehouse_IconOver(" .. slotIdx .. ")")
    slot.icon:addInputEvent("Mouse_Out", "InputMOut_Warehouse_IconOut(" .. slotIdx .. ")")
    if true == ToClient_isConsole() then
      if 0 == row then
        slot.icon:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "PaGlobalFunc_Warehouse_Scroll(true)")
      elseif self._maxSlotRow == row then
        slot.icon:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "PaGlobalFunc_Warehouse_Scroll(false)")
      end
    end
    self._slotItemData[slotIdx] = slot
  end
  WarehouseListMenu._list = self._ui.list_Warehouse
  WarehouseListMenu._selectIndex = -1
  self._panelSizeX = _panel:GetSizeX()
  self._topBGSizeX = Warehouse._ui.stc_TopBg:GetSizeX()
  self._centerBGSizeX = Warehouse._ui.stc_CenterBg:GetSizeX()
  self:registEvent()
end
function Warehouse:open(waypointKey, fromType, isSetWarehouseList)
  self._currentWaypointKey = waypointKey
  self._fromType = fromType
  self._currentRegionName = getRegionNameByWaypointKey(self._currentWaypointKey)
  WarehouseListMenu._isSetWarehouseList = isSetWarehouseList
  self._ui.txt_WarehouseName:SetText(self._currentRegionName)
  self._isSorted = ToClient_IsSortedWarehouse()
  if eWarehouseTypeWorldmap == self._fromType then
    local regionInfoWrapper = ToClient_getRegionInfoWrapperByWaypoint(waypointKey)
    if nil ~= regionInfoWrapper and regionInfoWrapper:get():hasDeliveryNpc() then
      self._buttonData.delivery = true
    end
  end
  clearDeliveryPack()
  self._buttonData.manufacture = false
  if eWarehouseTypeNpc == self._fromType or eWarehouseTypeManufacture == self._fromType then
    if true == ToClient_isPossibleManufactureAtWareHouse() then
      if false == PaGlobalFunc_ManufactureCheckShow() and false == self:isDeliveryWindow() and true == isSetWarehouseList then
        self._buttonData.manufacture = true
        _panel:registerPadEvent(__eConsoleUIPadEvent_LTPress_A, "PaGlobal_Warehouse_OpenManufacture()")
      else
        _panel:registerPadEvent(__eConsoleUIPadEvent_LTPress_A, "")
      end
      if eWarehouseTypeManufacture == self._fromType then
        self._ui.txt_Silver:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_COMMON_CONFIRM"))
        _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "PaGlobalFunc_ManufactureDo()")
      end
    end
  else
    _panel:registerPadEvent(__eConsoleUIPadEvent_LTPress_A, "")
  end
  local myRegionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  local hasItemMarket = myRegionInfo:get():hasItemMarketNpc()
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  if true == hasItemMarket and nil ~= dialog_getTalker() and true == dialog_isTalking() and false == self:isGuildHouse() then
    self._buttonData.marketRegist = true
  else
    self._buttonData.marketRegist = false
  end
  self._buttonData.sendMoney = false
  if true == FGlobal_Warehouse_IsMoveItem() and false == self:isDeliveryWindow() then
    self._buttonData.sendMoney = true
  end
  self._buttonData.guildUpdate = false
  self:panelSizeChange(self:isNpc())
  _panel:SetShow(true, true)
  _panel:ComputePos()
  self._startSlotIndex = 0
  self._ui.scroll_Warehouse:SetControlTop()
  warehouse_requestInfo(self._currentWaypointKey)
  if eWarehouseTypeMaid == fromType then
    local gapX = (getOriginScreenSizeX() - getScreenSizeX()) / 2
    local gapY = (getOriginScreenSizeY() - getScreenSizeY()) / 2
    _panel:SetPosX(200 + gapX)
    _panel:SetPosY(getScreenSizeY() / 2 - _panel:GetSizeY() / 2 + gapY)
  elseif eWarehouseTypeManufacture == fromType then
    local gapX = (getOriginScreenSizeX() - getScreenSizeX()) / 2
    _panel:SetPosX(getScreenSizeX() - _panel:GetSizeX() + gapX)
    _panel:SetPosY(Panel_Window_Manufacture:GetPosY())
  end
  self:update()
  self:updateButtonInfo()
  if eWarehouseTypeInstallation == self._fromType or self:isMaid() then
    Warehouse._ui.txt_NotAvaliable:SetShow(true)
    WarehouseListMenu._list:SetShow(false)
  elseif false == WarehouseListMenu._isFirstOpened then
    WarehouseListMenu:updateWarehouseList()
  end
end
function Warehouse:update()
  local warehouseWrapper = self:getWarehouse()
  if nil == warehouseWrapper then
    return
  end
  self._isCanUseMaid = true
  local useStartSlot = 1
  local itemCount = warehouseWrapper:getSize()
  local useMaxCount = warehouseWrapper:getUseMaxCount()
  local freeCount = warehouseWrapper:getFreeCount()
  local money_s64 = warehouseWrapper:getMoney_s64()
  local maxCount = warehouseWrapper:getMaxCount()
  if itemCount > useMaxCount - useStartSlot then
    self._ui.txt_WarehouseCapacity:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "Lua_WareHouse_OverCapacity", "HaveCount", tostring(itemCount), "FullCount", tostring(useMaxCount - useStartSlot)))
  else
    self._ui.txt_WarehouseCapacity:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "Lua_WareHouse_Capacity", "HaveCount", tostring(itemCount), "FullCount", tostring(useMaxCount - useStartSlot)))
  end
  self._ui.txt_MoneyValue:SetText(makeDotMoney(money_s64))
  local slotNoList = Array.new()
  slotNoList:fill(useStartSlot, maxCount - 1)
  if self._isSorted then
    local sortList = Array.new()
    sortList:fill(useStartSlot, useMaxCount - 1)
    sortList:quicksort(Warehouse_ItemComparer)
    for ii = 1, useMaxCount - 1 do
      slotNoList[ii] = sortList[ii]
    end
  end
  for slotIdx = 0, self._config.slotCount - 1 do
    local slot = self._slotBgData[slotIdx]
    slot.base:SetShow(true)
    slot.lock:SetShow(false)
    if slotIdx >= useMaxCount - useStartSlot - self._startSlotIndex then
      slot.lock:SetShow(true)
    end
    if slotIdx >= maxCount - self._startSlotIndex - 1 then
      slot.base:SetShow(false)
      slot.lock:SetShow(false)
      self._slotItemData[slotIdx].icon:EraseAllEffect()
    end
  end
  for slotIdx = 0, self._config.slotCount - 1 do
    local slot = self._slotItemData[slotIdx]
    slot:clearItem()
    slot.icon:SetEnable(true)
    slot.icon:SetMonoTone(true)
  end
  if false == self:isGuildHouse() then
    self._myAsset = toInt64(0, 0)
    if useMaxCount >= 2 then
      for slotIdx = 0, useMaxCount - 2 do
        local slotNo = slotNoList[1 + slotIdx + 0]
        local itemWrapper = warehouseWrapper:getItem(slotNo)
        if nil ~= itemWrapper then
          local itemSSW = itemWrapper:getStaticStatus()
          local itemEnchantKey = itemSSW:get()._key:get()
          local itemCount_s64 = itemWrapper:get():getCount_s64()
          local npcSellPrice_s64 = itemSSW:get()._sellPriceToNpc_s64
          local itemEnchantLevel = itemSSW:get()._key:getEnchantLevel()
          if true == _ContentsGroup_RenewUI_ItemMarketPlace_Only then
            local marketPriceByWarehouse = ToClient_getWorldMarketPriceToWareHouse(itemEnchantKey)
            if marketPriceByWarehouse > toInt64(0, 0) then
              self._myAsset = self._myAsset + marketPriceByWarehouse * itemCount_s64
            elseif 0 == itemEnchantLevel then
              self._myAsset = self._myAsset + npcSellPrice_s64 * itemCount_s64
            end
          else
            local tradeInfo
            local tradeSummaryInfo = getItemMarketSummaryInClientByItemEnchantKey(itemEnchantKey)
            local tradeMasterInfo = getItemMarketMasterByItemEnchantKey(itemEnchantKey)
            if nil ~= tradeSummaryInfo then
              tradeInfo = tradeSummaryInfo
            elseif nil ~= tradeMasterInfo then
              tradeInfo = tradeMasterInfo
            else
              tradeInfo = nil
            end
            if nil ~= tradeInfo then
              if nil ~= tradeSummaryInfo and toInt64(0, 0) ~= tradeSummaryInfo:getDisplayedTotalAmount() then
                self._myAsset = self._myAsset + (tradeInfo:getDisplayedLowestOnePrice() + tradeInfo:getDisplayedHighestOnePrice()) / toInt64(0, 2) * itemCount_s64
              else
                self._myAsset = self._myAsset + (tradeMasterInfo:getMinPrice() + tradeMasterInfo:getMaxPrice()) / toInt64(0, 2) * itemCount_s64
              end
            else
              self._myAsset = self._myAsset + npcSellPrice_s64 * itemCount_s64
            end
          end
        end
      end
    end
    self._ui.txt_AssetTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WAREHOUSE_ASSETS"))
    self._ui.txt_AssetValue:SetText(makeDotMoney(self._myAsset + money_s64))
  end
  UIScroll.SetButtonSize(self._ui.scroll_Warehouse, self._config.slotCount, maxCount - useStartSlot)
  for ii = 0, self._config.slotCount - 1 do
    local slot = self._slotItemData[ii]
    local slotNo = slotNoList[1 + ii + self._startSlotIndex]
    if nil ~= slotNo then
      slot.slotNo = slotNo
      local row = math.floor(ii / self._config.slotCols)
      local column = ii % self._config.slotCols
      slot.icon:SetPosX(self._config.slotStartX + self._config.slotGapX * column + 2)
      slot.icon:SetPosY(self._config.slotStartY + self._config.slotGapY * row + 2)
      slot.icon:SetMonoTone(false)
      slot.count:SetShow(false)
      local itemExist = false
      local itemWrapper = warehouseWrapper:getItem(slotNo)
      if nil ~= itemWrapper then
        slot:setItem(itemWrapper, slotNo, nil, warehouseWrapper)
        if nil ~= self.itemMarketFilterFunc then
          if false == self.itemMarketFilterFunc(slot.icon, itemWrapper) then
            if self._slotFilterEffect[ii] then
              slot.icon:EraseEffect(self._slotFilterEffect[ii])
              self._slotFilterEffect[ii] = nil
            end
            self._slotFilterEffect[ii] = slot.icon:AddEffect("UI_Inventory_Filtering", true, 0, 0)
            slot.icon:SetMonoTone(false)
            slot.icon:SetEnable(true)
            slot.icon:SetIgnore(false)
          else
            if self._slotFilterEffect[ii] then
              slot.icon:EraseEffect(self._slotFilterEffect[ii])
              self._slotFilterEffect[ii] = nil
            end
            slot.icon:SetMonoTone(true)
            slot.icon:SetEnable(false)
            slot.icon:SetIgnore(true)
          end
        elseif nil ~= self._manufactureFilterFunc then
          local regionKey = getSelfPlayer():getRegionKey()
          if false == self._manufactureFilterFunc(slot.slotNo, itemWrapper, regionKey) then
            if self._slotFilterEffect[ii] then
              slot.icon:EraseEffect(self._slotFilterEffect[ii])
              self._slotFilterEffect[ii] = nil
            end
            self._slotFilterEffect[ii] = slot.icon:AddEffect("UI_Inventory_Filtering", true, 0, 0)
            slot.icon:SetMonoTone(false)
            slot.icon:SetEnable(true)
            slot.icon:SetIgnore(false)
          else
            if self._slotFilterEffect[ii] then
              slot.icon:EraseEffect(self._slotFilterEffect[ii])
              self._slotFilterEffect[ii] = nil
            end
            slot.icon:SetMonoTone(true)
            slot.icon:SetEnable(false)
            slot.icon:SetIgnore(false)
          end
        else
          if self._slotFilterEffect[ii] then
            slot.icon:EraseEffect(self._slotFilterEffect[ii])
            self._slotFilterEffect[ii] = nil
          end
          slot.icon:SetMonoTone(false)
          slot.icon:SetEnable(true)
          slot.icon:SetIgnore(false)
        end
        if nil == self.itemMarketFilterFunc then
          local packingCount_s64 = delivery_getPackItemCount(slotNo)
          if Defines.s64_const.s64_0 == itemWrapper:get():getCount_s64() then
            slot.icon:SetMonoTone(true)
          else
            slot.count:SetShow(true)
          end
        end
        itemExist = true
        if true == self._sellCheck then
          if false == warehouse_itemMarketFilterFunc(nil, itemWrapper) and false == itemWrapper:isCash() and itemWrapper:getStaticStatus():isDisposalWareHouse() then
            local isCheck = warehouseWrapper:isSellToSystem(slotNo)
            slot.checkBox:SetShow(true)
            slot.checkBox:SetCheck(isCheck)
            slot.checkBox:addInputEvent("Mouse_LUp", "PaGlobalFunc_Warehouse_CheckBoxSet(" .. slotNo .. ")")
            slot.icon:SetMonoTone(false)
          else
            slot.icon:SetMonoTone(true)
          end
        else
          slot.checkBox:SetShow(false)
        end
      else
        if nil ~= self._slotFilterEffect[ii] then
          slot.icon:EraseEffect(self._slotFilterEffect[ii])
          self._slotFilterEffect[ii] = nil
        end
        slot.icon:SetMonoTone(false)
        slot.icon:SetEnable(true)
        slot.icon:SetIgnore(false)
      end
      if false == itemExist then
        slot:clearItem()
        slot.icon:SetEnable(true)
        slot.icon:SetMonoTone(true)
        slot.icon:SetIgnore(false)
      end
      slot.icon:SetEnableDragAndDrop(self:isNpc() or self:isMaid())
    end
  end
  local showCheck = true == self:isGuildHouse() or true == self:isFurnitureWareHouse()
  self._ui.txt_AssetTitle:SetShow(not showCheck)
  self._ui.txt_AssetValue:SetShow(not showCheck)
  if true == ToClient_isConsole() then
    self._ui.txt_AssetTitle:SetShow(false)
    self._ui.txt_AssetValue:SetShow(false)
  end
  PaGlobalFunc_FloatingTooltip_Close()
  self:panelSizeChange(self:isNpc())
end
function WarehouseListMenu:updateWarehouseList()
  local warehouseCount = ToClient_FindWareHouse(getCurrentWaypointKey())
  if 0 == warehouseCount then
    return
  end
  local currentWaypointKey = getCurrentWaypointKey()
  local currnetRegionInfoWrapper = ToClient_getRegionInfoWrapperByWaypoint(currentWaypointKey)
  if nil == currnetRegionInfoWrapper then
    return
  end
  local currentTerritoryKey = currnetRegionInfoWrapper:getTerritoryKeyRaw()
  self._warehouseInfo.territoryCount = 0
  self._warehouseInfo.territoryGroup = {}
  for index = 0, warehouseCount - 1 do
    local waypointKey = ToClient_getWareHouseWaypointKey(index)
    local regionInfoWrapper = ToClient_getRegionInfoWrapperByWaypoint(waypointKey)
    local territoryKey = regionInfoWrapper:getTerritoryKeyRaw()
    if nil == self._warehouseInfo.territoryGroup[territoryKey] then
      self._warehouseInfo.territoryCount = self._warehouseInfo.territoryCount + 1
      self._warehouseInfo.territoryGroup[territoryKey] = {}
      self._warehouseInfo.territoryGroup[territoryKey].count = 1
      self._warehouseInfo.territoryGroup[territoryKey][1] = waypointKey
      self._territoryNameInfo[territoryKey] = regionInfoWrapper:getTerritoryName()
    else
      self._warehouseInfo.territoryGroup[territoryKey].count = self._warehouseInfo.territoryGroup[territoryKey].count + 1
      self._warehouseInfo.territoryGroup[territoryKey][self._warehouseInfo.territoryGroup[territoryKey].count] = waypointKey
    end
  end
  self._selectIndex = -1
  self._selectWaypointKey = -1
  self._list:getElementManager():clearKey()
  if false == self._isSetWarehouseList then
    local paddingSizeX = 30
    _panel:SetSize(Warehouse._panelSizeX - Warehouse._ui.stc_LeftBg:GetSizeX(), _panel:GetSizeY())
    Warehouse._ui.stc_TopBg:SetSize(Warehouse._panelSizeX - Warehouse._ui.stc_LeftBg:GetSizeX(), Warehouse._ui.stc_TopBg:GetSizeY())
    Warehouse._ui.stc_CenterBg:SetSize(Warehouse._panelSizeX - Warehouse._ui.stc_LeftBg:GetSizeX(), Warehouse._ui.stc_CenterBg:GetSizeY())
    Warehouse._ui.txt_WarehouseTitle:SetPosX(Warehouse._ui.stc_LeftBg:GetPosX() + paddingSizeX)
    Warehouse._ui.txt_WarehouseName:SetPosX(Warehouse._ui.stc_LeftBg:GetPosX() + paddingSizeX)
    Warehouse._ui.stc_ItemSlotFrame:SetPosX(Warehouse._ui.stc_LeftBg:GetPosX() + paddingSizeX)
    Warehouse._ui.txt_WarehouseCapacity:SetPosX(Warehouse._ui.txt_WarehouseCapacity:GetPosX() - Warehouse._ui.stc_LeftBg:GetSizeX())
    Warehouse._ui.txt_MoneyTitle:SetPosX(Warehouse._ui.stc_LeftBg:GetPosX() + paddingSizeX)
    Warehouse._ui.txt_MoneyValue:SetPosX(Warehouse._ui.txt_MoneyValue:GetPosX() - Warehouse._ui.stc_LeftBg:GetSizeX())
    Warehouse._ui.scroll_Warehouse:SetPosX(Warehouse._ui.scroll_Warehouse:GetPosX() - Warehouse._ui.stc_LeftBg:GetSizeX() + paddingSizeX)
    Warehouse._ui.txt_WarehouseCapacity:ComputePos()
    Warehouse._ui.txt_MoneyValue:ComputePos()
    Warehouse._ui.scroll_Warehouse:ComputePos()
    Warehouse._ui.stc_LeftBg:SetShow(false)
  else
    local gapX = (getOriginScreenSizeX() - getScreenSizeX()) / 2
    _panel:ComputePos()
    _panel:SetPosX(200 + gapX)
    _panel:SetSize(Warehouse._panelSizeX, _panel:GetSizeY())
    Warehouse._ui.stc_TopBg:SetSize(Warehouse._panelSizeX, Warehouse._ui.stc_TopBg:GetSizeY())
    Warehouse._ui.stc_CenterBg:SetSize(Warehouse._panelSizeX, Warehouse._ui.stc_CenterBg:GetSizeY())
    Warehouse._ui.txt_WarehouseTitle:ComputePos()
    Warehouse._ui.txt_WarehouseTitle:SetPosX(Warehouse._ui.txt_WarehouseTitle:GetPosX())
    Warehouse._ui.txt_WarehouseName:ComputePos()
    Warehouse._ui.txt_WarehouseName:SetPosX(Warehouse._ui.txt_WarehouseName:GetPosX())
    Warehouse._ui.stc_ItemSlotFrame:ComputePos()
    Warehouse._ui.stc_ItemSlotFrame:SetPosX(Warehouse._ui.stc_ItemSlotFrame:GetPosX())
    Warehouse._ui.txt_WarehouseCapacity:ComputePos()
    Warehouse._ui.txt_WarehouseCapacity:SetPosX(Warehouse._ui.txt_WarehouseCapacity:GetPosX())
    Warehouse._ui.txt_MoneyTitle:ComputePos()
    Warehouse._ui.txt_MoneyTitle:SetPosX(Warehouse._ui.txt_MoneyTitle:GetPosX())
    Warehouse._ui.txt_MoneyValue:ComputePos()
    Warehouse._ui.txt_MoneyValue:SetPosX(Warehouse._ui.txt_MoneyValue:GetPosX())
    Warehouse._ui.scroll_Warehouse:ComputePos()
    Warehouse._ui.scroll_Warehouse:SetPosX(Warehouse._ui.scroll_Warehouse:GetPosX())
    Warehouse._ui.stc_LeftBg:SetShow(true)
    Warehouse._ui.txt_NotAvaliable:SetShow(false)
    self._list:SetShow(true)
    for index = 0, self._maxTerritoryKeyCount - 1 do
      if nil ~= self._warehouseInfo.territoryGroup[index] then
        self._list:getElementManager():pushKey(toInt64(0, index))
      end
    end
  end
  InputMLUp_WarehouseListMenu_TerritoryOpen(currentTerritoryKey, true)
end
function WarehouseListMenu:ClickOtherTown(waypointKey)
  if waypointKey == getCurrentWaypointKey() then
    Warehouse_OpenPanelFromDialog()
  else
    if true == PaGlobalFunc_InventoryInfo_GetShow() then
      local filterFunc = Warehouse._invenFilterFunc
      local optionalEvent = {
        func = PaGlobalFunc_InventoryInfo_PopMoney,
        keyGuideString = PAGetString(Defines.StringSheet_GAME, "LUA_GUILDLIST_DEPOSIT_TITLE")
      }
      Inventory_SetFunctor(filterFunc, FGlobal_PopupMoveItem_InitByInventory, nil, nil, optionalEvent)
      PaGlobalFunc_InventoryInfo_SetMoneyButton(false)
      PaGlobalFunc_InventoryInfo_Close()
      _AudioPostEvent_SystemUiForXBOX(3, 12)
    end
    if true == Warehouse:isDeliveryWindow() then
      DeliveryRequestWindow_Close()
    end
    Warehouse_OpenPanelFromWorldmap(waypointKey, eWarehouseTypeWorldmap)
  end
  local beforeWaypointKey = self._selectWaypointKey
  self._selectWaypointKey = waypointKey
  if beforeWaypointKey > 0 then
    self._list:requestUpdateByKey(toInt64(0, beforeWaypointKey + self._separatorNumber))
  end
  self._list:requestUpdateByKey(toInt64(0, waypointKey + self._separatorNumber))
  InputMO_WarehouseListMenu_SetAKeyGuide(false)
end
function WarehouseListMenu:ClickCurrentTown()
  self._selectIndex = -1
  self._selectWaypointKey = -1
  Warehouse_OpenPanelFromDialog()
end
function Warehouse:updateButtonInfo()
  if false == self._isSorted then
    self._ui.txt_sort:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_GENERIC_KEYGUIDE_XBOX_SORT"))
  else
    self._ui.txt_sort:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_INVENTORY_KEYGUIDE_UNSORT"))
  end
  self._ui.txt_Select:SetShow(self._buttonData.selectItem)
  self._ui.txt_Silver:SetShow(self._buttonData.sendMoney)
  self._ui.txt_Manufacture:SetShow(self._buttonData.manufacture)
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(self._keyGuides, self._ui.stc_BottomBg, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
end
function Warehouse:popWarehouseItem(slotNo)
  local warehouseWrapper = self:getWarehouse()
  local itemWrapper = warehouseWrapper:getItem(slotNo)
  if nil == itemWrapper then
    if slotNo == getMoneySlotNo() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_KNOWLEDGEMANAGEMENT_ACK_MAKEBOOK"))
      return
    end
    return
  end
  if Defines.s64_const.s64_0 == itemWrapper:get():getCount_s64() then
    return
  end
  FGlobal_PopupMoveItem_Init(nil, slotNo, CppEnums.MoveItemToType.Type_Warehouse, nil, true)
end
function Warehouse:getWarehouse()
  local warehouseWrapper
  if true == self:isGuildHouse() then
    warehouseWrapper = warehouse_getGuild()
  elseif true == self:isFurnitureWareHouse() then
    warehouseWrapper = ToClient_getFurniturewarehouse()
  else
    warehouseWrapper = warehouse_get(self._currentWaypointKey)
  end
  return warehouseWrapper
end
function Warehouse:panelSizeChange(isNpc)
end
function Warehouse:registEvent()
  self._ui.list_Warehouse:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_Warehouse_CreateWarehouseListControl")
  self._ui.list_Warehouse:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  _panel:RegisterShowEventFunc(true, "PaGlobalFunc_Warehouse_ShowAni()")
  _panel:RegisterShowEventFunc(false, "PaGlobalFunc_Warehouse_HideAni()")
  _panel:registerPadEvent(__eConsoleUIPadEvent_LSClick, "Warehouse_CheckSort()")
  registerEvent("FromClient_WarehouseOpenByInstallation", "FromClient_Warehouse_OpenByInstallation")
  registerEvent("EventWarehouseUpdate", "FromClient_WarehouseUpdate")
  registerEvent("FromClient_WarehouseClose", "Warehouse_Close")
  registerEvent("EventGuildWarehouseUpdate", "FromClient_Warehouse_GuildWarehouseUpdate")
  registerEvent("FromClient_FurnitureWarehouseUpdate", "FromClient_Warehouse_FurnitureWarehouseUpdate")
  registerEvent("FromClient_UpdateInventoryBag", "FromClient_Warehouse_UpdateInventoryBag")
  registerEvent("FromClient_InventoryUpdate", "FromClient_Warehouse_UpdateInventory")
  registerEvent("EventWarehouseUpdate", "FromClient_WarehouseListMenu_UpdateList")
end
function PaGlobalFunc_Warehouse_GetShow()
  return _panel:GetShow()
end
function Warehouse_GetItem(slotNo)
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  local warehouseWrapper = self:getWarehouse()
  if nil == warehouseWrapper then
    return nil
  end
  return warehouseWrapper:getItem(slotNo)
end
function Warehouse_Close()
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  if true == _panel:GetShow() then
    if true == _ContentsGroup_RenewUI_Delivery then
      if true == PaGlobalFunc_PanelDelivery_GetShow() then
        DeliveryRequestWindow_Close()
      end
    else
      if Panel_Window_Delivery_Information:GetShow() then
        DeliveryInformationWindow_Close()
      end
      if Panel_Window_Delivery_Request:GetShow() then
        DeliveryRequestWindow_Close()
      end
    end
    if true == Panel_Window_Inventory:GetShow() then
      PaGlobalFunc_InventoryInfo_SetMoneyButton(true)
      InventoryWindow_Close()
    end
  end
  WarehouseListMenu._isFirstOpened = false
  WarehouseListMenu._selectWaypointKey = -1
  WarehouseListMenu._selectIndex = -1
  self._fromType = eWarehouseTypeWorldmap
  if nil ~= self._itemMarketFilterFunc then
    self._itemMarketFilterFunc = nil
    self._itemMarketRclickFunc = nil
  end
  if nil ~= self._manufactureRclickFunc then
    self._manufactureFilterFunc = nil
    self._manufactureRclickFunc = nil
  end
  if false == _ContentsGroup_RenewUI_WorldMap then
    if true == ToClient_WorldMapIsShow() then
      WorldMapPopupManager:pop()
    else
      _panel:SetShow(false, false)
    end
  else
    _panel:SetShow(false, false)
  end
  PaGlobalFunc_TooltipInfo_Close()
  if true == ToClient_CheckExistSummonMaid() then
    ToClient_CallHandlerMaid("_maidLogOut")
  end
end
function Warehouse_GetWarehouseWarpper()
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  return self:getWarehouse()
end
function Warehouse_updateSlotData()
  FromClient_WarehouseUpdate()
end
function PaGlobalFunc_Warehouse_CheckBoxSet(slotNo)
  warehouse_checkSellToSystem(slotNo)
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  local warehouseWrapper = self:getWarehouse()
  local isCheck = warehouseWrapper:isSellToSystem(slotNo)
  self._slotItemData[slotNo - 1].checkBox:SetCheck(isCheck)
  self:update()
end
function PaGlobalFunc_Warehouse_CreateWarehouseListControl(content, key)
  local self = WarehouseListMenu
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : WarehouseListMenu")
    return
  end
  local warehouseIdx = Int64toInt32(key)
  local btn_Territory = UI.getChildControl(content, "RadioButton_Territory")
  local btn_Town = UI.getChildControl(content, "RadioButton_Town")
  local txt_Capacitry = UI.getChildControl(content, "StaticText_Capacity")
  local stc_IconMywarehouse = UI.getChildControl(content, "Static_Icon_MywareHouse")
  stc_IconMywarehouse:SetShow(false)
  btn_Territory:SetCheck(false)
  btn_Town:SetCheck(false)
  if warehouseIdx < self._separatorNumber then
    local territoryName = self._territoryNameInfo[warehouseIdx]
    local territoryWarehouseCount = self._warehouseInfo.territoryGroup[warehouseIdx].count
    btn_Territory:SetText(territoryName .. " (" .. territoryWarehouseCount .. ")")
    btn_Territory:addInputEvent("Mouse_LUp", "InputMLUp_WarehouseListMenu_TerritoryOpen(" .. warehouseIdx .. ")")
    btn_Territory:SetMonoTone(false)
    btn_Territory:SetShow(true)
    btn_Town:SetShow(false)
    txt_Capacitry:SetShow(false)
    btn_Territory:addInputEvent("Mouse_On", "InputMO_WarehouseListMenu_SetAKeyGuide(true)")
  else
    btn_Territory:SetShow(false)
    btn_Town:SetShow(true)
    local waypointKey = warehouseIdx - self._separatorNumber
    local regionInfoWrapper = ToClient_getRegionInfoWrapperByWaypoint(waypointKey)
    btn_Town:SetText(regionInfoWrapper:getAreaName())
    local warehouseWrapper = warehouse_get(waypointKey)
    if nil == warehouseWrapper then
      return
    end
    local itemCount = warehouseWrapper:getSize()
    local useMaxCount = warehouseWrapper:getUseMaxCount()
    txt_Capacitry:SetText("(" .. itemCount .. "/" .. useMaxCount - 1 .. ")")
    txt_Capacitry:SetShow(true)
    btn_Town:SetMonoTone(false)
    if waypointKey == self._selectWaypointKey then
      btn_Territory:addInputEvent("Mouse_On", "")
      btn_Town:addInputEvent("Mouse_LUp", "")
      btn_Town:addInputEvent("Mouse_On", "InputMO_WarehouseListMenu_SetAKeyGuide(false)")
      btn_Town:SetFontColor(Defines.Color.C_FFF0D147)
      btn_Town:SetCheck(true)
    else
      btn_Town:addInputEvent("Mouse_LUp", "InputMLUp_WarehouseListMenu_ClickOtherTown(" .. waypointKey .. ")")
      btn_Town:addInputEvent("Mouse_On", "InputMO_WarehouseListMenu_SetAKeyGuide(true)")
      btn_Town:SetFontColor(Defines.Color.C_FF76747D)
      btn_Town:SetCheck(false)
    end
  end
  content:ComputePos()
end
function FromClient_WarehouseUpdate()
  if false == _panel:GetShow() then
    return
  end
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  self:update()
end
function PaGlobalFunc_Warehouse_ShowAni()
end
function PaGlobalFunc_Warehouse_HideAni()
end
function FGlobal_Warehouse_IsMoveItem()
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  if true == self:isNpc() or true == self:isInstallation() or false == self:isWorldMapNode() or true == self:isDeliveryWindow() or true == self:isGuildHouse() or true == self:isMaid() or true == self:isFurnitureWareHouse() then
    return true
  end
  return false
end
function PaGlobalFunc_Warehouse_OpenWithInventory(filterFunc)
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  self._invenFilterFunc = filterFunc
  local optionalEvent = {
    func = PaGlobalFunc_InventoryInfo_PopMoney,
    keyGuideString = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WAREHOUSE_PUTINMONEY")
  }
  Inventory_SetFunctor(filterFunc, FGlobal_PopupMoveItem_InitByInventory, Warehouse_Close, nil, optionalEvent)
  PaGlobalFunc_InventoryInfo_SetMoneyButton(true)
  InventoryWindow_Show()
  self._startSlotIndex = 0
  self._ui.scroll_Warehouse:SetControlTop()
  if false == _ContentsGroup_RenewUI_Inventory then
    ServantInventory_OpenAll()
  end
end
function Warehouse_OpenPanelFromDialog()
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  self._sellCheck = false
  warehouse_clearSellToSystem()
  Warehouse_SetIgnoreMoneyButton(false)
  if false == ToClient_WorldMapIsShow() then
    _panel:SetVerticalMiddle()
    _panel:SetHorizonCenter()
    _panel:SetSpanSize(-251, 5)
  end
  PaGlobalFunc_Warehouse_OpenWithInventory()
  if nil ~= Panel_Window_ItemMarket_RegistItem and true == Panel_Window_ItemMarket_RegistItem:GetShow() then
    FGlobal_ItemMarketRegistItem_Close()
  end
  local isSetWarehouseList = true
  self:open(getCurrentWaypointKey(), eWarehouseTypeNpc, isSetWarehouseList)
end
function Warehouse_OpenPanelFromDialogWithoutInventory(waypointKey, fromType)
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  local isSetWarehouseList = false
  self:open(waypointKey, fromType, isSetWarehouseList)
  Warehouse_SetIgnoreMoneyButton(true)
  if true == ToClient_WorldMapIsShow() then
    _panel:SetVerticalMiddle()
    _panel:SetHorizonCenter()
    _panel:SetSpanSize(-251, 5)
  end
end
function Warehouse_OpenPanelFromWorldmap(waypointKey, fromType)
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  if false == _ContentsGroup_RenewUI_WorldMap then
    if true == ToClient_WorldMapIsShow() then
      WorldMapPopupManager:increaseLayer(true)
      WorldMapPopupManager:push(_panel, true)
      _panel:SetVerticalMiddle()
      _panel:SetHorizonCenter()
      _panel:SetSpanSize(-251, 5)
    end
  else
    _panel:SetShow(true)
    _panel:SetVerticalMiddle()
    _panel:SetHorizonCenter()
    _panel:SetSpanSize(-251, 5)
  end
  local isSetWarehouseList = false
  self:open(waypointKey, fromType, isSetWarehouseList)
  Warehouse_SetIgnoreMoneyButton(true)
  if false == FGlobal_Warehouse_IsMoveItem() then
    DeliveryRequestWindow_Close()
    if true ~= _ContentsGroup_RenewUI_Delivery then
      DeliveryInformationWindow_Close()
    end
  end
  self._buttonData.marketRegist = false
end
function Warehouse_OpenPanelFromMaid()
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  if nil == regionInfo then
    return
  end
  local regionInfoWrapper = getRegionInfoWrapper(regionInfo:getAffiliatedTownRegionKey())
  local plantWayKey = regionInfoWrapper:getPlantKeyByWaypointKey():getWaypointKey()
  local regionKey = regionInfoWrapper:getRegionKey()
  if ToClient_IsAccessibleRegionKey(regionKey) == false then
    plantWayKey = ToClient_GetOtherRegionKey_NeerByTownRegionKey()
    if 0 == plantWayKey then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CANTFIND_WAREHOUSE_INTERRITORY"))
      return
    end
  end
  self._currentWaypointKey = plantWayKey
  Warehouse_SetIgnoreMoneyButton(false)
  local isSetWarehouseList = false
  self:open(plantWayKey, eWarehouseTypeMaid, isSetWarehouseList)
  PaGlobalFunc_Warehouse_OpenWithInventory()
end
function PaGlobal_Warehouse_OpenManufacture()
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  if eWarehouseTypeManufacture == self._fromType then
    return
  end
  if false == ToClient_isPossibleManufactureAtWareHouse() then
    return
  end
  PaGlobalFunc_ManufactureOpen(true)
  Panel_Window_Manufacture:SetPosX(10)
  PaGlobalFunc_Manufacture_SetFromWareHouse()
  PaGlobalFunc_MainDialog_Open()
  Warehouse_Close()
end
function Warehouse_OpenPanelFromManufacture()
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  local isSetWarehouseList = false
  self:open(getCurrentWaypointKey(), eWarehouseTypeManufacture, isSetWarehouseList)
  ToClient_padSnapResetControl()
end
function Warehouse_SetFunctor(filterFunc, rClickFunc)
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  if nil ~= filterFunc and "function" ~= type(filterFunc) then
    filterFunc = nil
    UI.ASSERT(false, "Param 1 must be Function type")
  end
  if nil ~= rClickFunc and "function" ~= type(rClickFunc) then
    rClickFunc = nil
    UI.ASSERT(false, "Param 2 must be Function type")
  end
  self._manufactureFilterFunc = filterFunc
  self._manufactureRclickFunc = rClickFunc
end
function FGlobal_Warehouse_ResetFilter()
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  if nil ~= self._itemMarketFilterFunc then
    self._itemMarketFilterFunc = nil
    self._itemMarketRclickFunc = nil
  end
  self:update()
end
function Warehouse_SetIgnoreMoneyButton(isIgnore)
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  local set = not isIgnore
  self._buttonData.sendMoney = set
  if true == set then
    self._ui.txt_Silver:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WAREHOUSE_PUTOUTMONEY"))
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "InputMLUp_Warehouse_WarehousePopMoney()")
  else
    _panel:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "")
  end
  self:updateButtonInfo()
end
function Warehouse_PushFromInventoryItem(s64_count, whereType, slotNo, fromActorKeyRaw)
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  self._targetActorKeyRaw = fromActorKeyRaw
  Panel_NumberPad_Show_MaxCount(true, s64_count, slotNo, Warehouse_PushFromInventoryItemXXX, nil, whereType)
end
function Warehouse_PushFromInventoryItemXXX(s64_count, slotNo, whereType)
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  if self:isNpc() or Panel_RemoteWarehouse:GetShow() then
    warehouse_requestInfo(getCurrentWaypointKey())
    warehouse_pushFromInventoryItemByNpc(whereType, slotNo, s64_count, self._targetActorKeyRaw)
  elseif true == self:isInstallation() then
    warehouse_pushFromInventoryItemByInstallation(self._installationActorKeyRaw, whereType, slotNo, s64_count, self._targetActorKeyRaw)
  elseif true == self:isGuildHouse() then
    warehouse_pushFromInventoryItemByGuildHouse(whereType, slotNo, s64_count, self._targetActorKeyRaw)
  elseif true == self:isFurnitureWareHouse() then
    ToClient_pushFromInventoryItemByFurnitureWarehouse(whereType, slotNo)
  elseif true == self:isMaid() then
    local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
    if nil == regionInfo then
      return
    end
    local warehouseInMaid = checkMaid_WarehouseIn(true)
    if warehouseInMaid then
      local curTick = getTickCount32()
      if true == self._isCanUseMaid and (nil == self._lastMaidUsedTick or curTick - self._lastMaidUsedTick > 600) then
        self._lastMaidUsedTick = curTick
        self._isCanUseMaid = false
        warehouse_pushFromInventoryItemByMaid(whereType, slotNo, s64_count, self._targetActorKeyRaw)
      elseif false == self._isCanUseMaid and curTick - self._lastMaidUsedTick > 2000 then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "GAME_MESSAGE_WAIT_PROCESS"))
      elseif false == self._isCanUseMaid and curTick - self._lastMaidUsedTick > 5000 then
        self._lastMaidUsedTick = curTick
        warehouse_pushFromInventoryItemByMaid(whereType, slotNo, s64_count, self._targetActorKeyRaw)
      end
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_COOLTIME"))
    end
  end
end
function Warehouse_PopToSomewhere(s64_count, slotNo, toActorKeyRaw)
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  self._targetActorKeyRaw = toActorKeyRaw
  if true == FGlobal_WarehouseOpenByMaidCheck() then
    local warehouseWrapper = Warehouse:getWarehouse()
    local itemWrapper = warehouseWrapper:getItem(slotNo)
    if nil ~= itemWrapper then
      local itemSSW = itemWrapper:getStaticStatus()
      local weight = Int64toInt32(itemSSW:get()._weight) / 10000
      if false == itemSSW:isMoney() then
        if Int64toInt32(s64_count) < 0 then
          s64_count = toInt64(0, 2147483647)
        end
        s64_count = toInt64(0, math.min(math.floor(100 / weight), Int64toInt32(s64_count)))
      end
      if s64_count <= Defines.s64_const.s64_0 then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_SymbolNo, "eErrNoMaidDeliveryCantHeavyItem"))
        return
      end
    end
  end
  Panel_NumberPad_Show(true, s64_count, slotNo, PaGlobalFunc_Warehouse_PopItem)
end
function PaGlobalFunc_Warehouse_PopItem(s64_count, slotNo)
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  local invenIsShow = false
  if true == _ContentsGroup_RenewUI then
    invenIsShow = PaGlobalFunc_InventoryInfo_GetShow()
  else
    invenIsShow = Panel_Window_Inventory:GetShow()
  end
  if true == invenIsShow and GetUIMode() ~= Defines.UIMode.eUIMode_WorldMap then
    if true == self:isNpc() then
      warehouse_requestInfo(getCurrentWaypointKey())
      warehouse_popToInventoryByNpc(slotNo, s64_count, self._targetActorKeyRaw)
    elseif true == self:isInstallation() then
      warehouse_popToInventoryByInstallation(self._installationActorKeyRaw, slotNo, s64_count, self._targetActorKeyRaw)
    elseif true == self:isGuildHouse() then
      warehouse_popToInventoryByGuildHouse(slotNo, s64_count, self._targetActorKeyRaw)
    elseif true == self:isFurnitureWareHouse() then
      ToClient_popToInventoryByFurnitureWarehouse(slotNo)
    elseif true == self:isMaid() then
      local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
      if nil == regionInfo then
        return
      end
      local warehouseOutMaid = checkMaid_WarehouseOut(true)
      if true == warehouseOutMaid then
        warehouse_requestInfo(self._currentWaypointKey)
        warehouse_popToInventoryByMaid(slotNo, s64_count, self._targetActorKeyRaw)
      else
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_COOLTIME"))
      end
    end
  elseif PaGlobalFunc_PanelDelivery_GetShow() then
    DeliveryRequest_PushPackingItem(slotNo, s64_count)
  end
end
function Warehouse_ItemComparer(ii, jj)
  return Global_ItemComparer(ii, jj, Warehouse_GetItem)
end
function Warehouse_CheckSort()
  local self = Warehouse
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  self._isSorted = not self._isSorted
  ToClient_SetSortedWarehouse(self._isSorted)
  FromClient_WarehouseUpdate()
  self:updateButtonInfo()
end
function FGlobal_WarehouseOpenByMaidCheck()
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  return self:isMaid()
end
function FGlobal_WarehouseTownListCheck()
end
function PaGlobalFunc_Warehouse_MovieHelp(isOn)
end
function PaGlobalFunc_Warehouse_Init()
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  self:init()
end
function FromClient_Warehouse_OpenByInstallation(actorKeyRaw, waypointKey)
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  self._installationActorKeyRaw = actorKeyRaw
  local isSetWarehouseList = false
  self:open(waypointKey, eWarehouseTypeInstallation, isSetWarehouseList)
  Warehouse_SetIgnoreMoneyButton(false)
  PaGlobalFunc_Warehouse_OpenWithInventory()
end
function FromClient_Warehouse_GuildWarehouseUpdate(bForcedOpen, bForcedClose)
  if true == Worldmap_Grand_GuildHouseControl:GetShow() or true == Worldmap_Grand_GuildCraft:GetShow() then
    return
  end
  if true == _ContentsGroup_NewUI_NpcShop_All and nil ~= PaGlobalFunc_NPCShop_ALL_GetShow then
    if true == PaGlobalFunc_NPCShop_ALL_GetShow() then
      FromClient_NPCShop_ALL_PushKeyToList2()
      return
    end
  elseif true == _ContentsGroup_RenewUI_NpcShop then
    if PaGlobalFunc_Dialog_NPCShop_IsShow() then
      FromClient_Dialog_NPCShop_UpdateContent()
      return
    end
  elseif Panel_Window_NpcShop:IsShow() then
    NpcShop_UpdateContent()
    return
  end
  if false == bForcedOpen and false == _panel:GetShow() then
    return
  end
  if true == bForcedClose then
    Warehouse_Close()
    return
  end
  if true == _panel:GetShow() and false == warehouse.BtnGuildUpdate:GetShow() then
    return
  end
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  self._currentWaypointKey = 0
  self._fromType = CppEnums.WarehoouseFromType.eWarehoouseFromType_GuildHouse
  self._currentRegionName = PAGetString(Defines.StringSheet_GAME, "Lua_WareHouse_CurrentRegionName")
  self.staticTitle:SetText(self._currentRegionName)
  self:update()
  warehouse.BtnMarketRegist:SetShow(false)
  warehouse.BtnManufacture:SetShow(false)
  warehouse._buttonDelivery:SetShow(false)
  warehouse.BtnGuildUpdate:SetShow(true)
  Warehouse_SetIgnoreMoneyButton(true)
  _panel:SetShow(true, true)
  PaGlobalFunc_Warehouse_OpenWithInventory()
end
function FromClient_Warehouse_FurnitureWarehouseUpdate()
  if false == _ContentsGroup_isFurnitureWarehouse then
    return
  end
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  self._currentWaypointKey = 0
  self._fromType = CppEnums.WarehoouseFromType.eWarehoouseFromType_Furniture
  self._currentRegionName = PAGetString(Defines.StringSheet_GAME, "Lua_WareHouse_FurnitureName")
  self._ui.txt_WarehouseName:SetText(self._currentRegionName)
  self:update()
  self._buttonData.marketRegist = false
  self._buttonData.manufacture = false
  self._buttonData.delivery = false
  self._buttonData.guildUpdate = false
  self._buttonData.sendMoney = false
  _panel:SetShow(true, true)
  if false == Panel_Window_Inventory:IsShow() then
    PaGlobalFunc_Warehouse_OpenWithInventory(FGlobal_FurnitureWarehouse_Filter)
    _panel:SetVerticalTop()
  end
end
function InputMRUp_Warehouse_WarehouseItemClicked(slotIdx)
  if false == FGlobal_Warehouse_IsMoveItem() then
    return
  end
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  local slotNo = self._slotItemData[slotIdx].slotNo
  if nil == self._itemMarketRclickFunc and nil == self._manufactureRclickFunc then
    self:popWarehouseItem(slotNo)
  else
    local warehouseWrapper = self:getWarehouse()
    local itemWrapper = warehouseWrapper:getItem(slotNo)
    if nil ~= self._manufactureRclickFunc and nil ~= itemWrapper then
      self._manufactureRclickFunc(slotNo, itemWrapper, itemWrapper:get():getCount_s64(), CppEnums.ItemWhereType.eWarehouse)
    elseif nil ~= itemWrapper then
      warehouse_itemMarketRclickFunc(slotNo, itemWrapper, itemWrapper:get():getCount_s64())
    end
  end
end
function InputMO_Warehouse_IconOver(index)
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  local slot = self._slotItemData[index]
  if nil ~= Warehouse_GetItem(slot.slotNo) and true == FGlobal_Warehouse_IsMoveItem() then
    self._buttonData.selectItem = true
    if eWarehouseTypeManufacture == self._fromType then
      local isShow = nil ~= self._slotFilterEffect[index]
      self._buttonData.selectItem = isShow
    end
  else
    self._buttonData.selectItem = false
  end
  self:updateButtonInfo()
  local warehouseWrapper = self:getWarehouse()
  if nil == warehouseWrapper then
    return
  end
  local itemWrapper = warehouseWrapper:getItem(slot.slotNo)
  if nil ~= itemWrapper then
    PaGlobalFunc_FloatingTooltip_Open(Defines.TooltipDataType.ItemSSWrapper, itemWrapper:getStaticStatus(), Defines.TooltipTargetType.Item, self._slotBgData[index].base)
  end
end
function InputMOut_Warehouse_IconOut(index)
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  local slot = self._slotItemData[index]
  self._tooltipSlotNo = nil
  PaGlobalFunc_TooltipInfo_Close()
end
function Warehouse_GetToolTipItemNo()
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  local warehouseWrapper = self:getWarehouse()
  if nil == warehouseWrapper then
    return nil
  end
  if nil == self._tooltipSlotNo then
    return nil
  end
  return warehouseWrapper:getItemNoBySlotNo(self._tooltipSlotNo)
end
function Warehouse_GetToopTipItem()
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  local warehouseWrapper = self:getWarehouse()
  if nil == warehouseWrapper then
    return nil
  end
  if nil == self._tooltipSlotNo then
    return nil
  end
  return (warehouseWrapper:getItem(self._tooltipSlotNo))
end
function FGlobal_Warehouse_GetToolTipItemSlotNo()
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  local warehouseWrapper = self:getWarehouse()
  if nil == warehouseWrapper then
    return nil
  end
  return self._tooltipSlotNo
end
function PaGlobalFunc_Warehouse_Scroll(isUp)
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  local useStartSlot = 1
  local warehouseWrapper = self:getWarehouse()
  if nil == warehouseWrapper then
    return
  end
  local maxSize = warehouseWrapper:getMaxCount() - useStartSlot
  local maxSize = maxSize + self._config.slotCols - maxSize % self._config.slotCols
  self._startSlotIndex = UIScroll.ScrollEvent(self._ui.scroll_Warehouse, isUp, self._config.slotRows, maxSize, self._startSlotIndex, self._config.slotCols)
  self:update()
end
function Input_Warehouse_ShowTooltip(slotIdx, isShow)
  local self = Warehouse
  if isShow then
    local warehouseWrapper = self:getWarehouse()
    if nil == warehouseWrapper then
      return
    end
    local itemWrapper = warehouseWrapper:getItem(self._slotItemData[slotIdx].slotNo)
    if nil ~= itemWrapper then
      PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemWrapper, itemWrapper, Defines.TooltipTargetType.Item, 0, getScreenSizeX())
      PaGlobalFunc_FloatingTooltip_Close()
    end
  else
    PaGlobalFunc_TooltipInfo_Close()
  end
end
function InputMLUp_Warehouse_WarehousePopMoney()
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  local slotNo = getMoneySlotNo()
  if false == FGlobal_Warehouse_IsMoveItem() then
    return
  end
  self:popWarehouseItem(slotNo)
end
function InputMO_Warehouse_ShowSlotHighlight(isShow, idx)
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  local slot = self._slotBgData[idx].base
  if nil == slot then
    return
  end
  if true == isShow then
    local x1, y1, x2, y2 = setTextureUV_Func(slot, 50, 195, 94, 239)
    slot:getBaseTexture():setUV(x1, y1, x2, y2)
  else
    local x1, y1, x2, y2 = setTextureUV_Func(slot, 143, 195, 187, 239)
    slot:getBaseTexture():setUV(x1, y1, x2, y2)
  end
  slot:setRenderTexture(slot:getBaseTexture())
end
function InputMLUp_WarehouseListMenu_TerritoryOpen(territoryKey, isFirstOpen)
  local self = WarehouseListMenu
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : WarehouseListMenu")
    return
  end
  self._list:getElementManager():clearKey()
  for index = 0, self._maxTerritoryKeyCount - 1 do
    if nil ~= self._warehouseInfo.territoryGroup[index] then
      self._list:getElementManager():pushKey(toInt64(0, index))
      if index == territoryKey then
        if self._selectIndex == territoryKey then
          self._selectIndex = -2
        else
          local maxTerritoryWarehouseCount = self._warehouseInfo.territoryGroup[index].count
          for wIndex = 1, maxTerritoryWarehouseCount do
            warehouse_requestInfo(self._warehouseInfo.territoryGroup[index][wIndex])
            local waypointKey = self._warehouseInfo.territoryGroup[index][wIndex] + self._separatorNumber
            self._list:getElementManager():pushKey(toInt64(0, waypointKey))
          end
          self._selectIndex = territoryKey
        end
      end
    end
  end
  if true == isFirstOpen then
    self._selectWaypointKey = getCurrentWaypointKey()
    self._isFirstOpened = true
  end
end
function InputMLUp_WarehouseListMenu_ClickOtherTown(waypointKey)
  local self = WarehouseListMenu
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : WarehouseListMenu")
    return
  end
  self:ClickOtherTown(waypointKey)
end
function InputMO_WarehouseListMenu_SetAKeyGuide(isShow)
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  self._buttonData.selectItem = isShow
  self:updateButtonInfo()
end
function FromClient_WarehouseListMenu_UpdateList(waypointKey)
  local self = WarehouseListMenu
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : WarehouseListMenu")
    return
  end
  self._list:requestUpdateByKey(toInt64(0, waypointKey + self._separatorNumber))
end
function FromClient_Warehouse_UpdateInventoryBag(addFlag)
  if false == addFlag then
    return
  end
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  self:update()
end
function FromClient_Warehouse_UpdateInventory()
  if true == _ContentsGroup_InvenUpdateCheck and false == _panel:GetShow() then
    return
  end
  local self = Warehouse
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Warehouse")
    return
  end
  self:update()
end
function FGlobal_FurnitureWarehouse_Filter(slotNo, notUse_itemWrappers, whereType)
  local itemWrapper = getInventoryItemByType(whereType, slotNo)
  if nil == itemWrapper then
    return true
  end
  if true == itemWrapper:getStaticStatus():isItemInstallation() then
    return false
  end
  return true
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_Warehouse_Init")

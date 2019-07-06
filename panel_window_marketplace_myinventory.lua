local _panel = Panel_Window_MarketPlace_MyInventory
local UI_color = Defines.Color
local MarketPlace_MyInven = {
  _ui = {
    stc_Title = UI.getChildControl(_panel, "StaticText_Title"),
    stc_TopBg = UI.getChildControl(_panel, "Static_TopItemSortBG"),
    btn_NormalInven = UI.getChildControl(_panel, "RadioButton_NormalInventory"),
    btn_CashInven = UI.getChildControl(_panel, "RadioButton_CashInventory"),
    btn_WareHouseInven = UI.getChildControl(_panel, "RadioButton_WareHouseInventory"),
    stc_WeightBg = UI.getChildControl(_panel, "Static_Texture_Weight_Background"),
    template_Slot = UI.getChildControl(_panel, "Template_Static_Slot"),
    template_LockSlot = UI.getChildControl(_panel, "Template_Static_LockSlot"),
    btn_Deposit = UI.getChildControl(_panel, "Button_Deposit"),
    scroll_CashInven = UI.getChildControl(_panel, "Scroll_CashInven"),
    stc_ScrollArea = UI.getChildControl(_panel, "Scroll_Area"),
    btn_WareHouseMoney = UI.getChildControl(_panel, "RadioButton_WareHouseMoney"),
    btn_MyInvenMoney = UI.getChildControl(_panel, "RadioButton_MyInvenMoney")
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
    slotCount = 64,
    slotCols = 8,
    slotRows = 0,
    slotStartX = 0,
    slotStartY = 0,
    slotGapX = 53,
    slotGapY = 53
  },
  _slotInvenBgData = {},
  _slotInvenItemData = {},
  _startInvenSlotIndex = 0,
  _isAblePearlProduct = false,
  _moneySlot = 0,
  _currentInvenType = 0,
  _currentRegionKey = 0
}
function PaGlobalFunc_MarketPlace_GetWareHouseCheck()
  local self = MarketPlace_MyInven
  return self._currentInvenType == CppEnums.ItemWhereType.eWarehouse
end
function PaGlobalFunc_MarketPlace_MyInven_Init()
  local self = MarketPlace_MyInven
  self:initData()
  self:initControl()
  self:initEvent()
end
function MarketPlace_MyInven:initControl()
  self._ui.btn_Close = UI.getChildControl(self._ui.stc_Title, "Button_Win_Close")
  self._ui.btn_Question = UI.getChildControl(self._ui.stc_Title, "Button_Question")
  self._ui.checkBtn_PopUp = UI.getChildControl(self._ui.stc_Title, "CheckButton_PopUp")
  self._ui.checkBtn_ItemSort = UI.getChildControl(self._ui.stc_TopBg, "CheckButton_ItemSort")
  self._ui.txt_Capacity = UI.getChildControl(self._ui.stc_TopBg, "Static_Text_Capacity")
  self._ui.progress_Weight = UI.getChildControl(self._ui.stc_WeightBg, "Progress2_Weight")
  self._ui.progress_Equipment = UI.getChildControl(self._ui.stc_WeightBg, "Progress2_Equipment")
  self._ui.progress_Money = UI.getChildControl(self._ui.stc_WeightBg, "Progress2_Money")
  self._ui.txt_MoneyTitle = UI.getChildControl(self._ui.btn_Deposit, "StaticText_MoneyTitle")
  self._ui.txt_MoneyValue = UI.getChildControl(self._ui.btn_Deposit, "StaticText_MoneyValue")
  self._ui.txt_Weight = UI.getChildControl(self._ui.stc_WeightBg, "StaticText_Weight")
  for slotIdx = 0, self._config.slotCount - 1 do
    local slot = {}
    slot.base = UI.createAndCopyBasePropertyControl(_panel, "Template_Static_Slot", _panel, "MarketWallet_Inventory_EmptySlot_" .. slotIdx)
    slot.lock = UI.createAndCopyBasePropertyControl(_panel, "Template_Static_LockSlot", _panel, "MarketWallet_Inventory_LockSlot_" .. slotIdx)
    local row = math.floor(slotIdx / self._config.slotCols)
    local column = slotIdx % self._config.slotCols
    local lockGapX = slot.base:GetSizeX() / 2 - slot.lock:GetSizeX() / 2
    local lockGapY = slot.base:GetSizeY() / 2 - slot.lock:GetSizeY() / 2
    slot.base:SetPosX(self._config.slotStartX + self._config.slotGapX * column)
    slot.base:SetPosY(self._config.slotStartY + self._config.slotGapY * row)
    slot.lock:SetPosXY(slot.base:GetPosX() + lockGapX, slot.base:GetPosY() + lockGapY)
    slot.base:SetShow(true)
    slot.lock:SetShow(false)
    UIScroll.InputEventByControl(slot.base, "PaGlobalFunc_MarketPlace_MyInven_Scroll")
    self._slotInvenBgData[slotIdx] = slot
  end
  for slotIdx = 0, self._config.slotCount - 1 do
    local slot = {}
    SlotItem.new(slot, "MyInventoryItem_" .. slotIdx, slotIdx, _panel, self._slotConfig)
    slot:createChild()
    local row = math.floor(slotIdx / self._config.slotCols)
    local column = slotIdx % self._config.slotCols
    slot.icon:SetPosX(self._config.slotStartX + self._config.slotGapX * column + 2)
    slot.icon:SetPosY(self._config.slotStartY + self._config.slotGapY * row + 2)
    slot.icon:SetEnableDragAndDrop(false)
    slot.icon:SetAutoDisableTime(0.5)
    UIScroll.InputEventByControl(slot.icon, "PaGlobalFunc_MarketPlace_MyInven_Scroll")
    self._slotInvenItemData[slotIdx] = slot
  end
  self._ui.checkBtn_ItemSort:SetText(self._ui.checkBtn_ItemSort:GetText())
  self._ui.checkBtn_ItemSort:SetEnableArea(0, 0, self._ui.checkBtn_ItemSort:GetSizeX() + self._ui.checkBtn_ItemSort:GetTextSizeX() + 10, 25)
end
function MarketPlace_MyInven:initData()
  self._isAblePearlProduct = requestCanRegisterPearlItemOnMarket()
  self._moneySlot = getMoneySlotNo()
  self._config.slotRows = self._config.slotCount / self._config.slotCols
  self._maxSlotRow = math.floor((self._config.slotCount - 1) / self._config.slotCols)
  self._config.slotStartX = self._ui.template_Slot:GetPosX()
  self._config.slotStartY = self._ui.template_Slot:GetPosY()
end
function MarketPlace_MyInven:initEvent()
  UIScroll.InputEvent(self._ui.scroll_CashInven, "PaGlobalFunc_MarketPlace_MyInven_Scroll")
  UIScroll.InputEventByControl(self._ui.stc_ScrollArea, "PaGlobalFunc_MarketPlace_MyInven_Scroll")
  self._ui.checkBtn_ItemSort:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlace_MyInven_CheckSort()")
  self._ui.btn_Deposit:addInputEvent("Mouse_LUp", "InputMRUp_MarketWallet_RegisterMoney()")
  self._ui.btn_Deposit:addInputEvent("Mouse_On", "MarketWallet_DepositMoney_TooltipShow()")
  self._ui.btn_Deposit:addInputEvent("Mouse_Out", "MarketWallet_DepositMoney_TooltipHide()")
  self._ui.btn_Close:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlace_MyInven_Close()")
  self._ui.btn_NormalInven:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlace_SelectTab(" .. CppEnums.ItemWhereType.eInventory .. ")")
  self._ui.btn_CashInven:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlace_SelectTab(" .. CppEnums.ItemWhereType.eCashInventory .. ")")
  self._ui.btn_WareHouseInven:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlace_SelectTab(" .. CppEnums.ItemWhereType.eWarehouse .. ")")
end
function MarketWallet_DepositMoney_TooltipShow()
  local uiControl = MarketPlace_MyInven._ui.btn_Deposit
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_DEPOSITMONEY_NAME")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_DEPOSITMONEY_DESC")
  TooltipSimple_Show(uiControl, name, desc)
end
function MarketWallet_DepositMoney_TooltipHide()
  TooltipSimple_Hide()
end
function PaGlobalFunc_MarketPlace_MyInven_CheckMoney()
  local self = MarketPlace_MyInven
  self:update()
end
function PaGlobalFunc_MarketPlace_MyInven_CheckSort()
  local self = MarketPlace_MyInven
  local isSortChecked = MarketPlace_MyInven._ui.checkBtn_ItemSort:IsCheck()
  ToClient_getGameUIManagerWrapper():setLuaCacheDataListBool(__eMarketPlaceInventorySort, isSortChecked, CppEnums.VariableStorageType.eVariableStorageType_User)
  self:update()
end
function PaGlobalFunc_MarketPlace_MyInven_Scroll(isUp)
  local self = MarketPlace_MyInven
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Panel_Window_MarketPlace_MyInventory")
    return
  end
  if true == PaGlobal_TutorialPhase_IsTutorial() then
    return
  end
  local useStartSlot = __eTInventorySlotNoUseStart
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayer = selfPlayerWrapper:get()
  local inventory = selfPlayer:getInventoryByType(self._currentInvenType)
  local maxSize = inventory:sizeXXX() - useStartSlot
  local prevSlotIndex = self._startInvenSlotIndex
  self._startInvenSlotIndex = UIScroll.ScrollEvent(self._ui.scroll_CashInven, isUp, self._config.slotRows, maxSize, self._startInvenSlotIndex, self._config.slotCols)
  local intervalSlotIndex = 128
  if prevSlotIndex == 0 and self._startInvenSlotIndex == 0 or prevSlotIndex == intervalSlotIndex and self._startInvenSlotIndex == intervalSlotIndex then
    return
  end
  Panel_Tooltip_Item_hideTooltip()
  self:update()
end
function PaGlobalFunc_MarketPlace_MyInven_Update()
  local self = MarketPlace_MyInven
  self:update()
end
function PaGlobalFunc_MarketPlace_SelectTab(tabIdx)
  local self = MarketPlace_MyInven
  self._currentInvenType = tabIdx
  self._ui.btn_NormalInven:SetCheck(tabIdx == CppEnums.ItemWhereType.eInventory)
  self._ui.btn_CashInven:SetCheck(tabIdx == CppEnums.ItemWhereType.eCashInventory)
  self._ui.btn_WareHouseInven:SetCheck(tabIdx == CppEnums.ItemWhereType.eWarehouse)
  self._ui.scroll_CashInven:SetControlPos(0)
  self._startInvenSlotIndex = 0
  if tabIdx == CppEnums.ItemWhereType.eWarehouse then
    self:setForWareHouse()
    self._ui.stc_WeightBg:SetShow(false)
  else
    self._ui.stc_WeightBg:SetShow(true)
  end
  self:update()
end
function MarketPlace_MyInven:setForWareHouse()
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  if nil == regionInfo then
    _PA_ASSERT(false, "\236\167\128\236\151\173 \236\160\149\235\179\180\234\176\128 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : Panel_Window_MarketPlaceWallet")
    return
  end
  local myAffiliatedTownRegionKey = regionInfo:getAffiliatedTownRegionKey()
  local regionInfoWrapper = getRegionInfoWrapper(myAffiliatedTownRegionKey)
  if ToClient_IsAccessibleRegionKey(regionInfo:getAffiliatedTownRegionKey()) == false then
    local plantWayKey = ToClient_GetOtherRegionKey_NeerByTownRegionKey()
    local newRegionInfo = ToClient_getRegionInfoWrapperByWaypoint(plantWayKey)
    if newRegionInfo == nil then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WALLETMANAGER_NO_REGION_WAREHOUSE"))
      return
    end
    myAffiliatedTownRegionKey = newRegionInfo:getRegionKey()
    if 0 == myAffiliatedTownRegionKey then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WALLETMANAGER_NO_REGION_WAREHOUSE"))
      return
    end
  end
  self._currentRegionKey = myAffiliatedTownRegionKey
end
function PaGlobalFunc_MarketPlace_GetMyInvenTab()
  local self = MarketPlace_MyInven
  return self._currentInvenType
end
function PaGlobalFunc_MarketPlace_MyInven_GetMoney()
  local self = MarketPlace_MyInven
  local moneyValue = 0
  if false == PaGlobalFunc_MarketPlace_GetWareHouseCheck() then
    moneyValue = getSelfPlayer():get():getInventory():getMoney_s64()
  else
    moneyValue = warehouse_moneyFromNpcShop_s64()
  end
  return moneyValue
end
function PaGlobalFunc_MarketPlace_MyInven_ItemComparer(ii, jj)
  return Global_ItemComparer(ii, jj, getInventoryItemByType, PaGlobalFunc_MarketPlace_GetMyInvenTab())
end
function PaGlobalFunc_MarketPlace_MyInven_WarehouseComparer(ii, jj)
  return Global_ItemComparer(ii, jj, PaGlobalFunc_MarketPlace_MyInven_Warehouse_GetItem)
end
function PaGlobalFunc_MarketPlace_MyInven_Warehouse_GetItem(slotNo)
  local warehouseWrapper = warehouse_get(getCurrentWaypointKey())
  if nil == warehouseWrapper then
    return nil
  end
  return (warehouseWrapper:getItem(slotNo))
end
function MarketPlace_MyInven:update()
  if CppEnums.ItemWhereType.eWarehouse == self._currentInvenType then
    self:updateWareHouseInventory()
  else
    self:updateInventory()
  end
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayer = selfPlayerWrapper:get()
  local moneyValue, moneyTitle
  if false == PaGlobalFunc_MarketPlace_GetWareHouseCheck() then
    moneyTitle = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_MYINVENTORY_HAS_INVEN_MONEY")
    moneyValue = makeDotMoney(selfPlayer:getInventory():getMoney_s64())
  else
    moneyTitle = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_MYINVENTORY_HAS_WAREHOUSE_MONEY")
    if true == PaGlobalFunc_MarketPlace_IsOpenByMaid() then
      moneyValue = makeDotMoney(PaGlobalFunc_MarketPlace_GetWareHouseMoneyFromMaid())
    else
      moneyValue = makeDotMoney(warehouse_moneyFromNpcShop_s64())
    end
  end
  self._ui.txt_MoneyTitle:SetText(moneyTitle)
  self._ui.txt_MoneyValue:SetText(moneyValue)
  local normalInventory = selfPlayer:getInventoryByType(CppEnums.ItemWhereType.eInventory)
  local _const = Defines.s64_const
  local s64_allWeight = selfPlayer:getCurrentWeight_s64()
  local s64_maxWeight = selfPlayer:getPossessableWeight_s64()
  local s64_moneyWeight = normalInventory:getMoneyWeight_s64()
  local s64_equipmentWeight = selfPlayer:getEquipment():getWeight_s64()
  local s64_allWeight_div = s64_allWeight / _const.s64_100
  local s64_maxWeight_div = s64_maxWeight / _const.s64_100
  local str_AllWeight = string.format("%.1f", Int64toInt32(s64_allWeight_div) / 100)
  local str_MaxWeight = string.format("%.0f", Int64toInt32(s64_maxWeight_div) / 100)
  if Int64toInt32(s64_allWeight) <= Int64toInt32(s64_maxWeight) then
    self._ui.progress_Money:SetProgressRate(Int64toInt32(s64_moneyWeight / s64_maxWeight_div))
    self._ui.progress_Weight:SetProgressRate(Int64toInt32(s64_allWeight / s64_maxWeight_div))
  else
    self._ui.progress_Money:SetProgressRate(Int64toInt32(s64_moneyWeight / s64_allWeight_div))
    self._ui.progress_Weight:SetProgressRate(Int64toInt32(s64_allWeight / s64_allWeight_div))
  end
  self._ui.txt_Weight:SetText(str_AllWeight .. " / " .. str_MaxWeight .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_WEIGHT"))
end
function MarketPlace_MyInven:updateInventory()
  Panel_Tooltip_Item_hideTooltip()
  local selfPlayerWrapper = getSelfPlayer()
  local selfPlayer = selfPlayerWrapper:get()
  local invenUseSize = selfPlayer:getInventorySlotCount(CppEnums.ItemWhereType.eInventory ~= self._currentInvenType)
  local useStartSlot = __eTInventorySlotNoUseStart
  local inventory = selfPlayer:getInventoryByType(self._currentInvenType)
  local invenMaxSize = inventory:sizeXXX()
  local freeCount = inventory:getFreeCount()
  local slotNoList = Array.new()
  slotNoList:fill(useStartSlot, invenMaxSize - 1)
  if true == self._ui.checkBtn_ItemSort:IsCheck() then
    local sortList = Array.new()
    sortList:fill(useStartSlot, invenUseSize - 1)
    sortList:quicksort(PaGlobalFunc_MarketPlace_MyInven_ItemComparer)
    for ii = 1, invenUseSize - 2 do
      slotNoList[ii] = sortList[ii]
    end
  end
  local invenCapacity = invenUseSize - useStartSlot
  self._ui.txt_Capacity:SetText(tostring(invenUseSize - freeCount - useStartSlot) .. "/" .. tostring(invenUseSize - useStartSlot))
  for slotIdx = 0, self._config.slotCount - 1 do
    local slot = self._slotInvenItemData[slotIdx]
    local slotBg = self._slotInvenBgData[slotIdx]
    local slotNo = slotNoList[slotIdx + 1 + self._startInvenSlotIndex]
    slot:clearItem()
    slot.slotNo = slotNo
    slot.icon:EraseAllEffect()
    slot.icon:addInputEvent("Mouse_On", "")
    slot.icon:addInputEvent("Mouse_Out", "")
    slot.icon:addInputEvent("Mouse_RUp", "")
    if invenCapacity > slotIdx + self._startInvenSlotIndex then
      local itemWrapper = getInventoryItemByType(self._currentInvenType, slotNo)
      if nil ~= itemWrapper then
        slot:setItem(itemWrapper, slotNo)
        slot.isEmpty = false
        local isFiltered = self:marketFilter(slotNo, itemWrapper, self._currentInvenType)
        slot.icon:SetMonoTone(isFiltered)
        slot.icon:SetIgnore(isFiltered)
        slot.icon:EraseAllEffect()
        if true == isFiltered then
          slot.icon:SetAlpha(0.5)
        else
          slot.icon:AddEffect("UI_Inventory_Filtering", true, 0, 0)
          if false == PaGlobal_TutorialPhase_IsTutorial() then
            slot.icon:addInputEvent("Mouse_RUp", "InputMRUp_MarketWallet_MoveInvenToWallet(" .. slotNo .. ")")
          end
          slot.icon:SetAlpha(1)
        end
        if false == PaGlobal_TutorialPhase_IsTutorial() then
          slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlace_MyInven_ShowToolTip(" .. self._currentInvenType .. "," .. slotNo .. "," .. slotIdx .. ")")
          slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
        end
        local isSoulCollector = itemWrapper:isSoulCollector()
        local isCurrentSoulCount = itemWrapper:getSoulCollectorCount()
        local isMaxSoulCount = itemWrapper:getSoulCollectorMaxCount()
        local itemIconPath = itemWrapper:getStaticStatus():getIconPath()
        if isSoulCollector then
          slot.icon:ChangeTextureInfoName("icon/" .. itemIconPath)
          if 0 == isCurrentSoulCount then
            slot.icon:ChangeTextureInfoName("icon/" .. itemIconPath)
          end
          if isCurrentSoulCount > 0 then
            slot.icon:ChangeTextureInfoName("New_UI_Common_forLua/ExceptionIcon/00040351_1.dds")
          end
          if isCurrentSoulCount == isMaxSoulCount then
            slot.icon:ChangeTextureInfoName("New_UI_Common_forLua/ExceptionIcon/00040351_2.dds")
          end
          local x1, y1, x2, y2 = setTextureUV_Func(slot.icon, 0, 0, 42, 42)
          slot.icon:getBaseTexture():setUV(x1, y1, x2, y2)
          slot.icon:setRenderTexture(slot.icon:getBaseTexture())
        end
      end
      slotBg.lock:SetShow(false)
    else
      slotBg.lock:SetShow(true)
    end
  end
  UIScroll.SetButtonSize(self._ui.scroll_CashInven, self._config.slotCount, invenMaxSize - useStartSlot)
end
function MarketPlace_MyInven:updateWareHouseInventory()
  local warehouseWrapper = warehouse_get(getCurrentWaypointKey())
  if nil == warehouseWrapper then
    return
  end
  local useStartSlot = 1
  local itemCount = warehouseWrapper:getSize()
  local useMaxCount = warehouseWrapper:getUseMaxCount()
  local freeCount = warehouseWrapper:getFreeCount()
  local money_s64 = warehouseWrapper:getMoney_s64()
  local maxCount = warehouseWrapper:getMaxCount()
  local invenCapacity = useMaxCount - useStartSlot
  self._ui.txt_Capacity:SetText(tostring(useMaxCount - freeCount - useStartSlot) .. "/" .. tostring(useMaxCount - useStartSlot))
  local slotNoList = Array.new()
  slotNoList:fill(useStartSlot, maxCount - 1)
  if true == self._ui.checkBtn_ItemSort:IsCheck() then
    local sortList = Array.new()
    sortList:fill(useStartSlot, useMaxCount - 1)
    sortList:quicksort(PaGlobalFunc_MarketPlace_MyInven_WarehouseComparer)
    for ii = 1, useMaxCount - 1 do
      slotNoList[ii] = sortList[ii]
    end
  end
  for slotIdx = 0, self._config.slotCount - 1 do
    local slot = self._slotInvenItemData[slotIdx]
    local slotBg = self._slotInvenBgData[slotIdx]
    local slotNo = slotNoList[slotIdx + 1 + self._startInvenSlotIndex]
    slot:clearItem()
    slot.slotNo = slotNo
    slot.icon:EraseAllEffect()
    slot.icon:addInputEvent("Mouse_On", "")
    slot.icon:addInputEvent("Mouse_Out", "")
    slot.icon:addInputEvent("Mouse_RUp", "")
    local itemExist = false
    local itemWrapper = warehouseWrapper:getItem(slotNo)
    if invenCapacity > slotIdx + self._startInvenSlotIndex then
      if nil ~= itemWrapper then
        slot:setItem(itemWrapper, slotNo, nil, warehouseWrapper)
        slot.isEmpty = false
        local isFiltered = self:marketFilter(slotNo, itemWrapper, self._currentInvenType)
        slot.icon:SetMonoTone(isFiltered)
        slot.icon:SetIgnore(isFiltered)
        slot.icon:EraseAllEffect()
        if true == isFiltered then
          slot.icon:SetAlpha(0.5)
        else
          slot.icon:AddEffect("UI_Inventory_Filtering", true, 0, 0)
          if false == PaGlobal_TutorialPhase_IsTutorial() then
            slot.icon:addInputEvent("Mouse_RUp", "InputMRUp_MarketWallet_MoveInvenToWallet(" .. slotNo .. ")")
          end
          slot.icon:SetAlpha(1)
        end
        if false == PaGlobal_TutorialPhase_IsTutorial() then
          slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlace_MyInven_ShowToolTip(" .. self._currentInvenType .. "," .. slotNo .. "," .. slotIdx .. ")")
          slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
        end
        local isSoulCollector = itemWrapper:isSoulCollector()
        local isCurrentSoulCount = itemWrapper:getSoulCollectorCount()
        local isMaxSoulCount = itemWrapper:getSoulCollectorMaxCount()
        local itemIconPath = itemWrapper:getStaticStatus():getIconPath()
        if isSoulCollector then
          slot.icon:ChangeTextureInfoName("icon/" .. itemIconPath)
          if 0 == isCurrentSoulCount then
            slot.icon:ChangeTextureInfoName("icon/" .. itemIconPath)
          end
          if isCurrentSoulCount > 0 then
            slot.icon:ChangeTextureInfoName("New_UI_Common_forLua/ExceptionIcon/00040351_1.dds")
          end
          if isCurrentSoulCount == isMaxSoulCount then
            slot.icon:ChangeTextureInfoName("New_UI_Common_forLua/ExceptionIcon/00040351_2.dds")
          end
          local x1, y1, x2, y2 = setTextureUV_Func(slot.icon, 0, 0, 42, 42)
          slot.icon:getBaseTexture():setUV(x1, y1, x2, y2)
          slot.icon:setRenderTexture(slot.icon:getBaseTexture())
        end
      end
      slotBg.lock:SetShow(false)
    else
      slotBg.lock:SetShow(true)
    end
  end
end
function MarketPlace_MyInven:marketFilter(slotNo, itemWrapper, invenWhereType)
  if nil == itemWrapper then
    return true
  end
  local isAble = requestIsRegisterItemForItemMarket(itemWrapper:get():getKey())
  local itemBindType = itemWrapper:getStaticStatus():get()._vestedType:getItemKey()
  local isVested = itemWrapper:get():isVested()
  local isPersonalTrade = itemWrapper:getStaticStatus():isPersonalTrade()
  if isUsePcExchangeInLocalizingValue() then
    local isFilter = isVested and isPersonalTrade
    if isFilter then
      return isFilter
    end
  end
  if true == isAble then
    if ToClient_Inventory_CheckItemLock(slotNo, invenWhereType) then
      isAble = false
    else
      isAble = true
    end
  end
  if 2 == itemBindType then
    if true ~= itemWrapper:get():isVested() and isAble then
      isAble = true
    else
      isAble = false
    end
  end
  if itemWrapper:isCash() then
    if false == isAble and false == self._isAblePearlProduct then
      isAble = false
    else
      isAble = isAble and self._isAblePearlProduct
    end
  end
  return not isAble
end
function PaGlobalFunc_MarketPlace_MyInven_ShowToolTip(whereType, slotNo, slotIdx)
  local self = MarketPlace_MyInven
  local slot = self._slotInvenItemData[slotIdx]
  local itemWrapper
  if whereType == CppEnums.ItemWhereType.eWarehouse then
    local warehouseWrapper = warehouse_get(getCurrentWaypointKey())
    if nil == warehouseWrapper then
      return
    end
    itemWrapper = warehouseWrapper:getItem(slotNo)
  else
    itemWrapper = getInventoryItemByType(whereType, slotNo)
  end
  if nil == slot then
    return
  end
  if nil == itemWrapper then
    return
  end
  Panel_Tooltip_Item_Show(itemWrapper, slot.icon, false, true, nil, nil, nil, slotNo)
end
function PaGlobalFunc_MarketPlace_MyInven_Open(isWaretype)
  local self = MarketPlace_MyInven
  self._ui.scroll_CashInven:SetControlPos(0)
  self._startInvenSlotIndex = 0
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = _panel:GetSizeX()
  local panelSizeY = _panel:GetSizeY()
  _panel:SetPosX(scrSizeX / 2 - panelSizeX / 2 - panelSizeX / 2)
  _panel:SetPosY(scrSizeY / 2 - panelSizeY / 2)
  local dialog
  if false == _ContentsGroup_NewUI_Dialog_All then
    dialog = Panel_Npc_Dialog
  else
    dialog = Panel_Npc_Dialog_All
  end
  if nil == dialog then
    return
  elseif true == dialog:GetShow() then
    local isGapY = scrSizeY - panelSizeY > dialog:GetSizeY()
    if true == isGapY then
      _panel:SetPosY(scrSizeY / 2 - panelSizeY / 2 - 140)
    end
  end
  local isSortChecked = ToClient_getGameUIManagerWrapper():getLuaCacheDataListBool(__eMarketPlaceInventorySort)
  self._ui.checkBtn_ItemSort:SetCheck(isSortChecked)
  self:open()
  if true == PaGlobalFunc_MarketPlace_IsOpenByMaid() then
    self._ui.btn_WareHouseInven:SetShow(false)
  else
    self._ui.btn_WareHouseInven:SetShow(true)
  end
  if CppEnums.ItemWhereType.eWarehouse == isWaretype then
    PaGlobalFunc_MarketPlace_SelectTab(CppEnums.ItemWhereType.eWarehouse)
    Warehouse_Close()
    PaGlobalFunc_MarketPlace_WalletInven_HideButton(true)
  else
    PaGlobalFunc_MarketPlace_SelectTab(CppEnums.ItemWhereType.eInventory)
    PaGlobalFunc_MarketPlace_WalletInven_HideButton(false)
  end
end
function PaGlobalFunc_MarketPlace_MyInven_Close()
  local self = MarketPlace_MyInven
  if true == Panel_Window_MarketPlace_TutorialSelect:GetShow() then
    PaGlobal_MarketPlaceTutorialSelect:prepareClose()
    return
  end
  if false == PaGlobalFunc_MarketPlace_MyInven_GetShow() then
    return
  end
  self:close()
  if false == PaGlobalFunc_MarketPlace_WalletInven_GetShow() then
    PaGlobalFunc_MarketWallet_Close()
  end
end
function MarketPlace_MyInven:open()
  _panel:SetShow(true)
end
function MarketPlace_MyInven:close()
  _panel:SetShow(false)
end
function PaGlobalFunc_MarketPlace_MyInven_GetShow()
  return _panel:GetShow()
end
function PaGlobal_MarketPlace_MyInven_GetPanel()
  return _panel
end

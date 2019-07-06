Panel_RemoteWarehouse:SetShow(false)
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local remoteWarehouse = {
  slotBg = UI.getChildControl(Panel_RemoteWarehouse, "Static_SlotBg"),
  btn_Prev = UI.getChildControl(Panel_RemoteWarehouse, "Button_Prev"),
  btn_Next = UI.getChildControl(Panel_RemoteWarehouse, "Button_Next"),
  pageValue = UI.getChildControl(Panel_RemoteWarehouse, "StaticText_PageValue"),
  capacity = UI.getChildControl(Panel_RemoteWarehouse, "StaticText_Capacity"),
  moneyValue = UI.getChildControl(Panel_RemoteWarehouse, "Static_Text_Money"),
  assetValue = UI.getChildControl(Panel_RemoteWarehouse, "StaticText_MarketValue"),
  maxSlotCount = 8,
  slotBgBasePosX = 20,
  slotBgBasePosY = 60,
  config = {
    createBorder = true,
    createIcon = true,
    createExpirationBG = true,
    createExpiration2h = true,
    createRemoteEnchant = true,
    createCash = true,
    createClassEquipBG = true
  },
  pageIndex = 0,
  itemSlot = {},
  isFilter = false
}
local tempSlot = {
  itemSlotBg = UI.getChildControl(remoteWarehouse.slotBg, "Static_SlotBG"),
  itemName = UI.getChildControl(remoteWarehouse.slotBg, "StaticText_ItemName"),
  itemCount = UI.getChildControl(remoteWarehouse.slotBg, "StaticText_Count"),
  leftTime = UI.getChildControl(remoteWarehouse.slotBg, "StaticText_LeftTime")
}
function remoteWarehouse:Init()
  for index = 0, self.maxSlotCount - 1 do
    local temp = {}
    temp.slotBg = UI.createControl(UCT.PA_UI_CONTROL_STATIC, Panel_RemoteWarehouse, "Static_SlotBg_" .. index)
    CopyBaseProperty(self.slotBg, temp.slotBg)
    temp.slotBg:SetPosX(self.slotBgBasePosX + (self.slotBg:GetSizeX() + 10) * (index % 2))
    temp.slotBg:SetPosY(self.slotBgBasePosY + (self.slotBg:GetSizeY() + 5) * math.floor(index / 2))
    temp.itemSlotBg = UI.createControl(UCT.PA_UI_CONTROL_STATIC, temp.slotBg, "Static_ItemSlotBg_" .. index)
    CopyBaseProperty(tempSlot.itemSlotBg, temp.itemSlotBg)
    temp.itemName = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, temp.slotBg, "StaticText_ItemName_" .. index)
    CopyBaseProperty(tempSlot.itemName, temp.itemName)
    temp.itemName:SetShow(false)
    temp.itemName:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
    temp.itemCount = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, temp.slotBg, "StaticText_ItemCount_" .. index)
    CopyBaseProperty(tempSlot.itemCount, temp.itemCount)
    temp.itemCount:SetShow(false)
    temp.leftTime = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, temp.slotBg, "StaticText_LeftTime_" .. index)
    CopyBaseProperty(tempSlot.leftTime, temp.leftTime)
    temp.leftTime:SetShow(false)
    local slot = {}
    SlotItem.new(slot, "RemoteWarehouseItemIcon_" .. index, index, temp.itemSlotBg, self.config)
    slot.icon:SetSize(temp.itemSlotBg:GetSizeX() - 2, temp.itemSlotBg:GetSizeY() - 2)
    slot.icon:SetPosX(1)
    slot.icon:SetPosY(1)
    slot:createChild()
    slot.border:SetSize(temp.itemSlotBg:GetSizeX(), temp.itemSlotBg:GetSizeY())
    slot.expiration2h:SetSize(temp.itemSlotBg:GetSizeX(), temp.itemSlotBg:GetSizeY())
    slot.expirationBG:SetSize(temp.itemSlotBg:GetSizeX(), temp.itemSlotBg:GetSizeY())
    slot.remoteEnchantText:SetSize(temp.itemSlotBg:GetSizeX() - 2, temp.itemSlotBg:GetSizeY() - 2)
    slot.isCash:SetSize(70, 70)
    slot.isCash:SetPosX(1)
    slot.isCash:SetPosY(1)
    self.itemSlot[index] = slot
    self.itemSlot[index].itemName = temp.itemName
    self.itemSlot[index].itemCount = temp.itemCount
    self.itemSlot[index].leftTime = temp.leftTime
    self.itemSlot[index].bg = temp.slotBg
  end
end
function remoteWarehouse:Update()
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
  if itemCount > useMaxCount - useStartSlot then
    self.capacity:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "Lua_WareHouse_OverCapacity", "HaveCount", tostring(itemCount), "FullCount", tostring(useMaxCount - useStartSlot)))
  else
    self.capacity:SetText(PAGetStringParam2(Defines.StringSheet_GAME, "Lua_WareHouse_Capacity", "HaveCount", tostring(itemCount), "FullCount", tostring(useMaxCount - useStartSlot)))
  end
  self.moneyValue:SetText(makeDotMoney(money_s64))
  local myAsset = toInt64(0, 0)
  if useMaxCount >= 2 then
    for index = 0, useMaxCount - 2 do
      local slotNo = index + useStartSlot
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
            myAsset = myAsset + marketPriceByWarehouse * itemCount_s64
          elseif 0 == itemEnchantLevel then
            myAsset = myAsset + npcSellPrice_s64 * itemCount_s64
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
              myAsset = myAsset + (tradeInfo:getDisplayedLowestOnePrice() + tradeInfo:getDisplayedHighestOnePrice()) / toInt64(0, 2) * itemCount_s64
            else
              myAsset = myAsset + (tradeMasterInfo:getMinPrice() + tradeMasterInfo:getMaxPrice()) / toInt64(0, 2) * itemCount_s64
            end
          else
            myAsset = myAsset + npcSellPrice_s64 * itemCount_s64
          end
        end
      end
    end
  end
  self.assetValue:SetText(makeDotMoney(myAsset + money_s64))
  for index = 0, self.maxSlotCount - 1 do
    local slotNo = index + self.pageIndex * self.maxSlotCount + useStartSlot
    local itemWrapper = warehouseWrapper:getItem(slotNo)
    if nil == itemWrapper then
      local slot = self.itemSlot[index]
      slot:clearItem()
      slot.itemName:SetShow(false)
      slot.itemCount:SetShow(false)
      slot.leftTime:SetShow(false)
      slot.bg:addInputEvent("Mouse_RUp", "")
    else
      local itemSSW = itemWrapper:getStaticStatus()
      local itemEnchantKey = itemSSW:get()._key:get()
      local itemCount_s64 = itemWrapper:get():getCount_s64()
      local npcSellPrice_s64 = itemSSW:get()._sellPriceToNpc_s64
      local slot = self.itemSlot[index]
      slot:setItem(itemWrapper, index)
      slot.itemName:SetShow(true)
      slot.itemName:SetText(itemSSW:getName())
      local nameColorGrade = itemSSW:getGradeType()
      if 0 == nameColorGrade then
        slot.itemName:SetFontColor(UI_color.C_FFFFFFFF)
      elseif 1 == nameColorGrade then
        slot.itemName:SetFontColor(4284350320)
      elseif 2 == nameColorGrade then
        slot.itemName:SetFontColor(4283144191)
      elseif 3 == nameColorGrade then
        slot.itemName:SetFontColor(4294953010)
      elseif 4 == nameColorGrade then
        slot.itemName:SetFontColor(4294929408)
      else
        slot.itemName:SetFontColor(UI_color.C_FFFFFFFF)
      end
      local itemCount = itemWrapper:get():getCount_s64()
      local itemStatic = itemSSW:get()
      if itemStatic and itemStatic._isStack then
        slot.itemCount:SetText(tostring(itemCount) .. "\234\176\156")
      else
        slot.itemCount:SetText("")
      end
      slot.itemCount:SetShow(true)
      local leftTime = ""
      slot.leftTime:SetShow(false)
      if itemSSW and not itemWrapper:getExpirationDate():isIndefinite() then
        local s64_remainingTime = getLeftSecond_s64(itemWrapper:getExpirationDate())
        local fontColor = UI_color.C_FFC4BEBE
        local itemExpiration = itemWrapper:getExpirationDate()
        local leftPeriod = FromClient_getTradeItemExpirationDate(itemExpiration, itemWrapper:getStaticStatus():get()._expirationPeriod)
        if not itemSSW:get():isCash() and itemSSW:isTradeAble() then
          leftTime = ""
        else
          leftTime = "\236\156\160\237\154\168 \234\184\176\234\176\132 : "
        end
        if Defines.s64_const.s64_0 == s64_remainingTime then
          if not itemSSW:get():isCash() and itemSSW:isTradeAble() then
            leftTime = leftTime .. PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_REMAIN_TIME") .. " (" .. PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_MARKETPRICE") .. " : " .. leftPeriod / 10000 .. " %)"
          else
            leftTime = leftTime .. PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_REMAIN_TIME")
          end
          fontColor = UI_color.C_FFF26A6A
        elseif not itemSSW:get():isCash() and itemSSW:isTradeAble() then
          leftTime = leftTime .. convertStringFromDatetime(s64_remainingTime) .. " (" .. PAGetString(Defines.StringSheet_GAME, "PANEL_TOOLTIP_MARKETPRICE") .. " : " .. leftPeriod / 10000 .. " %)"
        else
          leftTime = leftTime .. convertStringFromDatetime(s64_remainingTime)
        end
        slot.leftTime:SetText(leftTime)
        slot.leftTime:SetFontColor(fontColor)
        slot.leftTime:SetShow(true)
      end
      slot.bg:addInputEvent("Mouse_RUp", "RemoteWarehouse_MoveToInven(" .. index .. ")")
      slot.icon:addInputEvent("Mouse_RUp", "RemoteWarehouse_MoveToInven(" .. index .. ")")
      self.isFilter = false
      if Panel_RemoteManufacture:GetShow() then
        local actionIndex, actionName = FGlobal_RemoteManufactureActionIndex()
        local regionKey = getSelfPlayer():getRegionKey()
        if actionIndex > 0 then
          local isEnable = isManufactureItemInWareHouse(regionKey, slotNo, actionName)
          self.isFilter = not isEnable
          slot.bg:addInputEvent("Mouse_RUp", "RemoteWarehouse_SetManufacture(" .. index .. ")")
          slot.icon:addInputEvent("Mouse_RUp", "RemoteWarehouse_SetManufacture(" .. index .. ")")
        end
      end
      slot.bg:SetMonoTone(self.isFilter)
    end
  end
  self.pageValue:SetText(self.pageIndex + 1)
end
function RemoteWarehouse_MoveToInven(index)
  local self = remoteWarehouse
  local slotNo = index + self.pageIndex * self.maxSlotCount + 1
  local warehouseWrapper = warehouse_get(getCurrentWaypointKey())
  if nil == warehouseWrapper then
    return
  end
  local itemWrapper = warehouseWrapper:getItem(slotNo)
  if nil == itemWrapper then
    return
  end
  local function moveInvenFromRemoteWarehouse(inputNumber)
    warehouse_popToInventoryByNpc(slotNo, inputNumber, getSelfPlayer():getActorKey())
  end
  Panel_NumberPad_Show(true, itemWrapper:get():getCount_s64(), slotNo, moveInvenFromRemoteWarehouse)
end
function RemoteWarehouse_SetManufacture(index)
  local self = remoteWarehouse
  local slotNo = index + self.pageIndex * self.maxSlotCount + 1
  local warehouseWrapper = warehouse_get(getCurrentWaypointKey())
  if nil == warehouseWrapper then
    return
  end
  local itemWrapper = warehouseWrapper:getItem(slotNo)
  if nil == itemWrapper then
    return
  end
  FGlobal_RemoteManufacture_SetItem(slotNo)
end
function RemoteWarehouse_PageMove(isNext)
  local self = remoteWarehouse
  if isNext then
    local warehouseWrapper = warehouse_get(getCurrentWaypointKey())
    local useMaxCount = warehouseWrapper:getUseMaxCount()
    if (self.pageIndex + 1) * self.maxSlotCount < useMaxCount - 1 then
      self.pageIndex = self.pageIndex + 1
    else
      return
    end
  else
    self.pageIndex = math.max(self.pageIndex - 1, 0)
  end
  self:Update()
end
function remoteWarehouse:ShowToggle()
  if Panel_RemoteWarehouse:GetShow() then
    Panel_RemoteWarehouse:SetShow(false)
  else
    warehouse_requestInfo(getCurrentWaypointKey())
    Panel_RemoteWarehouse:SetShow(true)
    self:Update()
    Panel_RemoteWarehouse:SetPosX(getScreenSizeX() - Panel_RemoteInventory:GetSizeX() - Panel_RemoteWarehouse:GetSizeX() - 10)
  end
end
function FGlobal_Dialog_WarehouseOpen()
  remoteWarehouse:ShowToggle()
  FGlobal_RemoteInven_ShowToggle(true)
end
function FGlobal_RemoteWarehouse_Update()
  remoteWarehouse:Update()
end
function remoteWarehouse:registerEvnet()
  self.btn_Prev:addInputEvent("Mouse_LUp", "RemoteWarehouse_PageMove(false)")
  self.btn_Next:addInputEvent("Mouse_LUp", "RemoteWarehouse_PageMove(true)")
  registerEvent("EventWarehouseUpdate", "FGlobal_RemoteWarehouse_Update")
end
remoteWarehouse:Init()
remoteWarehouse:registerEvnet()

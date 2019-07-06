local UI_color = Defines.Color
PaGlobal_SearchMenuWarehouse = {
  _ui = {
    part_SearchMenuWarehouse = UI.getChildControl(Panel_Window_Warehouse, "Static_SelectWarehouse")
  },
  _warehouseInfo = {
    _territoryCount = 0,
    _territoryGroup = {}
  },
  _territoryNameInfo = {},
  _currentTerritoryKey = -1,
  _maxTerritoryKeyCount = 10,
  _separatorNumber = 100,
  _selectWaypointKey = -1
}
function PaGlobal_SearchMenuWarehouse:registMessageHandler()
  registerEvent("EventWarehouseUpdate", "PaGlobal_SearchMenuWarehouse_UpdateWarehouse")
end
function PaGlobal_SearchMenuWarehouse_UpdateWarehouse(waypointKey)
  local self = PaGlobal_SearchMenuWarehouse
  self._ui._list2:requestUpdateByKey(toInt64(0, waypointKey + self._separatorNumber))
end
function PaGlobal_SearchMenuWarehouse:Init()
  self._ui.btn_MyWarehouse = UI.getChildControl(self._ui.part_SearchMenuWarehouse, "RadioButton_Tab_MyWarehouse")
  self._ui.list_KeyWord = UI.getChildControl(self._ui.part_SearchMenuWarehouse, "List_KeyWord")
  self._ui._list2 = UI.getChildControl(self._ui.part_SearchMenuWarehouse, "List2_Warehouse")
  self._ui._list2:changeAnimationSpeed(10)
  self._ui._list2:setMinScrollBtnSize(float2(10, 50))
  self._ui._list2:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobal_SearchMenuWarehouse_UpdateList")
  self._ui._list2:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
  self._ui.list_KeyWord:SetShow(false)
  self._ui.btn_MyWarehouse:addInputEvent("Mouse_LUp", "PaGlobal_SearchMenuWarehouse:ClickCurrentTownsWareHouse()")
  self._selectIndex = -1
  self._ui.btn_MyWarehouse:SetCheck(true)
  self._ui.part_SearchMenuWarehouse:SetShow(false)
end
function PaGlobal_SearchMenuWarehouse_UpdateList(contents, key)
  local self = PaGlobal_SearchMenuWarehouse
  local idx = Int64toInt32(key)
  local radioButton = UI.getChildControl(contents, "RadioButton_Territory")
  local warehouseName = UI.getChildControl(contents, "RadioButton_WarehouseName")
  local count = UI.getChildControl(contents, "StaticText_Count")
  radioButton:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  warehouseName:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  radioButton:SetPosX(5)
  warehouseName:SetPosX(6)
  warehouseName:SetShow(false)
  count:SetShow(false)
  if idx < self._separatorNumber then
    local territoryName = self._territoryNameInfo[idx]
    local territoryWarehouseCount = self._warehouseInfo._territoryGroup[idx]._count
    radioButton:SetText(territoryName .. "(" .. territoryWarehouseCount .. ")")
    radioButton:addInputEvent("Mouse_LUp", "FGlobal_SearchMenuWarehouse_TerritoryOpen(" .. idx .. ")")
    radioButton:SetShow(true)
    warehouseName:SetShow(false)
    count:SetShow(false)
    radioButton:SetCheck(idx == self._selectIndex)
  else
    radioButton:SetShow(false)
    warehouseName:SetShow(true)
    local waypointKey = idx - self._separatorNumber
    if waypointKey == self._selectWaypointKey then
      warehouseName:SetFontColor(Defines.Color.C_FFACE400)
      warehouseName:SetCheck(true)
    else
      warehouseName:SetFontColor(Defines.Color.C_FFC4BEBE)
      warehouseName:SetCheck(false)
    end
    local regionInfoWrapper = ToClient_getRegionInfoWrapperByWaypoint(waypointKey)
    warehouseName:SetText(regionInfoWrapper:getAreaName())
    local warehouseWrapper = warehouse_get(waypointKey)
    if nil == warehouseWrapper then
      return
    end
    local itemCount = warehouseWrapper:getSize()
    local useMaxCount = warehouseWrapper:getUseMaxCount()
    count:SetText("(" .. itemCount .. "/" .. useMaxCount - 1 .. ")")
    count:SetShow(true)
    warehouseName:addInputEvent("Mouse_LUp", "PaGlobal_SearchMenuWarehouse:ClickOtherTownsWareHouse(" .. waypointKey .. ")")
  end
end
function FGlobal_SearchMenuWarehouse_TerritoryOpen(territoryKey, isFirstOpen)
  local self = PaGlobal_SearchMenuWarehouse
  self._ui._list2:getElementManager():clearKey()
  for index = 0, self._maxTerritoryKeyCount - 1 do
    if nil ~= self._warehouseInfo._territoryGroup[index] then
      self._ui._list2:getElementManager():pushKey(toInt64(0, index))
      if index == territoryKey then
        if self._selectIndex == territoryKey then
          self._selectIndex = -2
        else
          local maxTerritoryWarehouseCount = self._warehouseInfo._territoryGroup[index]._count
          for wIndex = 1, maxTerritoryWarehouseCount do
            warehouse_requestInfo(self._warehouseInfo._territoryGroup[index][wIndex])
            local waypointKey = self._warehouseInfo._territoryGroup[index][wIndex] + self._separatorNumber
            self._ui._list2:getElementManager():pushKey(toInt64(0, waypointKey))
          end
          self._selectIndex = territoryKey
        end
      end
    end
  end
  if isFirstOpen then
    local currentWaypointKey = getCurrentWaypointKey()
    self._selectWaypointKey = currentWaypointKey
    PaGlobal_SearchMenuWarehouse:ClickOtherTownsWareHouse(currentWaypointKey)
    return
  end
  if 0 <= self._selectIndex then
    self._selectWaypointKey = self._warehouseInfo._territoryGroup[self._selectIndex][1]
    PaGlobal_SearchMenuWarehouse:ClickOtherTownsWareHouse(self._selectWaypointKey)
  end
end
function PaGlobal_SearchMenuWarehouse:ClickOtherTownsWareHouse(waypointKey)
  local isCurrentTownsWarehouse = waypointKey == getCurrentWaypointKey()
  if isCurrentTownsWarehouse then
    Warehouse_OpenPanelFromDialog()
  else
    Warehouse_OpenPanelFromWorldmap(waypointKey, CppEnums.WarehoouseFromType.eWarehoouseFromType_Worldmap)
    Panel_Window_Inventory:SetShow(false)
  end
  PaGlobal_Warehouse_OtherWaypointKey(waypointKey)
  local beforeWaypointKey = self._selectWaypointKey
  self._selectWaypointKey = waypointKey
  if beforeWaypointKey > 0 then
    self._ui._list2:requestUpdateByKey(toInt64(0, beforeWaypointKey + self._separatorNumber))
  end
  self._ui._list2:requestUpdateByKey(toInt64(0, waypointKey + self._separatorNumber))
  self._ui.btn_MyWarehouse:SetCheck(false)
end
function PaGlobal_SearchMenuWarehouse:ClickCurrentTownsWareHouse()
  self._selectIndex = -1
  self._selectWaypointKey = -1
  Warehouse_OpenPanelFromDialog()
end
function PaGlobal_SearchMenuWarehouse:Open()
  if true == self._ui.part_SearchMenuWarehouse:GetShow() or not _ContentsGroup_isAllWarehouse then
    return
  end
  self._ui.part_SearchMenuWarehouse:SetShow(true)
  local warehouseCount = ToClient_FindWareHouse(getCurrentWaypointKey())
  if 0 == warehouseCount then
    return
  end
  local currentWaypointKey = getCurrentWaypointKey()
  local currnetRegionInfoWrapper = ToClient_getRegionInfoWrapperByWaypoint(currentWaypointKey)
  local currentTerritoryKey = currnetRegionInfoWrapper:getTerritoryKeyRaw()
  self._warehouseInfo._territoryCount = 0
  self._warehouseInfo._territoryGroup = {}
  for index = 0, warehouseCount - 1 do
    local waypointKey = ToClient_getWareHouseWaypointKey(index)
    local regionInfoWrapper = ToClient_getRegionInfoWrapperByWaypoint(waypointKey)
    local territoryKey = regionInfoWrapper:getTerritoryKeyRaw()
    if nil == self._warehouseInfo._territoryGroup[territoryKey] then
      self._warehouseInfo._territoryCount = self._warehouseInfo._territoryCount + 1
      self._warehouseInfo._territoryGroup[territoryKey] = {}
      self._warehouseInfo._territoryGroup[territoryKey]._count = 1
      self._warehouseInfo._territoryGroup[territoryKey][1] = waypointKey
      self._territoryNameInfo[territoryKey] = regionInfoWrapper:getTerritoryName()
    else
      self._warehouseInfo._territoryGroup[territoryKey]._count = self._warehouseInfo._territoryGroup[territoryKey]._count + 1
      self._warehouseInfo._territoryGroup[territoryKey][self._warehouseInfo._territoryGroup[territoryKey]._count] = waypointKey
    end
  end
  self._selectIndex = -1
  self._selectWaypointKey = -1
  self._ui._list2:getElementManager():clearKey()
  for index = 0, self._maxTerritoryKeyCount - 1 do
    if nil ~= self._warehouseInfo._territoryGroup[index] then
      self._ui._list2:getElementManager():pushKey(toInt64(0, index))
    end
  end
  FGlobal_SearchMenuWarehouse_TerritoryOpen(currentTerritoryKey, true)
  self._ui.part_SearchMenuWarehouse:ComputePos()
end
function PaGlobal_SearchMenuWarehouse:Close()
  if false == self._ui.part_SearchMenuWarehouse:GetShow() then
    return
  end
  self._ui.part_SearchMenuWarehouse:SetShow(false)
end
function FGlobal_WarehouseTownListCheck()
  if ToClient_WorldMapIsShow() then
    return
  end
  local self = PaGlobal_SearchMenuWarehouse
  if PaGlobalFunc_PanelDelivery_GetShow() or not _ContentsGroup_isAllWarehouse then
    self._ui.part_SearchMenuWarehouse:SetShow(false)
  else
    self._ui.part_SearchMenuWarehouse:SetShow(true)
  end
end
PaGlobal_SearchMenuWarehouse:Init()
PaGlobal_SearchMenuWarehouse:registMessageHandler()

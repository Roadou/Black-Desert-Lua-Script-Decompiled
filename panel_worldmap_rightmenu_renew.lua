local Window_WorldMap_RightMenuInfo = {
  _ui = {
    _button_BuyHouse = UI.getChildControl(Panel_Worldmap_RightMenu, "Button_BuyHouse"),
    _button_Stable = UI.getChildControl(Panel_Worldmap_RightMenu, "Button_Stable"),
    _button_WareHouse = UI.getChildControl(Panel_Worldmap_RightMenu, "Button_WareHouse"),
    _button_Delivery = UI.getChildControl(Panel_Worldmap_RightMenu, "Button_Delivery")
  },
  _currentNodeInfo = nil
}
function Window_WorldMap_RightMenuInfo:ButtonFilter()
  if nil == self._currentNodeInfo then
    return
  end
  local waypointKey = self._currentNodeInfo:getPlantKey():getWaypointKey()
  local regionInfoWrapper = ToClient_getRegionInfoWrapperByWaypoint(waypointKey)
  if nil == regionInfoWrapper then
    return
  end
  local receipeCount = ToClient_getTownReceipeList()
  self._ui._button_BuyHouse:SetShow(receipeCount > 0)
  local isStableOpen = regionInfoWrapper:get():hasStableNpc()
  local isWareHouseOpen = regionInfoWrapper:get():hasWareHouseNpc()
  self._ui._button_Stable:SetShow(isStableOpen)
  self._ui._button_WareHouse:SetShow(isWareHouseOpen)
  self._ui._button_Delivery:SetShow(isWareHouseOpen)
  if false == ToClient_IsContentsGroupOpen("2") then
    self._ui._button_Delivery:SetShow(false)
  end
end
function PaGlobalFunc_WorldMap_RightMenu_SetCurrentNodeInfo(nodeInfo)
  local self = Window_WorldMap_RightMenuInfo
  self._currentNodeInfo = nodeInfo
end
function Window_WorldMap_RightMenuInfo:InitControl()
end
function Window_WorldMap_RightMenuInfo:resize()
  Panel_Worldmap_RightMenu:ComputePos()
end
function PaGlobalFunc_WorldMap_RightMenu_OpenHouseFilter()
  local self = Window_WorldMap_RightMenuInfo
  _AudioPostEvent_SystemUiForXBOX(50, 0)
  PaGlobalFunc_WorldMap_HouseFilter_SetCurrentNodeInfo(self._currentNodeInfo)
  PaGlobalFunc_WorldMap_HouseFilter_Open()
end
function PaGlobalFunc_WorldMap_RightMenu_OpenHouseFilterFromCraftManage()
  local self = Window_WorldMap_RightMenuInfo
  PaGlobalFunc_WorldMap_HouseFilter_SetCurrentNodeInfo(self._currentNodeInfo)
  PaGlobalFunc_WorldMap_HouseFilter_OpenFromCraftManage()
end
function PaGlobalFunc_WorldMap_RightMenu_OpenStable()
  local self = Window_WorldMap_RightMenuInfo
  if false == PaGlobalFunc_WorldMap_Stable_GetShow() then
    if nil ~= self._currentNodeInfo then
      PaGlobalFunc_WorldMap_Stable_SetCurrentNodeInfo(self._currentNodeInfo)
      PaGlobalFunc_WorldMap_Stable_Open()
    else
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAP_GRAND_WRONG_STABLE"))
      return
    end
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
end
function PaGlobalFunc_WorldMap_RightMenu_OpenWareHouse()
  local self = Window_WorldMap_RightMenuInfo
  if Panel_Window_Warehouse:GetShow() then
    Warehouse_Close()
  elseif nil ~= self._currentNodeInfo then
    local waypointKey = self._currentNodeInfo:getPlantKey():getWaypointKey()
    Warehouse_OpenPanelFromWorldmap(waypointKey, CppEnums.WarehoouseFromType.eWarehoouseFromType_Worldmap)
    PaGlobalFunc_WorldMap_TopMenu_Close()
    PaGlobalFunc_WorldMap_RightMenu_Close()
    PaGlobalFunc_WorldMap_BottomMenu_Close()
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
end
function PaGlobalFunc_WorldMap_RightMenu_OpenDelivery()
  local self = Window_WorldMap_RightMenuInfo
  if Panel_Window_Warehouse:GetShow() then
    Warehouse_Close()
  elseif nil ~= self._currentNodeInfo then
    local waypointKey = self._currentNodeInfo:getPlantKey():getWaypointKey()
    Warehouse_OpenPanelFromWorldmap(waypointKey, CppEnums.WarehoouseFromType.eWarehoouseFromType_Worldmap)
    PaGlobalFunc_PanelDelivery_OpenFromWorldmap(waypointKey)
    PaGlobalFunc_WorldMap_TopMenu_Close()
    PaGlobalFunc_WorldMap_RightMenu_Close()
    PaGlobalFunc_WorldMap_BottomMenu_Close()
  end
  _AudioPostEvent_SystemUiForXBOX(50, 0)
end
function Window_WorldMap_RightMenuInfo:InitEvent()
  self._ui._button_BuyHouse:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorldMap_RightMenu_OpenHouseFilter()")
  self._ui._button_Stable:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorldMap_RightMenu_OpenStable()")
  self._ui._button_WareHouse:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorldMap_RightMenu_OpenWareHouse()")
  self._ui._button_Delivery:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorldMap_RightMenu_OpenDelivery()")
  registerEvent("onScreenResize", "PaGlobalFunc_WorldMap_RightMenu_Resize")
end
function Window_WorldMap_RightMenuInfo:InitRegister()
end
function Window_WorldMap_RightMenuInfo:Initialize()
  self:InitControl()
  self:InitEvent()
  self:InitRegister()
  self:resize()
end
function PaGlobalFunc_WorldMap_RightMenu_Toggle()
  local receipeCount = ToClient_getTownReceipeList()
  if 0 == receipeCount then
    return
  end
  if true == PaGlobalFunc_WorldMap_RightMenu_GetShow() then
    PaGlobalFunc_WorldMap_RingMenu_Open()
    PaGlobalFunc_WorldMap_BottomMenu_Open()
    PaGlobalFunc_WorldMap_RightMenu_Close()
  else
    PaGlobalFunc_WorldMap_RingMenu_Close()
    PaGlobalFunc_WorldMap_BottomMenu_Close()
    PaGlobalFunc_WorldMap_RightMenu_Open()
  end
end
function PaGlobalFunc_WorldMap_RightMenu_GetShow()
  return Panel_Worldmap_RightMenu:GetShow()
end
function PaGlobalFunc_WorldMap_RightMenu_SetShow(isShow, isAni)
  Panel_Worldmap_RightMenu:SetShow(isShow, isAni)
end
function PaGlobalFunc_WorldMap_RightMenu_Open()
  local self = Window_WorldMap_RightMenuInfo
  if true == PaGlobalFunc_WorldMap_RightMenu_GetShow() then
    return
  end
  self:ButtonFilter()
  PaGlobalFunc_WorldMap_RightMenu_SetShow(true, false)
end
function PaGlobalFunc_WorldMap_RightMenu_Close()
  if false == PaGlobalFunc_WorldMap_RightMenu_GetShow() then
    return
  end
  PaGlobalFunc_WorldMap_RightMenu_SetShow(false, false)
end
function PaGlobalFunc_FromClient_WorldMap_RightMenu_luaLoadComplete()
  local self = Window_WorldMap_RightMenuInfo
  self:Initialize()
end
function PaGlobalFunc_WorldMap_RightMenu_Resize()
  local self = Window_WorldMap_RightMenuInfo
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_FromClient_WorldMap_RightMenu_luaLoadComplete")

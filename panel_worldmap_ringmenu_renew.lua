local Window_WorldMap_RingMenuInfo = {
  _ui = {
    _static_BlackBg = UI.getChildControl(Panel_Worldmap_RingMenu, "Static_BlackBg"),
    _static_RingMenuBg = UI.getChildControl(Panel_Worldmap_RingMenu, "Static_RingMenuBg"),
    _static_Aim = UI.getChildControl(Panel_Worldmap_RingMenu, "Static_Aim"),
    _static_FocusKeyGuide = UI.getChildControl(Panel_Worldmap_RingMenu, "Static_A_ConsoleUI"),
    _ringMenu = {}
  },
  _config = {
    _enter = 0,
    _craftManage = 1,
    _showInfo = 2,
    _vehiclePos = 3,
    _waypoint = 4,
    _take = 5,
    _invest = 6,
    _makeAndServent = 7,
    _count = 8,
    _centerX,
    _centerY
  },
  _strConfig = {
    [0] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORLDMAP_RINGMENU_RENEW_ENTER"),
    [1] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_HOUSECONTROL_MAIN_BTN_LARGECRAFT"),
    [2] = PAGetString(Defines.StringSheet_RESOURCE, "INTERACTION_BTN_CHARINFO"),
    [3] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORLDMAP_RINGMENU_RENEW_VehiclePosition"),
    [4] = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WORLDMAP_RINGMENU_RENEW_WayPoint"),
    [5] = PAGetString(Defines.StringSheet_RESOURCE, "WORLDMAP_NODE_BTN_WITHDRAW"),
    [6] = PAGetString(Defines.StringSheet_RESOURCE, "TRADEMARKET_SELLLIST_NODECHECK"),
    [7] = PAGetString(Defines.StringSheet_RESOURCE, "WORLDMAP_NODE_BTN_MANAGING")
  },
  _uiTypeConfig = {
    _node = 0,
    _quest = 1,
    _count = 2
  },
  _UVConfig = {
    [0] = {
      x1 = 1,
      y1 = 1,
      x2 = 45,
      y2 = 45
    },
    [1] = {
      x1 = 136,
      y1 = 1,
      x2 = 180,
      y2 = 45
    }
  },
  _isRingMenuOpen = false,
  _currentWorldNode = nil,
  _currentRingMenuIndex = __eRingMenuPosition_Default,
  _isTakeAble = false,
  _houseCount = 0,
  _prevRightStickValue = {_x = 0, _y = 0},
  _currentHousekey = nil,
  _currentQuestKey = nil,
  _currentFocusedNodeCount = 0,
  _focusedBookMarkIndex = -1
}
function PaGlobalFunc_WorldMap_GetFocusedBookMarkIndex()
  local self = Window_WorldMap_RingMenuInfo
  return self._focusedBookMarkIndex
end
function PaGlobalFunc_WorldMap_ClearFocusedBookMarkIndex()
  local self = Window_WorldMap_RingMenuInfo
  self._focusedBookMarkIndex = -1
  PaGlobal_ConsoleWorldMapKeyGuide_CheckShow()
end
function Window_WorldMap_RingMenuInfo:ClickableCheck()
  if true == PaGlobalFunc_WorldMap_NodeInfo_GetShow() then
    return false
  end
  return true
end
function Window_WorldMap_RingMenuInfo:RingMenuClear()
  self._ui._static_BlackBg:SetShow(false)
  self._ui._static_RingMenuBg:SetShow(false)
  self._ui._static_FocusKeyGuide:SetShow(false)
  self:FocusOut()
  self._isRingMenuOpen = false
  self._currentRingMenuIndex = __eRingMenuPosition_Default
  PaGlobalFunc_WorldMap_RingMenu_SetShowRingMenu(false)
  PaGlobalFunc_WorldMap_ClearFocusedBookMarkIndex()
  for index = 0, self._config._count - 1 do
    if nil ~= self._ui._ringMenu[index] then
      self._ui._ringMenu[index]._button:SetCheck(false)
    end
  end
end
function Window_WorldMap_RingMenuInfo:FocusOn(uiType)
  if uiType >= self._uiTypeConfig._count then
    return
  end
  self._ui._static_Aim:ResetVertexAni()
  self._ui._static_Aim:ResetVertexAni()
  self._ui._static_AimColor:ResetVertexAni()
  self._ui._static_Aim:SetVertexAniRun("Ani_Scale_Set", true)
  self._ui._static_Aim:SetVertexAniRun("Ani_Move_Pos_Set", true)
  self._ui._static_AimColor:SetVertexAniRun("Ani_Color_Set", true)
  self._ui._static_FocusKeyGuide:ChangeTextureInfoName("renewal/ui_icon/console_xboxkey_00.dds")
  local x1, y1, x2, y2 = setTextureUV_Func(self._ui._static_FocusKeyGuide, self._UVConfig[uiType].x1, self._UVConfig[uiType].y1, self._UVConfig[uiType].x2, self._UVConfig[uiType].y2)
  self._ui._static_FocusKeyGuide:getBaseTexture():setUV(x1, y1, x2, y2)
  self._ui._static_FocusKeyGuide:setRenderTexture(self._ui._static_FocusKeyGuide:getBaseTexture())
  self._ui._static_FocusKeyGuide:SetShow(true)
  if self._uiTypeConfig._quest == uiType then
    self._ui._static_FocusKeyGuide:SetShow(false)
  end
end
function Window_WorldMap_RingMenuInfo:FocusOut()
  self._ui._static_FocusKeyGuide:SetShow(false)
  self._ui._static_Aim:ResetVertexAni()
  self._ui._static_Aim:ResetVertexAni()
  self._ui._static_AimColor:ResetVertexAni()
  self._ui._static_Aim:SetVertexAniRun("Ani_Scale_Reset", true)
  self._ui._static_Aim:SetVertexAniRun("Ani_Move_Pos_Reset", true)
  self._ui._static_AimColor:SetVertexAniRun("Ani_Color_Reset", true)
end
function Window_WorldMap_RingMenuInfo:ShowNodeInfo()
  local nodeInfo = self._currentWorldNode:FromClient_getExplorationNodeInClient()
  PaGlobalFunc_WorldMap_NodeInfo_Open(nodeInfo)
end
function Window_WorldMap_RingMenuInfo:WorkerManage()
  local nodeInfo = self._currentWorldNode:FromClient_getExplorationNodeInClient()
  PaGlobalFunc_WorldMap_NodeProduct_Open(nodeInfo)
end
function Window_WorldMap_RingMenuInfo:ShowInvest()
  local nodeInfo = self._currentWorldNode:FromClient_getExplorationNodeInClient()
  PaGlobalFunc_WorldMap_NodeManagement_Open(nodeInfo)
end
function Window_WorldMap_RingMenuInfo:TakeAll()
  local nodeInfo = self._currentWorldNode:FromClient_getExplorationNodeInClient()
  if false == self._isTakeAble then
    return
  end
  PaGlobalFunc_WorldMap_NodeManagement_TakeAll(nodeInfo)
end
function Window_WorldMap_RingMenuInfo:SetWayPoint()
  local nodeInfo = self._currentWorldNode:FromClient_getExplorationNodeInClient()
  if nil == nodeInfo then
    return
  end
  local nodeStaticStatus = nodeInfo:getStaticStatus()
  local position = ToClient_getNodeManagerPosition(nodeStaticStatus)
  if 0 == position.x and 0 == position.y and 0 == position.z then
    position = nodeStaticStatus:getPosition()
  end
  FromClient_RClickWorldmapPanel(position, true, false)
end
function PaGlobalFunc_WorldMap_RingMenu_RingMenuSelect(index)
  local self = Window_WorldMap_RingMenuInfo
  local state = self._config
  self:RingMenuClear()
  if state._enter == index then
    local nodeInfo = self._currentWorldNode:FromClient_getExplorationNodeInClient()
    local plantKey = nodeInfo:getPlantKey()
    PaGlobalFunc_WorldMap_TopMenu_SetCurrentNodeInfo(nodeInfo)
    PaGlobalFunc_WorldMap_RightMenu_SetCurrentNodeInfo(nodeInfo)
    ToClient_setTownMode(plantKey)
  elseif state._craftManage == index then
    local nodeInfo = self._currentWorldNode:FromClient_getExplorationNodeInClient()
    local plantKey = nodeInfo:getPlantKey()
    PaGlobalFunc_WorldMap_TopMenu_SetCurrentNodeInfo(nodeInfo)
    PaGlobalFunc_WorldMap_RightMenu_SetCurrentNodeInfo(nodeInfo)
    ToClient_setTownMode(plantKey)
    if 0 == ToClient_getTownReceipeList() then
      return
    end
    PaGlobalFunc_WorldMap_RightMenu_OpenHouseFilterFromCraftManage()
  elseif state._showInfo == index then
    self:ShowNodeInfo()
  elseif state._vehiclePos == index then
    Servant_Navi(0)
  elseif state._waypoint == index then
    self:SetWayPoint()
  elseif state._take == index then
    self:TakeAll()
  elseif state._invest == index then
    self:ShowInvest()
  elseif state._makeAndServent == index then
    self:WorkerManage()
  end
end
function PaGlobalFunc_WorldMap_RingMenu_SetShowRingMenu(isShow)
  local self = Window_WorldMap_RingMenuInfo
  self._ui._static_BlackBg:SetShow(isShow)
  self._ui._static_RingMenuBg:SetShow(isShow)
  ToClient_SetIsIgnoreLStick(isShow)
  if true == isShow then
    PaGlobal_ConsoleWorldMapKeyGuide_SetShow(false)
    PaGlobalFunc_WorldMap_TopMenu_Close()
    PaGlobalFunc_WorldMap_BottomMenu_Close()
  else
    PaGlobalFunc_WorldMap_TopMenu_Open()
    PaGlobalFunc_WorldMap_BottomMenu_Open()
    PaGlobal_ConsoleWorldMapKeyGuide_SetShow(true)
  end
  self._isRingMenuOpen = isShow
end
function PaGlobalFunc_FromClient_WorldMap_RingMenu_LClickedWorldMapNode(explorationNode)
  local self = Window_WorldMap_RingMenuInfo
  if false == self:ClickableCheck() then
    return
  end
  self._currentWorldNode = explorationNode
  self._ui._static_FocusKeyGuide:SetShow(false)
  self._ui._staticText_Tooltip:SetShow(false)
  PaGlobalFunc_WorldMap_RingMenu_SetShowRingMenu(true)
  local nodeInfo = self._currentWorldNode:FromClient_getExplorationNodeInClient()
  local isTown = nodeInfo:getStaticStatus():getRegion():isMainOrMinorTown()
  local isInvest = nodeInfo:isMaxLevel()
  self._isTakeAble = not isTown and isInvest
  self._ui._ringMenu[self._config._take]._button:SetMonoTone(not self._isTakeAble)
  if true == self._isTakeAble then
    self._ui._ringMenu[self._config._take]._icon:SetColor(Defines.Color.C_FFFFFFFF)
  else
    self._ui._ringMenu[self._config._take]._icon:SetColor(Defines.Color.C_FF444444)
  end
  self._houseCount = ToClient_getHouseCountByPlantKey(nodeInfo:getPlantKey())
  self._ui._ringMenu[self._config._craftManage]._button:SetMonoTone(0 == self._houseCount)
  if 0 == self._houseCount then
    self._ui._ringMenu[self._config._craftManage]._icon:SetColor(Defines.Color.C_FF444444)
  else
    self._ui._ringMenu[self._config._craftManage]._icon:SetColor(Defines.Color.C_FFFFFFFF)
  end
end
function PaGlobalFunc_FromClient_WorldMap_RingMenu_RClickedWorldMapNode(nodeBtn)
  local node = nodeBtn:FromClient_getExplorationNodeInClient()
  if nil == node then
    return
  end
  local nodeStaticStatus = node:getStaticStatus()
  local position = ToClient_getNodeManagerPosition(nodeStaticStatus)
  if 0 == position.x and 0 == position.y and 0 == position.z then
    position = nodeStaticStatus:getPosition()
  end
  FromClient_RClickWorldmapPanel(position, true, false)
end
function PaGlobalFunc_FromClient_WorldMap_RingMenu_OnWorldMapHouse(nodeBtn)
  local self = Window_WorldMap_RingMenuInfo
  self._currentHousekey = nodeBtn:FromClient_getStaticStatus():getHouseKey()
  self:FocusOn(0)
end
function PaGlobalFunc_FromClient_WorldMap_RingMenu_OutWorldMapHouse(nodeBtn)
  local self = Window_WorldMap_RingMenuInfo
  if nil == self._currentHousekey then
    self:FocusOut()
  end
  if nodeBtn:FromClient_getStaticStatus():getHouseKey() == self._currentHousekey then
    self:FocusOut()
    self._currentHousekey = nil
  end
end
function PaGlobalFunc_FromClient_WorldMap_RingMenu_OnWorldMapQuestInfo(uiQuest)
  local self = Window_WorldMap_RingMenuInfo
  self._currentQuestKey = uiQuest:ToClient_GetQuestStaticStatusWrapper():getKey()
  self:FocusOn(1)
end
function PaGlobalFunc_FromClient_WorldMap_RingMenu_OutWorldMapQuestInfo()
  local self = Window_WorldMap_RingMenuInfo
  self._currentQuestKey = nil
  if 0 == self._currentFocusedNodeCount then
    self:FocusOut()
  end
end
function FromClient_MouseOnWorldmapBookMark(index)
  local self = Window_WorldMap_RingMenuInfo
  self._focusedBookMarkIndex = index
  PaGlobal_ConsoleWorldMapKeyGuide_CheckShow()
end
function FromClient_MouseOutWorldmapBookMark(index)
  local self = Window_WorldMap_RingMenuInfo
  if self._focusedBookMarkIndex ~= index then
    return
  end
  self._focusedBookMarkIndex = -1
  PaGlobal_ConsoleWorldMapKeyGuide_CheckShow()
end
function PaGlobalFunc_FromClient_WorldMap_RingMenu_LClickedWorldMapHouse(nodeBtn)
  if nil == nodeBtn then
    return
  end
  PaGlobalFunc_WorldMapHouseManager_Open(nodeBtn, false)
  FGlobal_ClearWorldmapIconTooltip()
  PaGlobalFunc_WorldMap_RingMenu_Close()
  PaGlobalFunc_WorldMap_TopMenu_Close()
  PaGlobalFunc_WorldMap_BottomMenu_Close()
end
function PaGlobalFunc_FromClient_WorldMap_RingMenu_RClickedWorldMapHouse(houseBtn)
  local houseInfo = houseBtn:FromClient_getStaticStatus()
  if nil == houseInfo then
    return
  end
  FromClient_RClickWorldmapPanel(houseInfo:getPosition(), false, true)
end
function PaGlobalFunc_FromClient_WorldMap_RingMenu_FocusUpdate(size, type)
  local self = Window_WorldMap_RingMenuInfo
  self._currentFocusedNodeCount = Int64toInt32(size)
  if 0 == Int64toInt32(size) then
    if nil == self._currentQuestKey then
      self:FocusOut()
    end
  else
    self:FocusOn(Int64toInt32(type))
  end
end
function PaGlobalFunc_WorldMap_RingMenu_SetPadEvent(type, func)
  Panel_Worldmap_RingMenu:registerPadEvent(type, func)
end
function Window_WorldMap_RingMenuInfo:ConditionCheck(position)
  if false == self._isTakeAble and self._config._take == position then
    return false
  end
  if 0 == self._houseCount and self._config._craftManage == position then
    return false
  end
  return true
end
function Window_WorldMap_RingMenuInfo:UpdateRingMenu(position)
  if false == self:ConditionCheck(position) then
    return
  end
  if self._currentRingMenuIndex ~= position then
    _AudioPostEvent_SystemUiForXBOX(51, 6)
  end
  if position == __eRingMenuPosition_Default then
    if __eRingMenuPosition_Default ~= self._currentRingMenuIndex then
      _AudioPostEvent_SystemUiForXBOX(50, 1)
      PaGlobalFunc_WorldMap_RingMenu_RingMenuSelect(self._currentRingMenuIndex)
    end
  else
    for index = 0, self._config._count - 1 do
      if nil ~= self._ui._ringMenu[index] then
        self._ui._ringMenu[index]._button:SetCheck(index == position)
      end
    end
    self._ui._staticText_Tooltip:SetShow(true)
    self._ui._staticText_Tooltip:SetText(self._strConfig[position])
  end
  local RSX = getPadRightStickMoveX()
  local RSY = getPadRightStickMoveY()
  if math.abs(RSX) < math.abs(self._prevRightStickValue._x) and math.abs(RSY) < math.abs(self._prevRightStickValue._y) then
    return
  end
  self._prevRightStickValue._x = RSX
  self._prevRightStickValue._y = RSY
  if self._currentRingMenuIndex ~= __eRingMenuPosition_Default and math.abs(self._currentRingMenuIndex - position) >= 3 and 6 >= math.abs(self._currentRingMenuIndex - position) then
    return
  end
  self._currentRingMenuIndex = position
end
function Window_WorldMap_RingMenuInfo:InitControl()
  for index = 0, self._config._count - 1 do
    self._ui._ringMenu[index] = {}
    self._ui._ringMenu[index]._button = UI.getChildControl(self._ui._static_RingMenuBg, "Radiobutton_" .. index)
    self._ui._ringMenu[index]._icon = UI.getChildControl(self._ui._ringMenu[index]._button, "Static_Icon")
  end
  self._ui._staticText_Tooltip = UI.getChildControl(self._ui._static_RingMenuBg, "StaticText_Tooltip")
  PaGlobalFunc_FromClient_WorldMap_RingMenu_ScreenResize()
  self._ui._static_AimColor = UI.getChildControl(self._ui._static_Aim, "Static_Focus")
  self._ui._static_AimColor:SetIgnore(true)
  self._ui._static_BlackBg:SetShow(false)
  self._ui._static_RingMenuBg:SetShow(false)
  self._ui._static_FocusKeyGuide:SetShow(false)
end
function Window_WorldMap_RingMenuInfo:InitEvent()
  Panel_Worldmap_RingMenu:RegisterUpdateFunc("PaGlobalFunc_WorldMap_RingMenu_UpdatePerFrame")
end
function Window_WorldMap_RingMenuInfo:InitRegister()
  registerEvent("FromClient_LClickedWorldMapNode", "PaGlobalFunc_FromClient_WorldMap_RingMenu_LClickedWorldMapNode")
  registerEvent("FromClient_RClickedWorldMapNode", "PaGlobalFunc_FromClient_WorldMap_RingMenu_RClickedWorldMapNode")
  registerEvent("FromClient_getCurrentFocusedUiCount", "PaGlobalFunc_FromClient_WorldMap_RingMenu_FocusUpdate")
  registerEvent("FromClient_OnWorldMapHouse", "PaGlobalFunc_FromClient_WorldMap_RingMenu_OnWorldMapHouse")
  registerEvent("FromClient_OutWorldMapHouse", "PaGlobalFunc_FromClient_WorldMap_RingMenu_OutWorldMapHouse")
  registerEvent("FromClient_LClickedWorldMapHouse", "PaGlobalFunc_FromClient_WorldMap_RingMenu_LClickedWorldMapHouse")
  registerEvent("FromClient_RClickedWorldMapHouse", "PaGlobalFunc_FromClient_WorldMap_RingMenu_RClickedWorldMapHouse")
  registerEvent("onScreenResize", "PaGlobalFunc_FromClient_WorldMap_RingMenu_ScreenResize")
  registerEvent("FromClient_OnWorldMapQuestInfo", "PaGlobalFunc_FromClient_WorldMap_RingMenu_OnWorldMapQuestInfo")
  registerEvent("FromClient_OutWorldMapQuestInfo", "PaGlobalFunc_FromClient_WorldMap_RingMenu_OutWorldMapQuestInfo")
  registerEvent("FromClient_MouseOnWorldmapBookMark", "FromClient_MouseOnWorldmapBookMark")
  registerEvent("FromClient_MouseOutWorldmapBookMark", "FromClient_MouseOutWorldmapBookMark")
  registerEvent("FromClient_TerritoryTooltipHide", "FromClient_WorldMap_RingMenu_TerritoryTooltipShow")
  registerEvent("FromClient_TerritoryTooltipShow", "FromClient_WorldMap_RingMenu_TerritoryTooltipHide")
end
function FromClient_WorldMap_RingMenu_TerritoryTooltipShow(territoryUI, territoryInfo, territoryKeyRaw)
  _PA_LOG("\236\157\180\237\152\184\236\132\156", "FromClient_WorldMap_RingMenu_TerritoryTooltipShow")
end
function FromClient_WorldMap_RingMenu_TerritoryTooltipHide()
  _PA_LOG("\236\157\180\237\152\184\236\132\156", "FromClient_WorldMap_RingMenu_TerritoryTooltipHide")
end
function Window_WorldMap_RingMenuInfo:Initialize()
  self:InitControl()
  self:InitEvent()
  self:InitRegister()
end
function PaGlobalFunc_WorldMap_RingMenu_UpdatePerFrame(deltaTime)
  local self = Window_WorldMap_RingMenuInfo
  if PaGlobalFunc_WorldMap_GetIsFadeOut() then
    return
  end
  if true == self._isRingMenuOpen then
    local pos = ToClient_getPressedRStickPosition()
    self:UpdateRingMenu(pos)
  end
  if true == PaGlobalFunc_WorldMap_RingMenu_GetIsRingMenuOpen() then
    ToClient_setMousePosition(0, 0)
  else
    PaGlobalFunc_FromClient_WorldMap_RingMenu_ScreenResize()
    ToClient_setMousePosition(self._config._centerX, self._config._centerY)
  end
end
function PaGlobalFunc_WorldMap_RingMenu_GetIsRingMenuOpen()
  local self = Window_WorldMap_RingMenuInfo
  return self._isRingMenuOpen
end
function PaGlobalFunc_WorldMap_RingMenu_GetShow()
  return Panel_Worldmap_RingMenu:GetShow()
end
function PaGlobalFunc_WorldMap_RingMenu_SetShow(isShow, isAni)
  Panel_Worldmap_RingMenu:SetShow(isShow, isAni)
end
function PaGlobalFunc_WorldMap_RingMenu_Open()
  local self = Window_WorldMap_RingMenuInfo
  if true == PaGlobalFunc_WorldMap_RingMenu_GetShow() then
    return
  end
  self:RingMenuClear()
  PaGlobal_ConsoleWorldMapKeyGuide_SetShow(true)
  PaGlobalFunc_WorldMap_RingMenu_SetShow(true, false)
end
function PaGlobalFunc_WorldMap_RingMenu_Close()
  local self = Window_WorldMap_RingMenuInfo
  if false == PaGlobalFunc_WorldMap_RingMenu_GetShow() then
    return
  end
  self:RingMenuClear()
  PaGlobal_ConsoleWorldMapKeyGuide_SetShow(false)
  ToClient_SetIsIgnoreLStick(true)
  PaGlobalFunc_WorldMap_RingMenu_SetShow(false, false)
end
function PaGlobalFunc_FromClient_WorldMap_RingMenu_ScreenResize()
  local self = Window_WorldMap_RingMenuInfo
  self._config._centerX = getOriginScreenSizeX() / 2 * ToClient_getGameOptionControllerWrapper():getUIScale()
  self._config._centerY = getOriginScreenSizeY() / 2 * ToClient_getGameOptionControllerWrapper():getUIScale()
  Panel_Worldmap_RingMenu:SetPosX(getScreenSizeX() / 2 - Panel_Worldmap_RingMenu:GetSizeX() / 2)
  Panel_Worldmap_RingMenu:SetPosY(getScreenSizeY() / 2 - Panel_Worldmap_RingMenu:GetSizeY() / 2)
end
function PaGlobalFunc_FromClient_WorldMap_RingMenu_luaLoadComplete()
  local self = Window_WorldMap_RingMenuInfo
  self:Initialize()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_FromClient_WorldMap_RingMenu_luaLoadComplete")

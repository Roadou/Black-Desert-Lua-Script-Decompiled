Panel_Worldmap_SellBuyCondition:ignorePadSnapMoveToOtherPanel()
local Window_WorldMap_SellBuyHouseInfo = {
  _ui = {
    _static_Bg = UI.getChildControl(Panel_Worldmap_SellBuyCondition, "Static_BG_Purchase"),
    _staticText_subInfoDesc = UI.getChildControl(Panel_Worldmap_SellBuyCondition, "StaticText_Info2")
  },
  _targetHouseKey,
  _targetUseType,
  _isSell,
  _isBuy,
  _houseList = {},
  _houseCostList = {},
  _haveValue,
  _needValue,
  _titleStr,
  _titleDescStr,
  _costTitleStr,
  _costStr,
  _listTitleStr,
  _buttonStr,
  _buttonSignStr,
  _totalButtonStr,
  _subInfoDesc,
  _totalValue = 0,
  _isAllBuy = false,
  _isAllSell = false,
  _isMonotone = false,
  _houseCount = 0,
  _currentOnButtonIndex = 0
}
function clear_HouseSelectedAni_bySellBuy()
end
function Window_WorldMap_SellBuyHouseInfo:SetData()
  self._houselist = {}
  self._totalValue = 0
  if true == self._isSell and false == ToClient_IsMyHouse(self._targetHouseKey) then
    PaGlobalFunc_WorldMap_SellBuyHouse_Close()
    return
  end
  if true == self._isBuy and true == ToClient_IsMyHouse(self._targetHouseKey) then
    PaGlobalFunc_WorldMap_SellBuyHouse_Close()
    return
  end
  local houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper(self._targetHouseKey)
  self._houseCount = 0
  if true == self._isSell then
    self:SetListForSell()
  else
    self:SetListForBuy()
  end
end
function Window_WorldMap_SellBuyHouseInfo:SetListForSell()
  ToClient_SetNextHouseList(self._targetHouseKey)
end
function Window_WorldMap_SellBuyHouseInfo:SetListForBuy()
  ToClient_SetPrevHouseList(self._targetHouseKey)
end
function Window_WorldMap_SellBuyHouseInfo:SetInfo()
  local targetInfo = self._houselist[self._houseCount - 1]
  if nil == targetInfo then
    PaGlobalFunc_WorldMap_SellBuyHouse_Close()
    return
  end
  self._ui._staticText_Title:SetText(self._titleStr .. ": " .. self._houselist[self._houseCount - 1]._name)
  self._ui._staticText_TitleDesc:SetText("[" .. self._houselist[self._houseCount - 1]._name .. "] " .. self._titleDescStr)
  self._ui._staticText_costTitle:SetText(self._costTitleStr)
  self._ui._staticText_needTitle:SetText(self._costStr)
  self._ui._staticText_needValue:SetText(self._totalValue)
  local territoryKeyRaw = ToClient_getDefaultTerritoryKey()
  local explorePoint = ToClient_getExplorePointByTerritoryRaw(territoryKeyRaw)
  self._ui._staticText_haveValue:SetText(explorePoint:getRemainedPoint())
  self._ui._staticText_listTitle:SetText(self._listTitleStr .. "(" .. #self._houselist + 1 .. ")")
  self._ui._radiobutton_All:SetText(self._totalButtonStr .. "(" .. self._buttonSignStr .. self._totalValue .. ")")
  self._ui._staticText_subInfoDesc:SetText(self._subInfoDesc)
  self:AllButtonCondition()
end
function Window_WorldMap_SellBuyHouseInfo:AllButtonCondition()
  local territoryKeyRaw = ToClient_getDefaultTerritoryKey()
  local explorePoint = ToClient_getExplorePointByTerritoryRaw(territoryKeyRaw)
  self._ui._radiobutton_All:addInputEvent("Mouse_On", "PaGlobalFunc_WorldMap_SellBuyHouse_Focus(true)")
  self._ui._radiobutton_All:addInputEvent("Mouse_Out", "PaGlobalFunc_WorldMap_SellBuyHouse_Focus(false)")
  self._isMonotone = false
  if true == self._isSell then
    self._ui._radiobutton_All:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorldMap_SellBuyHouse_AllSell()")
  elseif explorePoint:getRemainedPoint() < self._totalValue then
    self._ui._radiobutton_All:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_HOUSECONTROL_BTN_LOWPOINT"))
    self._ui._radiobutton_All:SetMonoTone(true)
    self._isMonotone = true
    self._ui._radiobutton_All:addInputEvent("Mouse_LUp", "")
  else
    self._ui._radiobutton_All:SetMonoTone(false)
    self._ui._radiobutton_All:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorldMap_SellBuyHouse_AllBuy()")
  end
end
function PaGlobalFunc_WorldMap_SellBuyHouse_Focus(isFocus)
  local self = Window_WorldMap_SellBuyHouseInfo
  self._ui._static_KeyGuide_All:SetShow(true == isFocus and false == self._isMonotone)
end
function Window_WorldMap_SellBuyHouseInfo:SetHouseList()
  self._ui._list2_HouseList:getElementManager():clearKey()
  for index = 0, self._houseCount - 1 do
    self._ui._list2_HouseList:getElementManager():pushKey(toInt64(0, index))
    self._ui._list2_HouseList:requestUpdateByKey(toInt64(0, index))
  end
end
function Window_WorldMap_SellBuyHouseInfo:SetStr()
  if true == self._isSell then
    self._titleStr = PAGetString(Defines.StringSheet_GAME, "LUA_SELL_CONDTION_BTN_TXT")
    self._titleDescStr = PAGetString(Defines.StringSheet_GAME, "LUA_SELL_CONDTION_DESC")
    self._costTitleStr = PAGetString(Defines.StringSheet_GAME, "LUA_SELL_CONDTION_COST_TITLE")
    self._costStr = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_RETURN_CONTRIBUTE_TITLE")
    self._listTitleStr = PAGetString(Defines.StringSheet_GAME, "LUA_SELL_CONDTION_LIST_TITLE")
    self._buttonStr = PAGetString(Defines.StringSheet_GAME, "LUA_SELL_CONDTION_BTN_TXT")
    self._buttonSignStr = " + "
    self._totalButtonStr = PAGetString(Defines.StringSheet_GAME, "LUA_SELL_CONDTION_BTN_ALL")
    self._subInfoDesc = ""
  else
    self._titleStr = PAGetString(Defines.StringSheet_GAME, "LUA_BUY_CONDTION_BTN_TXT")
    self._titleDescStr = PAGetString(Defines.StringSheet_GAME, "LUA_BUY_CONDTION_DESC")
    self._costTitleStr = PAGetString(Defines.StringSheet_GAME, "LUA_BUY_CONDTION_COST_TITLE")
    self._costStr = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_NEED_CONTRIBUTE_TITLE")
    self._listTitleStr = PAGetString(Defines.StringSheet_GAME, "LUA_BUY_CONDTION_LIST_TITLE")
    self._buttonStr = PAGetString(Defines.StringSheet_GAME, "LUA_BUY_CONDTION_BTN_TXT")
    self._buttonSignStr = " - "
    self._totalButtonStr = PAGetString(Defines.StringSheet_GAME, "LUA_BUY_CONDTION_BTN_ALL")
    self._subInfoDesc = PAGetString(Defines.StringSheet_GAME, "LUA_BUY_CONDTION_GUIDE")
  end
end
function Window_WorldMap_SellBuyHouseInfo:InitControl()
  self._ui._staticText_Title = UI.getChildControl(self._ui._static_Bg, "StaticText_Title")
  self._ui._static_InnerBg = UI.getChildControl(self._ui._static_Bg, "Static_Inner")
  self._ui._staticText_TitleDesc = UI.getChildControl(self._ui._static_InnerBg, "StaticText_Info")
  self._ui._staticText_TitleDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._staticText_TitleDesc:SetAutoResize(true)
  self._ui._staticText_costTitle = UI.getChildControl(self._ui._static_InnerBg, "StaticText_Value_Title")
  self._ui._staticText_needTitle = UI.getChildControl(self._ui._static_InnerBg, "StaticText_Need")
  self._ui._staticText_needValue = UI.getChildControl(self._ui._static_InnerBg, "StaticText_Need_Val")
  self._ui._staticText_haveTitle = UI.getChildControl(self._ui._static_InnerBg, "StaticText_Have")
  self._ui._staticText_haveTitle:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_WORLDMAPGRAND_HELPICON_EXPLORERPOINT"))
  self._ui._staticText_haveValue = UI.getChildControl(self._ui._static_InnerBg, "StaticText_Have_Val")
  self._ui._staticText_listTitle = UI.getChildControl(self._ui._static_InnerBg, "StaticText_Condition")
  self._ui._list2_HouseList = UI.getChildControl(self._ui._static_InnerBg, "List2_HouseList")
  self._ui._staticText_subInfoDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._radiobutton_All = UI.getChildControl(self._ui._static_InnerBg, "Radiobutton_BatchBuy")
  self._ui._static_KeyGuide_All = UI.getChildControl(self._ui._radiobutton_All, "StaticText_A_ConsoleUI")
  self._ui._static_KeyGuide_All:SetShow(false)
end
function Window_WorldMap_SellBuyHouseInfo:InitEvent()
  self._ui._list2_HouseList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_WorldMap_SellBuyCondition_List2EventControlCreate")
  self._ui._list2_HouseList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function Window_WorldMap_SellBuyHouseInfo:InitRegister()
  registerEvent("FromClient_GetPrevHouseKey", "PaGlobalFunc_FromClient_WorldMap_SellBuyCondition_GetPrevHouseKey")
  registerEvent("FromClient_GetNextHouseKey", "PaGlobalFunc_FromClient_WorldMap_SellBuyCondition_GetNextHouseKey")
end
function Window_WorldMap_SellBuyHouseInfo:Initialize()
  self:InitControl()
  self:InitEvent()
  self:InitRegister()
end
function PaGlobalFunc_FromClient_WorldMap_SellBuyCondition_GetPrevHouseKey(houseKey)
  local self = Window_WorldMap_SellBuyHouseInfo
  if true == ToClient_IsMyHouse(houseKey) then
    return
  end
  local houseInfo = {}
  local houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper(houseKey)
  houseInfo._name = houseInfoStaticStatusWrapper:getName()
  houseInfo._houseKey = houseKey
  houseInfo._needValue = houseInfoStaticStatusWrapper:getNeedExplorePoint()
  self._houselist[self._houseCount] = houseInfo
  self._houseCount = self._houseCount + 1
  self._totalValue = self._totalValue + houseInfo._needValue
end
function PaGlobalFunc_FromClient_WorldMap_SellBuyCondition_GetNextHouseKey(houseKey)
  local self = Window_WorldMap_SellBuyHouseInfo
  if false == ToClient_IsMyHouse(houseKey) then
    return
  end
  local houseInfo = {}
  local houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper(houseKey)
  houseInfo._name = houseInfoStaticStatusWrapper:getName()
  houseInfo._houseKey = houseKey
  houseInfo._needValue = houseInfoStaticStatusWrapper:getNeedExplorePoint()
  self._houselist[self._houseCount] = houseInfo
  self._houseCount = self._houseCount + 1
  self._totalValue = self._totalValue + houseInfo._needValue
end
function PaGlobalFunc_WorldMap_SellBuyHouse_OnButton(index)
  local self = Window_WorldMap_SellBuyHouseInfo
  local prevOnButtonIndex = self._currentOnButtonIndex
  self._currentOnButtonIndex = index
  self._ui._list2_HouseList:requestUpdateByKey(toInt64(0, prevOnButtonIndex))
  self._ui._list2_HouseList:requestUpdateByKey(toInt64(0, self._currentOnButtonIndex))
end
function PaGlobalFunc_WorldMap_SellBuyCondition_List2EventControlCreate(list_content, key)
  local self = Window_WorldMap_SellBuyHouseInfo
  local id = Int64toInt32(key)
  local houseInfo = self._houselist[id]
  if nil == houseInfo then
    return
  end
  local houseInfoStaticStatusWrapper = ToClient_GetHouseInfoStaticStatusWrapper(houseInfo._houseKey)
  local showAble = false
  local button = UI.getChildControl(list_content, "Button_House")
  local staticText_KeyGuide_Select = UI.getChildControl(list_content, "StaticText_A_ConsoleUI")
  button:SetText(houseInfo._name)
  staticText_KeyGuide_Select:SetText(self._buttonStr .. "(" .. self._buttonSignStr .. houseInfo._needValue .. ")")
  button:addInputEvent("Mouse_On", "PaGlobalFunc_WorldMap_SellBuyHouse_OnButton(" .. id .. ")")
  if true == self._isSell then
    if true == houseInfoStaticStatusWrapper:isSalable() then
      button:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorldMap_SellBuyHouse_Sell(" .. id .. ")")
      staticText_KeyGuide_Select:SetShow(id == self._currentOnButtonIndex)
    else
      button:addInputEvent("Mouse_LUp", "")
      staticText_KeyGuide_Select:SetShow(false)
    end
  end
  if true == self._isBuy then
    if 0 == id then
      button:addInputEvent("Mouse_LUp", "PaGlobalFunc_WorldMap_SellBuyHouse_Buy(" .. id .. ")")
      staticText_KeyGuide_Select:SetShow(id == self._currentOnButtonIndex)
    else
      button:addInputEvent("Mouse_LUp", "")
      staticText_KeyGuide_Select:SetShow(false)
    end
  end
  local standX = button:GetPosX() + button:GetSizeX()
  local keyGuideSizeX = staticText_KeyGuide_Select:GetSizeX() + staticText_KeyGuide_Select:GetTextSizeX()
  staticText_KeyGuide_Select:SetPosX(standX - keyGuideSizeX - 10)
end
function PaGlobalFunc_WorldMap_SellBuyHouse_Sell(id)
  local self = Window_WorldMap_SellBuyHouseInfo
  local houseInfo = self._houselist[id]
  if nil == houseInfo then
    return
  end
  local function continue()
    ToClient_RequestReturnHouse(houseInfo._houseKey)
  end
  if true == self._isAllSell then
    continue()
    return
  end
  local workingcnt = getWorkingListAtRentHouse(houseInfo._houseKey)
  if false == ToClient_IsUsable(houseInfo._houseKey) then
    local str = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_ONCHANGEUSETYPE", "houseName", houseInfo._name)
    local messageboxData = {
      title = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_TITLE"),
      content = str,
      functionYes = continue,
      functionCancel = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData, "top")
    return
  elseif workingcnt > 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_ONCRAFT"))
    return
  end
  continue()
end
function PaGlobalFunc_WorldMap_SellBuyHouse_Buy(id)
  local self = Window_WorldMap_SellBuyHouseInfo
  local houseInfo = self._houselist[id]
  if nil == houseInfo then
    return
  end
  if houseInfo._houseKey == self._targetHouseKey and nil ~= self._targetUseType then
    ToClient_RequestBuyHouse(houseInfo._houseKey, self._targetUseType, 1)
  else
    ToClient_RequestBuyHouse(houseInfo._houseKey, 2, 1)
  end
end
function PaGlobalFunc_WorldMap_SellBuyHouse_AllSell()
  local self = Window_WorldMap_SellBuyHouseInfo
  local isUsable = true
  for index = #self._houselist, 0, -1 do
    local houseInfo = self._houselist[index]
    if nil ~= houseInfo then
      if false == ToClient_IsUsable(houseInfo._houseKey) then
        isUsable = false
      end
      local plantKey = PlantKey()
      plantKey:setRaw(-houseInfo._houseKey)
      local largeCraftExchange = getLargeCraftExchange(plantKey)
      if 0 ~= largeCraftExchange then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_ALL_ONLARGECRAFT"))
        return
      end
      local workingcnt = getWorkingListAtRentHouse(houseInfo._houseKey)
      if workingcnt > 0 then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_ALL_ONCRAFT"))
        return
      end
      local Dwellingcnt = getNextHouseisDwelling(houseInfo._houseKey)
      if Dwellingcnt > 0 then
        Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_ALL_DWELLING"))
        return
      end
    end
  end
  local str
  if false == isUsable then
    str = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_ALL_ONCHANGEUSETYPE") .. [[


]] .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_RETURNPOINT", "returnPoint", self._totalValue)
  else
    str = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_ALL") .. [[


]] .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_RETURNPOINT", "returnPoint", self._totalValue)
  end
  local messageboxData = {
    title = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_SELLHOUSE_TITLE"),
    content = str,
    functionYes = PaGlobalFunc_WorldMap_SellBuyHouse_AllSellContinue,
    functionCancel = MessageBox_Empty_function,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData, "top")
end
function PaGlobalFunc_WorldMap_SellBuyHouse_AllSellContinue()
  local self = Window_WorldMap_SellBuyHouseInfo
  self._isAllSell = true
  PaGlobalFunc_WorldMap_SellBuyHouse_Sell(0)
end
function PaGlobalFunc_WorldMap_SellBuyHouse_AllBuy()
  local self = Window_WorldMap_SellBuyHouseInfo
  self._isAllBuy = true
  PaGlobalFunc_WorldMap_SellBuyHouse_Buy(0)
end
function PaGlobalFunc_WorldMap_SellBuyHouse_DataUpdate(houseKey)
  local self = Window_WorldMap_SellBuyHouseInfo
  if false == PaGlobalFunc_WorldMap_SellBuyHouse_GetShow() then
    return
  end
  if houseKey ~= self._targetHouseKey then
    return
  end
  self:SetData()
  self:SetInfo()
  self:SetHouseList()
  if true == self._isAllBuy then
    PaGlobalFunc_WorldMap_SellBuyHouse_AllBuy()
  end
  if true == self._isAllSell then
    PaGlobalFunc_WorldMap_SellBuyHouse_AllSellContinue()
  end
end
function PaGlobalFunc_WorldMap_SellBuyHouse_GetShow()
  return Panel_Worldmap_SellBuyCondition:GetShow()
end
function PaGlobalFunc_WorldMap_SellBuyHouse_SetShow(isShow, isAni)
  Panel_Worldmap_SellBuyCondition:SetShow(isShow, isAni)
end
function PaGlobalFunc_WorldMap_SellBuyHouse_Open(isSell)
  local self = Window_WorldMap_SellBuyHouseInfo
  if true == PaGlobalFunc_WorldMap_SellBuyHouse_GetShow() then
    return
  end
  self._isSell = isSell
  self._isBuy = not isSell
  self._isAllBuy = false
  self._isAllSell = false
  self._targetHouseKey = PaGlobalFunc_WorldMapHouseManager_GetCurrentHouseKey()
  self._targetUseType = nil
  if true == self._isBuy then
    self._targetUseType = PaGlobalFunc_WorldMapHouseManager_GetCurrentUseType()
  end
  self:SetStr()
  self:SetData()
  self:SetInfo()
  self:SetHouseList()
  PaGlobalFunc_WorldMap_SellBuyHouse_SetShow(true, false)
end
function PaGlobalFunc_WorldMap_SellBuyHouse_Close()
  local self = Window_WorldMap_SellBuyHouseInfo
  if false == PaGlobalFunc_WorldMap_SellBuyHouse_GetShow() then
    return
  end
  self._targetUseType = nil
  self._ui._static_KeyGuide_All:SetShow(false)
  _AudioPostEvent_SystemUiForXBOX(50, 3)
  PaGlobalFunc_WorldMap_SellBuyHouse_SetShow(false, false)
end
function PaGlobalFunc_FromClient_WorldMap_SellBuyHouse_luaLoadComplete()
  local self = Window_WorldMap_SellBuyHouseInfo
  self:Initialize()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_FromClient_WorldMap_SellBuyHouse_luaLoadComplete")

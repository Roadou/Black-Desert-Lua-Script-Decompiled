Panel_TradeEventNotice_Renewal:SetShow(false)
PaGlobal_TradeEventNotice_Renewal = {
  _ui = {
    _btnClose = UI.getChildControl(Panel_TradeEventNotice_Renewal, "Button_Close"),
    _btnCheckBoxPopUp = UI.getChildControl(Panel_TradeEventNotice_Renewal, "CheckButton_PopUp"),
    _staticTradeEventBG = UI.getChildControl(Panel_TradeEventNotice_Renewal, "Static_TradeEventDescBG"),
    _btnTradeEventNavi = UI.getChildControl(Panel_TradeEventNotice_Renewal, "Button_TradeEvent_Navi"),
    _staticTextTradeEventDesc = nil,
    _staticTradeEventDown = UI.getChildControl(Panel_TradeEventNotice_Renewal, "Static_TradeEventDown"),
    _radioBtnShowIcon = nil,
    _radioBtnShowName = nil,
    _staticTextSupply = nil,
    _staticTextSupplyAlert = nil,
    _staticSupplyBG = nil,
    _staticTextSupplyTown = UI.getChildControl(Panel_TradeEventNotice_Renewal, "StaticText_TerritorySupply_Town"),
    _staticSupplyItemBG = UI.getChildControl(Panel_TradeEventNotice_Renewal, "Static_ItemSlotBG"),
    _staticSupplyItem = UI.getChildControl(Panel_TradeEventNotice_Renewal, "Static_ItemSlot"),
    _staticTextSupplyItemName = UI.getChildControl(Panel_TradeEventNotice_Renewal, "StaticText_TerritorySupply_ItemName"),
    _staticTextSupplyTownList = {},
    _btnSupplyNaviList = {},
    _staticSupplyBGList = {},
    _staticSupplyItemBGList = {},
    _staticSupplyItemList = {},
    _staticTextSupplyItemNameList = {}
  },
  _ETabState = {_icon = 0, _name = 1},
  _ETerritory = {
    _balenos = 0,
    _serendia = 1,
    _calpheon = 2,
    _media = 3,
    _valencia = 4,
    _margoria = 5,
    _kamasylvia = 6,
    _drigan = 7
  },
  _itemSlotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true
  },
  _tradeEventNpcRegionKey = {
    [40010] = 5,
    [40028] = 9,
    [40715] = 88,
    [41051] = 32,
    [41090] = 52,
    [42005] = 310,
    [42013] = 311,
    [42026] = 312,
    [42301] = 120,
    [43010] = 107,
    [44010] = 202,
    [44110] = 221,
    [40025] = 16,
    [41223] = 56,
    [43449] = 313,
    [50418] = 110,
    [50493] = 212
  },
  _supplyNpcRegionKey = {},
  _territoryName = {},
  _prevTab = _icon,
  _supplySpawnType = CppEnums.SpawnType.eSpawnType_TerritorySupply,
  _columnNum = 2,
  _nameColumnNum = 2,
  _territoryCount = 2,
  _maxItemCount = 6,
  _needTradeEventUpdate = true,
  _needSupplyUpdate = true,
  _lineGapY = nil,
  _supplyItemCount = {},
  _supplyItemKeyList = {}
}
function PaGlobal_TradeEventNotice_Renewal:Initialize()
  self._supplyNpcRegionKey = {
    [self._ETerritory._balenos] = 5,
    [self._ETerritory._serendia] = 32,
    [self._ETerritory._calpheon] = 310,
    [self._ETerritory._media] = 202,
    [self._ETerritory._valencia] = 229,
    [self._ETerritory._margoria] = 821,
    [self._ETerritory._kamasylvia] = 735,
    [self._ETerritory._drigan] = 873
  }
  self._territoryName = {
    [self._ETerritory._balenos] = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_1"),
    [self._ETerritory._serendia] = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_2"),
    [self._ETerritory._calpheon] = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_3"),
    [self._ETerritory._media] = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_4"),
    [self._ETerritory._valencia] = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_5"),
    [self._ETerritory._margoria] = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_ROTPORT"),
    [self._ETerritory._kamasylvia] = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_KAMASYLVIA"),
    [self._ETerritory._drigan] = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_DRIGAN")
  }
  self._prevTab = self._ETabState._icon
  Panel_TradeEventNotice_Renewal:RegisterShowEventFunc(true, "PaGlobal_TradeEventNotice_Renewal:ShowAni()")
  Panel_TradeEventNotice_Renewal:RegisterShowEventFunc(false, "PaGlobal_TradeEventNotice_Renewal:HideAni()")
  PaGlobal_TradeEventNotice_Renewal:SetTerritoryCount()
  PaGlobal_TradeEventNotice_Renewal:InitializeUI()
end
function PaGlobal_TradeEventNotice_Renewal:InitializeUI()
  self._ui._staticTextTradeEventDesc = UI.getChildControl(self._ui._staticTradeEventBG, "StaticText_TradeEventDesc")
  self._ui._radioBtnShowIcon = UI.getChildControl(self._ui._staticTradeEventDown, "RadioButton_ShowIcon")
  self._ui._radioBtnShowName = UI.getChildControl(self._ui._staticTradeEventDown, "RadioButton_ShowName")
  self._ui._staticTextSupply = UI.getChildControl(self._ui._staticTradeEventDown, "StaticText_TerritorySupply")
  self._ui._staticSupplyBG = UI.getChildControl(self._ui._staticTradeEventDown, "Static_TerritorySupplyBG")
  self._ui._staticTextSupplyAlert = UI.getChildControl(self._ui._staticTradeEventDown, "StaticText_TerritorySupplyAlert")
  self._ui._btnClose:addInputEvent("Mouse_LUp", "PaGlobal_TradeEventNotice_Renewal:Close()")
  self._ui._btnCheckBoxPopUp:addInputEvent("Mouse_LUp", "PaGlobal_TradeEventNotice_Renewal:PopUp()")
  self._ui._btnCheckBoxPopUp:addInputEvent("Mouse_On", "PaGlobal_TradeEventNotice_Renewal:ShowPopUpToolTip()")
  self._ui._btnCheckBoxPopUp:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
  self._ui._radioBtnShowIcon:addInputEvent("Mouse_LUp", "PaGlobal_TradeEventNotice_Renewal:HandleClicked_Tab(" .. self._ETabState._icon .. ")")
  self._ui._radioBtnShowName:addInputEvent("Mouse_LUp", "PaGlobal_TradeEventNotice_Renewal:HandleClicked_Tab(" .. self._ETabState._name .. ")")
  self._ui._radioBtnShowIcon:addInputEvent("Mouse_On", "PaGlobal_TradeEventNotice_Renewal:ShowRadioButtonSimpleToolTip(" .. self._ETabState._icon .. ")")
  self._ui._radioBtnShowName:addInputEvent("Mouse_On", "PaGlobal_TradeEventNotice_Renewal:ShowRadioButtonSimpleToolTip(" .. self._ETabState._name .. ")")
  self._ui._radioBtnShowIcon:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
  self._ui._radioBtnShowName:addInputEvent("Mouse_Out", "TooltipSimple_Hide()")
  self._ui._btnTradeEventNavi:addInputEvent("Mouse_LUp", "PaGlobal_TradeEventNotice_Renewal:TradeEventNPCNaviStart()")
  self._ui._radioBtnShowIcon:SetCheck(true)
  self._ui._radioBtnShowName:SetCheck(false)
  self._ui._btnCheckBoxPopUp:SetShow(ToClient_IsContentsGroupOpen("240"))
  self._ui._staticTextTradeEventDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui._staticTextSupplyItemName:SetSize((self._ui._staticSupplyBG:GetSizeX() - 40) / self._nameColumnNum, self._ui._staticTextSupplyItemName:GetSizeY())
  self._ui._staticTextSupplyItemName:setLineCountByLimitAutoWrap(1)
  self._ui._staticTextSupplyItemName:SetTextMode(CppEnums.TextMode.eTextMode_Limit_AutoWrap)
  PaGlobal_TradeEventNotice_Renewal:InitializeCreateUI()
end
function PaGlobal_TradeEventNotice_Renewal:InitializeCreateUI()
  self._lineGapY = self._ui._staticSupplyBG:GetSizeY() + 10
  local itemGapX = self._ui._staticSupplyItemBG:GetSizeX() + 10
  local nameGapY = self._ui._staticTextSupplyItemName:GetTextSizeY() + 2
  for terrIndex = 0, self._territoryCount - 1 do
    self._supplyItemKeyList[terrIndex] = {}
    self._ui._staticSupplyBGList[terrIndex] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui._staticTradeEventDown, "Static_TerritorySupplyTownBG_" .. terrIndex)
    self._ui._btnSupplyNaviList[terrIndex] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, self._ui._staticSupplyBGList[terrIndex], "Button_TerritorySupplyNavi_" .. terrIndex)
    self._ui._staticTextSupplyTownList[terrIndex] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._ui._staticSupplyBGList[terrIndex], "StaticText_TerritorySupplyTown_" .. terrIndex)
    CopyBaseProperty(self._ui._staticTextSupplyTown, self._ui._staticTextSupplyTownList[terrIndex])
    CopyBaseProperty(self._ui._btnTradeEventNavi, self._ui._btnSupplyNaviList[terrIndex])
    CopyBaseProperty(self._ui._staticSupplyBG, self._ui._staticSupplyBGList[terrIndex])
    local addPosX = self._ui._staticSupplyBG:GetSizeX() + 20
    addPosX = terrIndex % self._columnNum * addPosX
    local lineNum = math.floor(terrIndex / self._columnNum)
    self._ui._staticSupplyBGList[terrIndex]:SetPosX(self._ui._staticSupplyBGList[terrIndex]:GetPosX() + addPosX)
    self._ui._staticSupplyBGList[terrIndex]:SetPosY(self._ui._staticSupplyBGList[terrIndex]:GetPosY() + self._lineGapY * lineNum)
    self._ui._staticTextSupplyTownList[terrIndex]:SetText(self._territoryName[terrIndex] .. PaGlobal_TradeEventNotice_Renewal:GetTerritorySupplyNpcName(terrIndex))
    self._ui._btnSupplyNaviList[terrIndex]:SetPosX(self._ui._staticTextSupplyTownList[terrIndex]:GetPosX() + self._ui._staticTextSupplyTownList[terrIndex]:GetTextSizeX() + 5)
    self._ui._btnSupplyNaviList[terrIndex]:SetPosY(self._ui._staticTextSupplyTownList[terrIndex]:GetPosY())
    self._ui._btnSupplyNaviList[terrIndex]:addInputEvent("Mouse_LUp", "PaGlobal_TradeEventNotice_Renewal:SupplyNPCNaviStart(" .. terrIndex .. ")")
    self._ui._staticSupplyItemBGList[terrIndex] = {}
    self._ui._staticTextSupplyItemNameList[terrIndex] = {}
    self._ui._staticSupplyItemList[terrIndex] = {}
    for itemIndex = 0, self._maxItemCount - 1 do
      self._ui._staticSupplyItemBGList[terrIndex][itemIndex] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui._staticSupplyBGList[terrIndex], "Static_TerritorySupplyItemBG_" .. terrIndex .. "_" .. itemIndex)
      self._ui._staticTextSupplyItemNameList[terrIndex][itemIndex] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._ui._staticSupplyBGList[terrIndex], "Static_TerritorySupplyItemName_" .. terrIndex .. "_" .. itemIndex)
      local itemSlot = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui._staticSupplyItemBGList[terrIndex][itemIndex], "Static_TerritorySupplyItem_" .. terrIndex .. "_" .. itemIndex)
      CopyBaseProperty(self._ui._staticSupplyItemBG, self._ui._staticSupplyItemBGList[terrIndex][itemIndex])
      CopyBaseProperty(self._ui._staticTextSupplyItemName, self._ui._staticTextSupplyItemNameList[terrIndex][itemIndex])
      CopyBaseProperty(self._ui._staticSupplyItem, itemSlot)
      local slotNo = terrIndex * self._maxItemCount + itemIndex
      self._ui._staticSupplyItemList[terrIndex][itemIndex] = SlotItem.new(nil, "TradeSupply_Icon_" .. slotNo, slotNo, itemSlot, self._itemSlotConfig)
      self._ui._staticSupplyItemList[terrIndex][itemIndex].icon:SetPosX(1)
      self._ui._staticSupplyItemList[terrIndex][itemIndex].icon:SetPosY(1)
      self._ui._staticSupplyItemBGList[terrIndex][itemIndex]:SetPosX(self._ui._staticSupplyItemBGList[terrIndex][itemIndex]:GetPosX() + itemGapX * itemIndex)
      self._ui._staticTextSupplyItemNameList[terrIndex][itemIndex]:SetPosX(self._ui._staticTextSupplyItemNameList[terrIndex][itemIndex]:GetPosX() + self._ui._staticSupplyBG:GetSizeX() / self._nameColumnNum * (itemIndex % self._nameColumnNum))
      self._ui._staticTextSupplyItemNameList[terrIndex][itemIndex]:SetPosY(self._ui._staticTextSupplyItemNameList[terrIndex][itemIndex]:GetPosY() + math.floor(itemIndex / self._nameColumnNum) * nameGapY)
      self._ui._staticSupplyItemList[terrIndex][itemIndex].icon:addInputEvent("Mouse_On", "PaGlobal_TradeEventNotice_Renewal:ShowItemToolTip(" .. terrIndex .. " , " .. itemIndex .. ", " .. self._ETabState._icon .. ")")
      self._ui._staticSupplyItemList[terrIndex][itemIndex].icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
      self._ui._staticTextSupplyItemNameList[terrIndex][itemIndex]:addInputEvent("Mouse_On", "PaGlobal_TradeEventNotice_Renewal:ShowItemToolTip(" .. terrIndex .. " , " .. itemIndex .. ", " .. self._ETabState._name .. ")")
      self._ui._staticTextSupplyItemNameList[terrIndex][itemIndex]:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
    end
  end
  self._ui._staticSupplyItem:SetShow(false)
  self._ui._staticTextSupplyTown:SetShow(false)
end
function PaGlobal_TradeEventNotice_Renewal:UpdateTradeEventInfo()
  if not self._needTradeEventUpdate then
    return
  end
  self._needTradeEventUpdate = false
  local eventInfo = FGlobal_TradeEventInfo()
  if nil == eventInfo then
    self._ui._staticTextTradeEventDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_6") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_7") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_8"))
    self._ui._btnTradeEventNavi:SetShow(false)
  else
    self._ui._staticTextTradeEventDesc:SetText(eventInfo .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_7"))
    self._ui._btnTradeEventNavi:SetShow(true)
  end
  local changedEventBGSizeY = self._ui._staticTextTradeEventDesc:GetTextSizeY() + 20
  local addPosY = changedEventBGSizeY - self._ui._staticTradeEventBG:GetSizeY()
  self._ui._staticTradeEventBG:SetSize(self._ui._staticTradeEventBG:GetSizeX(), changedEventBGSizeY)
  self._ui._staticTradeEventDown:SetPosY(self._ui._staticTradeEventDown:GetPosY() + addPosY)
  Panel_TradeEventNotice_Renewal:SetSize(Panel_TradeEventNotice_Renewal:GetSizeX(), self._ui._staticTradeEventDown:GetPosY() + self._ui._staticTradeEventDown:GetSizeY())
end
function PaGlobal_TradeEventNotice_Renewal:UpdateSupplyInfo()
  if not self._needSupplyUpdate then
    return
  end
  self._needSupplyUpdate = false
  local supplyStart = false
  for terrIndex = 0, self._territoryCount - 1 do
    self._ui._staticSupplyBGList[terrIndex]:SetShow(false)
    self._supplyItemCount[terrIndex] = ToClient_worldmap_getTradeSupplyCount(terrIndex)
    if 0 < self._supplyItemCount[terrIndex] then
      self._ui._staticSupplyBGList[terrIndex]:SetShow(true)
      if self._ETerritory._margoria == terrIndex then
        self._ui._btnSupplyNaviList[terrIndex]:SetShow(false)
      end
      for itemIndex = 0, self._maxItemCount - 1 do
        if itemIndex < self._supplyItemCount[terrIndex] then
          if self._ui._radioBtnShowName:IsChecked() then
            self._ui._staticTextSupplyItemNameList[terrIndex][itemIndex]:SetShow(true)
            self._ui._staticSupplyItemBGList[terrIndex][itemIndex]:SetShow(false)
          else
            self._ui._staticSupplyItemBGList[terrIndex][itemIndex]:SetShow(true)
            self._ui._staticTextSupplyItemNameList[terrIndex][itemIndex]:SetShow(false)
          end
          PaGlobal_TradeEventNotice_Renewal:SetItem(terrIndex, itemIndex)
        else
          self._ui._staticTextSupplyItemNameList[terrIndex][itemIndex]:SetShow(false)
          self._ui._staticSupplyItemBGList[terrIndex][itemIndex]:SetShow(false)
        end
        supplyStart = true
      end
    end
  end
  local tempSizeY = 30
  if supplyStart then
    self._ui._staticTextSupplyAlert:SetShow(false)
    self._ui._staticSupplyBG:SetShow(false)
    self._ui._radioBtnShowIcon:SetShow(true)
    self._ui._radioBtnShowName:SetShow(true)
    self._ui._staticTradeEventDown:SetSize(self._ui._staticTradeEventDown:GetSizeX(), self._ui._staticTextSupply:GetSizeY() + self._lineGapY * (math.floor((self._territoryCount - 1) / self._columnNum) + 1) + tempSizeY)
  else
    self._ui._staticTextSupplyAlert:SetShow(true)
    self._ui._staticSupplyBG:SetShow(true)
    self._ui._radioBtnShowIcon:SetShow(false)
    self._ui._radioBtnShowName:SetShow(false)
    self._ui._staticSupplyBG:SetSize(self._ui._staticTradeEventBG:GetSizeX(), self._ui._staticSupplyBG:GetSizeY())
    self._ui._staticTradeEventDown:SetSize(self._ui._staticTradeEventDown:GetSizeX(), self._ui._staticTextSupply:GetSizeY() + self._ui._staticSupplyBG:GetSizeY() + tempSizeY)
  end
  Panel_TradeEventNotice_Renewal:SetSize(Panel_TradeEventNotice_Renewal:GetSizeX(), self._ui._staticTradeEventDown:GetPosY() + self._ui._staticTradeEventDown:GetSizeY())
end
function PaGlobal_TradeEventNotice_Renewal:ShowItemToolTip(terrIndex, itemIndex, tabState)
  local supplyItemWrapper = ToClient_worldmap_getTradeSupplyItem(terrIndex, itemIndex)
  if nil ~= supplyItemWrapper then
    local supplyItemSSW = supplyItemWrapper:getStaticStatus()
    if nil ~= supplyItemSSW then
      if self._ETabState._icon == tabState then
        Panel_Tooltip_Item_Show(supplyItemSSW, self._ui._staticSupplyItemList[terrIndex][itemIndex].icon, true, false)
      elseif self._ETabState._name == tabState then
        Panel_Tooltip_Item_Show(supplyItemSSW, self._ui._staticTextSupplyItemNameList[terrIndex][itemIndex], true, false)
      end
    end
  end
end
function PaGlobal_TradeEventNotice_Renewal:SetItem(terrIndex, itemIndex)
  local supplyItemWrapper = ToClient_worldmap_getTradeSupplyItem(terrIndex, itemIndex)
  if nil ~= supplyItemWrapper then
    local supplyItemSSW = supplyItemWrapper:getStaticStatus()
    self._ui._staticSupplyItemList[terrIndex][itemIndex]:setItemByStaticStatus(supplyItemSSW)
    self._ui._staticTextSupplyItemNameList[terrIndex][itemIndex]:SetText(supplyItemSSW:getName())
    self._supplyItemKeyList[terrIndex][itemIndex] = supplyItemSSW:get()._key:get()
  else
    self._supplyItemKeyList[terrIndex][itemIndex] = nil
  end
end
function PaGlobal_TradeEventNotice_Renewal:Show()
  if false == ToClient_IsGrowStepOpen(__eGrowStep_trade) then
    return
  end
  if not Panel_TradeEventNotice_Renewal:GetShow() then
    Panel_TradeEventNotice_Renewal:SetShow(true, true)
    if self._needTradeEventUpdate then
      PaGlobal_TradeEventNotice_Renewal:UpdateTradeEventInfo()
    end
    if self._needSupplyUpdate then
      PaGlobal_TradeEventNotice_Renewal:UpdateSupplyInfo()
    end
    PaGlobal_TradeEventNotice_Renewal:Resize()
    audioPostEvent_SystemUi(1, 8)
    _AudioPostEvent_SystemUiForXBOX(1, 18)
  else
    PaGlobal_TradeEventNotice_Renewal:Close()
    Panel_Tooltip_Item_hideTooltip()
  end
end
function PaGlobal_TradeEventNotice_Renewal:Close()
  if self._ui._btnCheckBoxPopUp:IsCheck() then
    self._ui._btnCheckBoxPopUp:SetCheck(false)
    Panel_TradeEventNotice_Renewal:CloseUISubApp()
    Panel_TradeEventNotice_Renewal:SetShow(false, false)
  else
    Panel_TradeEventNotice_Renewal:SetShow(false, true)
  end
  Panel_Tooltip_Item_hideTooltip()
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
end
function PaGlobal_TradeEventNotice_Renewal:PopUp()
  if self._ui._btnCheckBoxPopUp:IsCheck() then
    Panel_TradeEventNotice_Renewal:OpenUISubApp()
  else
    Panel_TradeEventNotice_Renewal:CloseUISubApp()
  end
  TooltipSimple_Hide()
end
function PaGlobal_TradeEventNotice_Renewal:ShowPopUpToolTip()
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_TOOLTIP_NAME")
  local desc = ""
  if self._ui._btnCheckBoxPopUp:IsCheck() then
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_CHECK_TOOLTIP")
  else
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_NOCHECK_TOOLTIP")
  end
  TooltipSimple_Show(self._ui._btnCheckBoxPopUp, name, desc)
end
function PaGlobal_TradeEventNotice_Renewal:ShowRadioButtonSimpleToolTip(tabState)
  local name = ""
  if self._ETabState._icon == tabState then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_TOOLTIP_ICON_SHOW_NAME")
    TooltipSimple_Show(self._ui._radioBtnShowIcon, name, nil)
  elseif self._ETabState._name == tabState then
    name = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_TOOLTIP_NAME_SHOW_NAME")
    TooltipSimple_Show(self._ui._radioBtnShowName, name, nil)
  end
end
function PaGlobal_TradeEventNotice_Renewal:HandleClicked_Tab(tabState)
  if self._ETabState._icon == tabState and self._ETabState._icon ~= self._prevTab then
    self._prevTab = self._ETabState._icon
    for terrIndex = 0, self._territoryCount - 1 do
      for itemIndex = 0, self._maxItemCount - 1 do
        self._ui._staticTextSupplyItemNameList[terrIndex][itemIndex]:SetShow(false)
        if itemIndex < self._supplyItemCount[terrIndex] then
          self._ui._staticSupplyItemBGList[terrIndex][itemIndex]:SetShow(true)
        end
      end
    end
  elseif self._ETabState._name == tabState and self._ETabState._name ~= self._prevTab then
    self._prevTab = self._ETabState._name
    for terrIndex = 0, self._territoryCount - 1 do
      for itemIndex = 0, self._maxItemCount - 1 do
        self._ui._staticSupplyItemBGList[terrIndex][itemIndex]:SetShow(false)
        if itemIndex < self._supplyItemCount[terrIndex] then
          self._ui._staticTextSupplyItemNameList[terrIndex][itemIndex]:SetShow(true)
        end
      end
    end
  end
end
function PaGlobal_TradeEventNotice_Renewal:GetTerritorySupplyNpcName(territory)
  local npcData = ToClient_getNpcInfoByRegionAndType(self._supplyNpcRegionKey[territory], self._supplySpawnType)
  if nil ~= npcData then
    return " " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_NPC", "npcName", npcData:getName())
  else
    return ""
  end
end
function PaGlobal_TradeEventNotice_Renewal:SupplyNPCNaviStart(territory)
  local npcData = ToClient_getNpcInfoByRegionAndType(self._supplyNpcRegionKey[territory], self._supplySpawnType)
  if nil ~= npcData then
    if ToClient_IsShowNaviGuideGroup(0) then
      ToClient_DeleteNaviGuideByGroup(0)
    end
    ToClient_WorldMapNaviStart(npcData:getPosition(), NavigationGuideParam(), false, false)
    audioPostEvent_SystemUi(0, 14)
    _AudioPostEvent_SystemUiForXBOX(0, 14)
  end
end
function PaGlobal_TradeEventNotice_Renewal:TradeEventNPCNaviStart()
  local npcKey = FGlobal_TradeEvent_Npckey_Return()
  local npcData = ToClient_getNpcInfoByRegionAndKey(self._tradeEventNpcRegionKey[npcKey], npcKey)
  if nil ~= npcData then
    if ToClient_IsShowNaviGuideGroup(0) then
      ToClient_DeleteNaviGuideByGroup(0)
    end
    ToClient_WorldMapNaviStart(npcData:getPosition(), NavigationGuideParam(), false, false)
    audioPostEvent_SystemUi(0, 14)
    _AudioPostEvent_SystemUiForXBOX(0, 14)
  end
end
function PaGlobal_TradeEventNotice_Renewal:GetTerritorySupplyIndex(itemKey)
  if self._needSupplyUpdate then
    PaGlobal_TradeEventNotice_Renewal:UpdateSupplyInfo()
  end
  for terrIndex = 0, self._territoryCount - 1 do
    for itemIndex = 0, self._maxItemCount - 1 do
      if self._supplyItemKeyList[terrIndex][itemIndex] == itemKey then
        return terrIndex
      end
    end
  end
  return nil
end
function PaGlobal_TradeEventNotice_Renewal:Resize()
  Panel_TradeEventNotice_Renewal:SetPosX(getScreenSizeX() / 2 - Panel_TradeEventNotice_Renewal:GetSizeX() / 2)
  Panel_TradeEventNotice_Renewal:SetPosY(getScreenSizeY() / 2 - Panel_TradeEventNotice_Renewal:GetSizeY() / 2)
end
function PaGlobal_TradeEventNotice_Renewal:ShowAni()
  Panel_TradeEventNotice_Renewal:SetAlpha(0)
  UIAni.AlphaAnimation(1, Panel_TradeEventNotice_Renewal, 0, 0.3)
end
function PaGlobal_TradeEventNotice_Renewal:HideAni()
  local ani = UIAni.AlphaAnimation(0, Panel_TradeEventNotice_Renewal, 0, 0.2)
  ani:SetHideAtEnd(true)
end
function PaGlobal_TradeEventNotice_Renewal:SetTerritoryCount()
  if ToClient_IsContentsGroupOpen("6") then
    self._territoryCount = 8
  elseif ToClient_IsContentsGroupOpen("260") then
    self._territoryCount = 7
  elseif ToClient_IsContentsGroupOpen("83") then
    self._territoryCount = 6
  elseif ToClient_IsContentsGroupOpen("4") then
    self._territoryCount = 5
  elseif ToClient_IsContentsGroupOpen("3") then
    self._territoryCount = 4
  elseif ToClient_IsContentsGroupOpen("2") then
    self._territoryCount = 3
  else
    self._territoryCount = 2
  end
end
function FromClient_UpdateTradeEventInfo_TradeEventNotice_Renewal()
  PaGlobal_TradeEventNotice_Renewal._needTradeEventUpdate = true
  if Panel_TradeEventNotice_Renewal:GetShow() then
    PaGlobal_TradeEventNotice_Renewal:UpdateTradeEventInfo()
  end
end
function FromClient_UpdateSupplyInfo_TradeEventNotice_Renewal()
  PaGlobal_TradeEventNotice_Renewal._needSupplyUpdate = true
  if Panel_TradeEventNotice_Renewal:GetShow() then
    PaGlobal_TradeEventNotice_Renewal:UpdateSupplyInfo()
  end
end
function FromClient_Resize_TradeEventNotice_Renewal()
  PaGlobal_TradeEventNotice_Renewal:Resize()
end
function FGlobal_TradeEventNotice_Renewal_Show()
  PaGlobal_TradeEventNotice_Renewal:Show()
end
function FGlobal_TradeEventNotice_Renewal_Close()
  PaGlobal_TradeEventNotice_Renewal:Close()
end
function FGlobal_TradeEventNotice_Renewal_GetTerritorySupplyIndex(itemKey)
  return PaGlobal_TradeEventNotice_Renewal:GetTerritorySupplyIndex(itemKey)
end
registerEvent("FromClient_NotifyVariableTradeItemMsg", "FromClient_UpdateTradeEventInfo_TradeEventNotice_Renewal")
registerEvent("FromClientNotifySupplyTradeStart", "FromClient_UpdateSupplyInfo_TradeEventNotice_Renewal")
registerEvent("onScreenResize", "FromClient_Resize_TradeEventNotice_Renewal")
PaGlobal_TradeEventNotice_Renewal:Initialize()

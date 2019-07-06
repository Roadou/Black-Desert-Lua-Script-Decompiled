Panel_TradeInfo_Renew:SetShow(false)
PaGlobal_TradeInformation = {
  _ui = {
    _staticTradeEventBG = UI.getChildControl(Panel_TradeInfo_Renew, "Static_TradeEventDescBG"),
    _staticTextTradeEventDesc = nil,
    _staticTextTradeEventFocusBG = nil,
    _staticTradeEventDown = UI.getChildControl(Panel_TradeInfo_Renew, "Static_TradeEventDown"),
    _staticTextSupply = nil,
    _staticTextSupplyAlert = nil,
    _staticSupplyBG = nil,
    _staticTextSupplyTown = UI.getChildControl(Panel_TradeInfo_Renew, "StaticText_TerritorySupply_Town"),
    _staticSupplyItemBG = UI.getChildControl(Panel_TradeInfo_Renew, "Static_ItemSlotBG"),
    _staticSupplyItem = UI.getChildControl(Panel_TradeInfo_Renew, "Static_ItemSlot"),
    _stcKeyguideBG = UI.getChildControl(Panel_TradeInfo_Renew, "Static_KeyGuideBG"),
    _staticTextSupplyTownList = {},
    _staticSupplyBGList = {},
    _staticSupplyItemBGList = {},
    _staticSupplyItemList = {}
  },
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
function PaGlobal_TradeInformation:Initialize()
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
  PaGlobal_TradeInformation:SetTerritoryCount()
  PaGlobal_TradeInformation:InitializeUI()
end
function PaGlobal_TradeInformation:InitializeUI()
  self._ui._staticTextTradeEventDesc = UI.getChildControl(self._ui._staticTradeEventBG, "StaticText_TradeEventDesc")
  self._ui._staticTextTradeEventFocusBG = UI.getChildControl(self._ui._staticTradeEventBG, "Static_FocusBG")
  self._ui._staticTextSupply = UI.getChildControl(self._ui._staticTradeEventDown, "StaticText_TerritorySupply")
  self._ui._staticSupplyBG = UI.getChildControl(self._ui._staticTradeEventDown, "Static_TerritorySupplyBG")
  self._ui._staticTextSupplyAlert = UI.getChildControl(self._ui._staticTradeEventDown, "StaticText_TerritorySupplyAlert")
  self._ui._staticTextTradeEventDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  PaGlobal_TradeInformation:InitializeCreateUI()
end
function PaGlobal_TradeInformation:InitializeCreateUI()
  self._lineGapY = self._ui._staticSupplyBG:GetSizeY() + 10
  local itemGapX = self._ui._staticSupplyItemBG:GetSizeX() + 15
  for terrIndex = 0, self._territoryCount - 1 do
    self._supplyItemKeyList[terrIndex] = {}
    self._ui._staticSupplyBGList[terrIndex] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui._staticTradeEventDown, "Static_TerritorySupplyTownBG_" .. terrIndex)
    self._ui._staticTextSupplyTownList[terrIndex] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, self._ui._staticSupplyBGList[terrIndex], "StaticText_TerritorySupplyTown_" .. terrIndex)
    CopyBaseProperty(self._ui._staticTextSupplyTown, self._ui._staticTextSupplyTownList[terrIndex])
    CopyBaseProperty(self._ui._staticSupplyBG, self._ui._staticSupplyBGList[terrIndex])
    local addPosX = self._ui._staticSupplyBG:GetSizeX() + 20
    addPosX = terrIndex % self._columnNum * addPosX
    local lineNum = math.floor(terrIndex / self._columnNum)
    self._ui._staticSupplyBGList[terrIndex]:SetPosX(self._ui._staticSupplyBGList[terrIndex]:GetPosX() + addPosX)
    self._ui._staticSupplyBGList[terrIndex]:SetPosY(self._ui._staticSupplyBGList[terrIndex]:GetPosY() + self._lineGapY * lineNum)
    self._ui._staticTextSupplyTownList[terrIndex]:SetText(self._territoryName[terrIndex] .. "\n" .. PaGlobal_TradeInformation:GetTerritorySupplyNpcName(terrIndex))
    self._ui._staticSupplyItemBGList[terrIndex] = {}
    self._ui._staticSupplyItemList[terrIndex] = {}
    for itemIndex = 0, self._maxItemCount - 1 do
      self._ui._staticSupplyItemBGList[terrIndex][itemIndex] = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui._staticSupplyBGList[terrIndex], "Static_TerritorySupplyItemBG_" .. terrIndex .. "_" .. itemIndex)
      local itemSlot = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, self._ui._staticSupplyItemBGList[terrIndex][itemIndex], "Static_TerritorySupplyItem_" .. terrIndex .. "_" .. itemIndex)
      CopyBaseProperty(self._ui._staticSupplyItemBG, self._ui._staticSupplyItemBGList[terrIndex][itemIndex])
      CopyBaseProperty(self._ui._staticSupplyItem, itemSlot)
      local slotNo = terrIndex * self._maxItemCount + itemIndex
      self._ui._staticSupplyItemList[terrIndex][itemIndex] = SlotItem.new(nil, "TradeSupply_Icon_" .. slotNo, slotNo, itemSlot, self._itemSlotConfig)
      self._ui._staticSupplyItemList[terrIndex][itemIndex].icon:SetPosX(1)
      self._ui._staticSupplyItemList[terrIndex][itemIndex].icon:SetPosY(1)
      self._ui._staticSupplyItemBGList[terrIndex][itemIndex]:SetPosX(self._ui._staticSupplyItemBGList[terrIndex][itemIndex]:GetPosX() + itemGapX * itemIndex)
      if self._ETerritory._margoria ~= terrIndex then
        self._ui._staticSupplyItemBGList[terrIndex][itemIndex]:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_TradeInformation:SupplyNPCNaviStart(" .. terrIndex .. ")")
      end
      self._ui._staticSupplyItemBGList[terrIndex][itemIndex]:registerPadEvent(__eConsoleUIPadEvent_Up_X, "PaGlobal_TradeInformation:ToggleItemTooltip( " .. terrIndex .. " , " .. itemIndex .. " )")
    end
  end
  self._ui._staticTradeEventBG:registerPadEvent(__eConsoleUIPadEvent_Up_A, "PaGlobal_TradeInformation:TradeEventNPCNaviStart()")
  local stc_keyguideA = UI.getChildControl(self._ui._stcKeyguideBG, "StaticText_A_ConsoleUI")
  local stc_keyguideX = UI.getChildControl(self._ui._stcKeyguideBG, "StaticText_X_ConsoleUI")
  local stc_keyguideB = UI.getChildControl(self._ui._stcKeyguideBG, "StaticText_B_ConsoleUI")
  local keyGuideAlign = {
    stc_keyguideA,
    stc_keyguideX,
    stc_keyguideB
  }
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(keyGuideAlign, self._ui._stcKeyguideBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  self._ui._staticSupplyItem:SetShow(false)
  self._ui._staticTextSupplyTown:SetShow(false)
end
function PaGlobal_TradeInformation:UpdateTradeEventInfo()
  if not self._needTradeEventUpdate then
    return
  end
  self._needTradeEventUpdate = false
  local eventInfo = FGlobal_TradeEventInfo()
  if nil == eventInfo then
    self._ui._staticTextTradeEventDesc:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_6") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_7") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_8"))
    self._ui._staticTradeEventBG:SetIgnore(true)
  else
    self._ui._staticTextTradeEventDesc:SetText(eventInfo .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_7"))
    self._ui._staticTradeEventBG:SetIgnore(false)
  end
  local changedEventBGSizeY = self._ui._staticTextTradeEventDesc:GetTextSizeY() + 20
  local addPosY = changedEventBGSizeY - self._ui._staticTradeEventBG:GetSizeY()
  self._ui._staticTradeEventBG:SetSize(self._ui._staticTradeEventBG:GetSizeX(), changedEventBGSizeY)
  self._ui._staticTextTradeEventFocusBG:SetSize(self._ui._staticTextTradeEventFocusBG:GetSizeX(), changedEventBGSizeY + 6)
  self._ui._staticTradeEventDown:SetPosY(self._ui._staticTradeEventDown:GetPosY() + addPosY)
  Panel_TradeInfo_Renew:SetSize(Panel_TradeInfo_Renew:GetSizeX(), self._ui._staticTradeEventDown:GetPosY() + self._ui._staticTradeEventDown:GetSizeY())
  self._ui._stcKeyguideBG:ComputePos()
end
function PaGlobal_TradeInformation:UpdateSupplyInfo()
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
      for itemIndex = 0, self._maxItemCount - 1 do
        if itemIndex < self._supplyItemCount[terrIndex] then
          self._ui._staticSupplyItemBGList[terrIndex][itemIndex]:SetShow(true)
          PaGlobal_TradeInformation:SetItem(terrIndex, itemIndex)
        else
          self._ui._staticSupplyItemBGList[terrIndex][itemIndex]:SetShow(false)
        end
        supplyStart = true
      end
    end
  end
  local tempSizeY = 40
  if supplyStart then
    self._ui._staticTextSupplyAlert:SetShow(false)
    self._ui._staticSupplyBG:SetShow(false)
    self._ui._staticTradeEventDown:SetSize(self._ui._staticTradeEventDown:GetSizeX(), self._ui._staticTextSupply:GetSizeY() + self._lineGapY * (math.floor((self._territoryCount - 1) / self._columnNum) + 1) + tempSizeY)
  else
    self._ui._staticTextSupplyAlert:SetShow(true)
    self._ui._staticSupplyBG:SetShow(true)
    self._ui._staticSupplyBG:SetSize(self._ui._staticTradeEventBG:GetSizeX(), self._ui._staticSupplyBG:GetSizeY())
    self._ui._staticTradeEventDown:SetSize(self._ui._staticTradeEventDown:GetSizeX(), self._ui._staticTextSupply:GetSizeY() + self._ui._staticSupplyBG:GetSizeY() + tempSizeY)
  end
  Panel_TradeInfo_Renew:SetSize(Panel_TradeInfo_Renew:GetSizeX(), self._ui._staticTradeEventDown:GetPosY() + self._ui._staticTradeEventDown:GetSizeY())
  self._ui._stcKeyguideBG:ComputePos()
end
function PaGlobal_TradeInformation:ToggleItemTooltip(terrIndex, itemIndex)
  local supplyItemWrapper = ToClient_worldmap_getTradeSupplyItem(terrIndex, itemIndex)
  if nil ~= supplyItemWrapper then
    local supplyItemSSW = supplyItemWrapper:getStaticStatus()
    if nil ~= supplyItemSSW then
      if true == PaGlobalFunc_TooltipInfo_GetShow() then
        PaGlobalFunc_TooltipInfo_Close()
      else
        PaGlobalFunc_TooltipInfo_Open(Defines.TooltipDataType.ItemSSWrapper, supplyItemSSW, Defines.TooltipTargetType.Item, 0)
      end
    end
  end
end
function PaGlobal_TradeInformation:SetItem(terrIndex, itemIndex)
  local supplyItemWrapper = ToClient_worldmap_getTradeSupplyItem(terrIndex, itemIndex)
  if nil ~= supplyItemWrapper then
    local supplyItemSSW = supplyItemWrapper:getStaticStatus()
    self._ui._staticSupplyItemList[terrIndex][itemIndex]:setItemByStaticStatus(supplyItemSSW)
    self._supplyItemKeyList[terrIndex][itemIndex] = supplyItemSSW:get()._key:get()
  else
    self._supplyItemKeyList[terrIndex][itemIndex] = nil
  end
end
function PaGlobal_TradeInformation:Show()
  if not Panel_TradeInfo_Renew:GetShow() then
    Panel_TradeInfo_Renew:SetShow(true, true)
    if self._needTradeEventUpdate then
      PaGlobal_TradeInformation:UpdateTradeEventInfo()
    end
    if self._needSupplyUpdate then
      PaGlobal_TradeInformation:UpdateSupplyInfo()
    end
    PaGlobal_TradeInformation:Resize()
    audioPostEvent_SystemUi(1, 8)
    _AudioPostEvent_SystemUiForXBOX(1, 18)
  else
    PaGlobal_TradeInformation:Close()
    Panel_Tooltip_Item_hideTooltip()
  end
end
function PaGlobal_TradeInformation:Close()
  Panel_TradeInfo_Renew:SetShow(false, true)
  PaGlobalFunc_TooltipInfo_Close()
  audioPostEvent_SystemUi(1, 1)
  _AudioPostEvent_SystemUiForXBOX(1, 1)
end
function PaGlobal_TradeInformation:GetTerritorySupplyNpcName(territory)
  local npcData = ToClient_getNpcInfoByRegionAndType(self._supplyNpcRegionKey[territory], self._supplySpawnType)
  if nil ~= npcData then
    return " " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_NPC", "npcName", npcData:getName())
  else
    return ""
  end
end
function PaGlobal_TradeInformation:SupplyNPCNaviStart(territory)
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
function PaGlobal_TradeInformation:TradeEventNPCNaviStart()
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
function PaGlobal_TradeInformation:GetTerritorySupplyIndex(itemKey)
  if self._needSupplyUpdate then
    PaGlobal_TradeInformation:UpdateSupplyInfo()
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
function PaGlobal_TradeInformation:Resize()
  Panel_TradeInfo_Renew:SetPosX(getScreenSizeX() / 2 - Panel_TradeInfo_Renew:GetSizeX() / 2)
  Panel_TradeInfo_Renew:SetPosY(getScreenSizeY() / 2 - Panel_TradeInfo_Renew:GetSizeY() / 2)
end
function PaGlobal_TradeInformation:SetTerritoryCount()
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
function PaGlobal_TradeInformation:getTerritoryCount()
  return self._territoryCount
end
function FromClient_UpdateTradeEventInfo_TradeEventNotice_Renewal()
  PaGlobal_TradeInformation._needTradeEventUpdate = true
  if Panel_TradeInfo_Renew:GetShow() then
    PaGlobal_TradeInformation:UpdateTradeEventInfo()
  end
end
function FromClient_UpdateSupplyInfo_TradeEventNotice_Renewal()
  PaGlobal_TradeInformation._needSupplyUpdate = true
  if Panel_TradeInfo_Renew:GetShow() then
    PaGlobal_TradeInformation:UpdateSupplyInfo()
  end
end
function FromClient_Resize_TradeEventNotice_Renewal()
  PaGlobal_TradeInformation:Resize()
end
function FGlobal_TradeEventNotice_Renewal_Show()
  PaGlobal_TradeInformation:Show()
end
function FGlobal_TradeEventNotice_Renewal_Close()
  PaGlobal_TradeInformation:Close()
end
function FGlobal_TradeEventNotice_Renewal_GetTerritorySupplyIndex(itemKey)
  return PaGlobal_TradeInformation:GetTerritorySupplyIndex(itemKey)
end
registerEvent("FromClient_NotifyVariableTradeItemMsg", "FromClient_UpdateTradeEventInfo_TradeEventNotice_Renewal")
registerEvent("FromClientNotifySupplyTradeStart", "FromClient_UpdateSupplyInfo_TradeEventNotice_Renewal")
registerEvent("onScreenResize", "FromClient_Resize_TradeEventNotice_Renewal")
PaGlobal_TradeInformation:Initialize()

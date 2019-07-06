Panel_TradeMarket_EventInfo:setMaskingChild(true)
Panel_TradeMarket_EventInfo:setGlassBackground(true)
Panel_TradeMarket_EventInfo:SetShow(false)
Panel_TradeMarket_EventInfo:RegisterShowEventFunc(true, "Panel_TradeMarket_EventInfo_ShowAni()")
Panel_TradeMarket_EventInfo:RegisterShowEventFunc(false, "Panel_TradeMarket_EventInfo_HideAni()")
function Panel_TradeMarket_EventInfo_ShowAni()
  Panel_TradeMarket_EventInfo:SetAlpha(0)
  UIAni.AlphaAnimation(1, Panel_TradeMarket_EventInfo, 0, 0.3)
end
function Panel_TradeMarket_EventInfo_HideAni()
  local ani1 = UIAni.AlphaAnimation(0, Panel_TradeMarket_EventInfo, 0, 0.2)
  ani1:SetHideAtEnd(true)
end
local btnClose = UI.getChildControl(Panel_TradeMarket_EventInfo, "Button_Close")
btnClose:addInputEvent("Mouse_LUp", "TradeEventInfo_Close()")
local checkPopUp = UI.getChildControl(Panel_TradeMarket_EventInfo, "CheckButton_PopUp")
checkPopUp:addInputEvent("Mouse_LUp", "TradeEventInfo_PopUp()")
checkPopUp:addInputEvent("Mouse_On", "TradeEventInfo_PopUp_ShowIconToolTip(true)")
checkPopUp:addInputEvent("Mouse_Out", "TradeEventInfo_PopUp_ShowIconToolTip(false)")
local isPopUpContentsEnable = ToClient_IsContentsGroupOpen("240")
checkPopUp:SetShow(isPopUpContentsEnable)
local tradeEvent = UI.getChildControl(Panel_TradeMarket_EventInfo, "StaticText_TradeEvent")
local eventNavi = UI.getChildControl(Panel_TradeMarket_EventInfo, "Button_TradeEvent_Navi")
local eventBg = UI.getChildControl(Panel_TradeMarket_EventInfo, "Static_TradeEventDescBG")
local eventDesc = UI.getChildControl(Panel_TradeMarket_EventInfo, "StaticText_TradeEventDesc")
local eventAlert = UI.getChildControl(Panel_TradeMarket_EventInfo, "StaticText_TradeEventAlert")
eventDesc:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
eventAlert:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
eventNavi:addInputEvent("Mouse_LUp", "Find_TradeEvnetNpc()")
local supplyBg = UI.getChildControl(Panel_TradeMarket_EventInfo, "Static_TerritorySupplyBG")
local supplyTown = UI.getChildControl(Panel_TradeMarket_EventInfo, "StaticText_TerritorySupply_Town")
local supplyText = UI.getChildControl(Panel_TradeMarket_EventInfo, "StaticText_TerritorySupply")
local supplyNavi = UI.getChildControl(Panel_TradeMarket_EventInfo, "Button_Supply_Navi")
local itemSlot = UI.getChildControl(Panel_TradeMarket_EventInfo, "Static_ItemPanel")
local slotBg = UI.getChildControl(Panel_TradeMarket_EventInfo, "Static_SlotBG")
local supplyAlert = UI.getChildControl(Panel_TradeMarket_EventInfo, "StaticText_TerritorySupplyAlert")
local slotConfig = {
  createIcon = true,
  createBorder = true,
  createCount = true
}
local territorySupplyNpcRegionKey = {
  [0] = 5,
  [1] = 32,
  [2] = 310,
  [3] = 202,
  [4] = 229,
  [5] = 821,
  [6] = 735
}
local tradeEvnetNpcRegionKey = {
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
}
local isCalpheon, isMedia, isValencia, terrCount = 2, 3, 4, nil
if ToClient_IsContentsGroupOpen("260") then
  terrCount = 7
elseif ToClient_IsContentsGroupOpen("83") then
  terrCount = 6
elseif ToClient_IsContentsGroupOpen("4") then
  terrCount = 5
elseif ToClient_IsContentsGroupOpen("3") then
  terrCount = 4
elseif ToClient_IsContentsGroupOpen("2") then
  terrCount = 3
else
  terrCount = 2
end
local territoryName = {
  [0] = PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_1"),
  PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_2"),
  PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_3"),
  PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_4"),
  PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_5"),
  PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_ROTPORT"),
  PAGetString(Defines.StringSheet_GAME, "LUA_CONTRYNAME_6")
}
local maxTerritoryCount = #territoryName + 1
local maxSlotCount = 6
local eventBgSizeY = eventBg:GetSizeY()
local bgSizeY = supplyBg:GetSizeY()
local gapX, gapY = 58, 80
local _townName = {}
local _btnNavi = {}
local _slotBg = {}
local _itemSlot = {}
function TradeEventInfo_Init()
  for terrIndex = 0, terrCount - 1 do
    local temp1 = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATICTEXT, Panel_TradeMarket_EventInfo, "Static_TerritorySupplyTownName_" .. terrIndex)
    CopyBaseProperty(supplyTown, temp1)
    temp1:SetText(territoryName[terrIndex])
    temp1:SetPosY(supplyTown:GetPosY() + terrIndex * gapY)
    temp1:SetShow(false)
    _townName[terrIndex] = temp1
    local tempNavi = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_BUTTON, Panel_TradeMarket_EventInfo, "Button_TerritorySupplyNavi_" .. terrIndex)
    CopyBaseProperty(supplyNavi, tempNavi)
    tempNavi:SetPosX(temp1:GetPosX() + temp1:GetTextSizeX() + 5)
    tempNavi:SetPosY(temp1:GetPosY())
    tempNavi:SetShow(false)
    tempNavi:addInputEvent("Mouse_LUp", "Find_TerritorySupplyNPC(" .. terrIndex .. ")")
    _btnNavi[terrIndex] = tempNavi
    _slotBg[terrIndex] = {}
    _itemSlot[terrIndex] = {}
    for supplyIndex = 0, maxSlotCount - 1 do
      local temp2 = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_TradeMarket_EventInfo, "Static_TerritorySupplySlotBg" .. terrIndex .. "_" .. supplyIndex)
      CopyBaseProperty(slotBg, temp2)
      temp2:SetPosX(slotBg:GetPosX() + supplyIndex * gapX)
      temp2:SetPosY(slotBg:GetPosY() + terrIndex * gapY)
      temp2:SetShow(false)
      _slotBg[terrIndex][supplyIndex] = temp2
      local temp3 = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, Panel_TradeMarket_EventInfo, "Static_TerritorySupplySlot" .. terrIndex .. "_" .. supplyIndex)
      CopyBaseProperty(itemSlot, temp3)
      temp3:SetPosX(itemSlot:GetPosX() + supplyIndex * gapX)
      temp3:SetPosY(itemSlot:GetPosY() + terrIndex * gapY)
      temp3:SetShow(true)
      local slotNo = terrIndex * terrCount + supplyIndex
      local slot = {}
      SlotItem.new(slot, "TradeSupply_Icon_" .. slotNo, slotNo, temp3, slotConfig)
      slot:createChild()
      slot.icon:addInputEvent("Mouse_On", "Tooltip_Item_Show_TerrSupply(" .. supplyIndex .. ", " .. terrIndex .. ", true)")
      slot.icon:addInputEvent("Mouse_Out", "Tooltip_Item_Show_TerrSupply(" .. supplyIndex .. ", " .. terrIndex .. ", false)")
      slot.icon:SetIgnore(true)
      _itemSlot[terrIndex][supplyIndex] = slot
    end
  end
end
TradeEventInfo_Init()
local tradeSupplyCount = {}
local tradeSupplyItemGroup = {}
function TradeEventInfo_Set()
  local eventInfo = FGlobal_TradeEventInfo()
  local eventSizeY = 0
  if nil == eventInfo then
    eventDesc:SetShow(false)
    eventAlert:SetShow(true)
    eventAlert:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_6") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_7") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_8"))
    eventNavi:SetShow(false)
    eventSizeY = eventAlert:GetTextSizeY()
  else
    eventDesc:SetText(eventInfo .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_7"))
    eventDesc:SetShow(true)
    eventAlert:SetShow(false)
    eventNavi:SetShow(true)
    eventSizeY = eventDesc:GetTextSizeY()
  end
  local bgSizeY = eventBg:GetSizeY()
  local tradeEventSizeX = tradeEvent:GetTextSizeX()
  local tradeEventPosX = tradeEvent:GetPosX()
  local eventNaviPosX = eventNavi:GetPosX()
  if eventNaviPosX < tradeEventPosX + tradeEventSizeX then
    eventNavi:SetPosX(eventNaviPosX + (tradeEventPosX + tradeEventSizeX - eventNaviPosX) + 6)
  end
  if eventSizeY > bgSizeY then
    eventBg:SetSize(eventBg:GetSizeX(), eventSizeY + 10)
    supplyBg:SetPosY(supplyBg:GetPosY() + (eventSizeY - bgSizeY + 10))
    supplyText:SetPosY(supplyText:GetPosY() + (eventSizeY - bgSizeY + 10))
    for terrIndex = 0, terrCount - 1 do
      _townName[terrIndex]:SetPosY(_townName[terrIndex]:GetPosY() + (eventSizeY - bgSizeY + 10))
      _btnNavi[terrIndex]:SetPosY(_btnNavi[terrIndex]:GetPosY() + (eventSizeY - bgSizeY + 10))
      for supplyIndex = 0, maxSlotCount - 1 do
        _itemSlot[terrIndex][supplyIndex].icon:SetPosY(_itemSlot[terrIndex][supplyIndex].icon:GetPosY() + (eventSizeY - bgSizeY + 10))
        _slotBg[terrIndex][supplyIndex]:SetPosY(_slotBg[terrIndex][supplyIndex]:GetPosY() + (eventSizeY - bgSizeY + 10))
      end
    end
  end
  local curChannelData = getCurrentChannelServerData()
  local isMain = curChannelData._isMain
  local supplyStart = false
  tradeSupplyItemGroup = {}
  for terrIndex = 0, terrCount - 1 do
    tradeSupplyCount[terrIndex] = ToClient_worldmap_getTradeSupplyCount(terrIndex)
    if tradeSupplyCount[terrIndex] > 0 then
      tradeSupplyItemGroup[terrIndex] = {}
      _townName[terrIndex]:SetShow(true)
      _townName[terrIndex]:SetText(territoryName[terrIndex] .. Show_TerritorySupplyNpcName(terrIndex))
      if ToClient_IsContentsGroupOpen("83") then
        if terrIndex < terrCount - 1 then
          _btnNavi[terrIndex]:SetShow(true)
          _btnNavi[terrIndex]:SetPosX(_townName[terrIndex]:GetPosX() + _townName[terrIndex]:GetTextSizeX() + 5)
        end
      else
        _btnNavi[terrIndex]:SetShow(true)
        _btnNavi[terrIndex]:SetPosX(_townName[terrIndex]:GetPosX() + _townName[terrIndex]:GetTextSizeX() + 5)
      end
      for supplyIndex = 0, maxSlotCount - 1 do
        if supplyIndex < tradeSupplyCount[terrIndex] then
          _slotBg[terrIndex][supplyIndex]:SetShow(true)
          local slot = _itemSlot[terrIndex][supplyIndex]
          local supplyItemWrapper = ToClient_worldmap_getTradeSupplyItem(terrIndex, supplyIndex)
          if nil == supplyItemWrapper then
            return
          end
          local supplyItemSSW = supplyItemWrapper:getStaticStatus()
          slot.icon:SetIgnore(false)
          slot:setItemByStaticStatus(supplyItemSSW)
          slot.icon:addInputEvent("Mouse_On", "Tooltip_Item_Show_TerrSupply(" .. supplyIndex .. ", " .. terrIndex .. ", true)")
          slot.icon:addInputEvent("Mouse_Out", "Tooltip_Item_Show_TerrSupply(" .. supplyIndex .. ", " .. terrIndex .. ", false)")
          Panel_Tooltip_Item_SetPosition(supplyIndex, slot, "tradeEventInfo")
          table.insert(tradeSupplyItemGroup[terrIndex], supplyItemSSW:get()._key:get())
        else
          _slotBg[terrIndex][supplyIndex]:SetShow(false)
          local slot = _itemSlot[terrIndex][supplyIndex]
          slot.icon:addInputEvent("Mouse_On", "")
          slot.icon:addInputEvent("Mouse_Out", "")
          slot:clearItem()
        end
      end
      supplyStart = true
    end
  end
  if supplyStart then
    supplyAlert:SetShow(false)
    supplyBg:SetSize(supplyBg:GetSizeX(), terrCount * gapY + 10)
  else
    supplyAlert:SetShow(true)
    supplyBg:SetSize(supplyBg:GetSizeX(), bgSizeY)
  end
  Panel_TradeMarket_EventInfo:SetSize(Panel_TradeMarket_EventInfo:GetSizeX(), supplyBg:GetPosY() + supplyBg:GetSizeY() + 25)
end
function FGlobal_TradeSupplyItemInfo_Compare(itemKey)
  TradeEventInfo_Set()
  for terrIndex = 0, terrCount - 1 do
    if nil ~= tradeSupplyItemGroup[terrIndex] then
      for i = 1, #tradeSupplyItemGroup[terrIndex] do
        if tradeSupplyItemGroup[terrIndex][i] == itemKey then
          return terrIndex
        end
      end
    end
  end
  return nil
end
function Find_TerritorySupplyNPC(territoryKey)
  if ToClient_IsShowNaviGuideGroup(0) then
    ToClient_DeleteNaviGuideByGroup(0)
  end
  local regionKeyRaw = territorySupplyNpcRegionKey[territoryKey]
  local spawnType = CppEnums.SpawnType.eSpawnType_TerritorySupply
  local count = npcList_getNpcCount(regionKeyRaw)
  for idx = 0, count - 1 do
    local npcData = npcList_getNpcInfo(idx)
    if npcData:getSpawnType() == spawnType then
      local npcPosition = npcData:getPosition()
      ToClient_WorldMapNaviStart(npcPosition, NavigationGuideParam(), false, false)
      break
    end
  end
  audioPostEvent_SystemUi(0, 14)
  _AudioPostEvent_SystemUiForXBOX(0, 14)
end
function Show_TerritorySupplyNpcName(territoryKey)
  local regionKeyRaw = territorySupplyNpcRegionKey[territoryKey]
  local spawnType = CppEnums.SpawnType.eSpawnType_TerritorySupply
  local count = npcList_getNpcCount(regionKeyRaw)
  local npcName = ""
  for idx = 0, count - 1 do
    local npcData = npcList_getNpcInfo(idx)
    if npcData:getSpawnType() == spawnType then
      npcName = " " .. PAGetStringParam1(Defines.StringSheet_GAME, "LUA_TRADEEVENTINFO_NPC", "npcName", npcData:getName())
      return npcName
    end
  end
  return npcName
end
function Find_TradeEvnetNpc()
  local npcKey = FGlobal_TradeEvent_Npckey_Return()
  if nil ~= npcKey then
    if ToClient_IsShowNaviGuideGroup(0) then
      ToClient_DeleteNaviGuideByGroup(0)
    end
    local regionKeyRaw = tradeEvnetNpcRegionKey[npcKey]
    if nil == regionKeyRaw then
      return nil
    end
    local count = npcList_getNpcCount(regionKeyRaw)
    for idx = 0, count - 1 do
      local npcData = npcList_getNpcInfo(idx)
      if npcData:getKeyRaw() == npcKey then
        local npcPosition = npcData:getPosition()
        ToClient_WorldMapNaviStart(npcPosition, NavigationGuideParam(), false, false)
        break
      end
    end
  end
end
function Tooltip_Item_Show_TerrSupply(slotNo, territoryKey, isOn)
  Panel_Tooltip_Item_Show_GeneralStatic(slotNo, "tradeEventInfo", isOn, territoryKey)
end
function TradeEventInfo_Show()
  if not Panel_TradeMarket_EventInfo:GetShow() then
    Panel_TradeMarket_EventInfo:SetShow(true, true)
    TradeEventInfo_Set()
    TradeEventInfo_Resize()
    audioPostEvent_SystemUi(1, 8)
    _AudioPostEvent_SystemUiForXBOX(1, 18)
  else
    TradeEventInfo_Close()
  end
end
function TradeEventInfo_Close()
  checkPopUp:SetCheck(false)
  Panel_TradeMarket_EventInfo:SetShow(false, true)
  Panel_TradeMarket_EventInfo:CloseUISubApp()
end
function TradeEventInfo_PopUp()
  if checkPopUp:IsCheck() then
    Panel_TradeMarket_EventInfo:OpenUISubApp()
  else
    Panel_TradeMarket_EventInfo:CloseUISubApp()
  end
  TooltipSimple_Hide()
end
function TradeEventInfo_Resize()
  Panel_TradeMarket_EventInfo:SetPosX(getScreenSizeX() / 2 - Panel_TradeMarket_EventInfo:GetSizeX() / 2)
  Panel_TradeMarket_EventInfo:SetPosY(getScreenSizeY() / 2 - Panel_TradeMarket_EventInfo:GetSizeY() / 2)
end
function TradeEventInfo_PopUp_ShowIconToolTip(isShow)
  if isShow then
    local name = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_TOOLTIP_NAME")
    local desc = ""
    if checkPopUp:IsCheck() then
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_CHECK_TOOLTIP")
    else
      desc = PAGetString(Defines.StringSheet_GAME, "LUA_POPUI_NOCHECK_TOOLTIP")
    end
    TooltipSimple_Show(checkPopUp, name, desc)
  else
    TooltipSimple_Hide()
  end
end
registerEvent("FromClient_NotifyVariableTradeItemMsg", "TradeEventInfo_Set")
registerEvent("onScreenResize", "TradeEventInfo_Resize")

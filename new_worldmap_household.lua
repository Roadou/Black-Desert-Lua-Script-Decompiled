local HGLT = CppEnums.HouseGroupLocationType
local HouseButtonSetBaseTextureUV = function(pData, pPath, pX1, pY1, pX2, pY2)
  pData:ChangeTextureInfoName(pPath)
  local x1, y1, x2, y2 = setTextureUV_Func(pData, pX1, pY1, pX2, pY2)
  pData:getBaseTexture():setUV(x1, y1, x2, y2)
end
local HouseButtonSetOnTextureUV = function(pData, pPath, pX1, pY1, pX2, pY2)
  pData:ChangeOnTextureInfoName(pPath)
  x1, y1, x2, y2 = setTextureUV_Func(pData, pX1, pY1, pX2, pY2)
  pData:getOnTexture():setUV(x1, y1, x2, y2)
end
local houseInfo, houseKey
local temp_houseEffectArray = Array.new()
local controlNameList = {
  [-1] = "Static_Empty",
  [CppEnums.eHouseUseType.Empty] = "Static_LiveHouse",
  [CppEnums.eHouseUseType.Lodging] = "Static_Inn",
  [CppEnums.eHouseUseType.Depot] = "Static_WareHouse",
  [CppEnums.eHouseUseType.Ranch] = "Static_Horse",
  [CppEnums.eHouseUseType.WeaponForgingWorkshop] = "Static_Weapon",
  [CppEnums.eHouseUseType.ArmorForgingWorkshop] = "Static_Guard",
  [CppEnums.eHouseUseType.HandMadeWorkshop] = "Static_HandMade",
  [CppEnums.eHouseUseType.WoodCraftWorkshop] = "Static_Carpenter",
  [CppEnums.eHouseUseType.JewelryWorkshop] = "Static_Jewel",
  [CppEnums.eHouseUseType.ToolWorkshop] = "Static_Tools",
  [CppEnums.eHouseUseType.Refinery] = "Static_Blackstone",
  [CppEnums.eHouseUseType.ImproveWorkshop] = "Static_Upgrade",
  [CppEnums.eHouseUseType.CannonWorkshop] = "Static_Cannon",
  [CppEnums.eHouseUseType.Shipyard] = "Static_Ships",
  [CppEnums.eHouseUseType.CarriageWorkshop] = "Static_Carriage",
  [CppEnums.eHouseUseType.HorseArmorWorkshop] = "Static_HorseGoods",
  [CppEnums.eHouseUseType.FurnitureWorkshop] = "Static_Furniture",
  [CppEnums.eHouseUseType.LocalSpecailtiesWorkshop] = "Static_Special",
  [CppEnums.eHouseUseType.Wardrobe] = "Static_MakeCustomize",
  [CppEnums.eHouseUseType.SiegeWeapons] = "Static_MakeCannon",
  [CppEnums.eHouseUseType.ShipParts] = "Static_MakeShip",
  [CppEnums.eHouseUseType.WagonParts] = "Static_MakeCarriage",
  [CppEnums.eHouseUseType.AssetManagementshop] = "Static_AssetManagement",
  [CppEnums.eHouseUseType.PotteryWorkshop] = "Static_PotteryWorkshop",
  ["_changeUseType"] = "Static_Const",
  ["_crafting"] = "Static_Change",
  ["_noPurchasable"] = "Static_Working"
}
function FGlobal_WorldmapHouseHold_GetControlNameList()
  return controlNameList
end
function FGlobal_HouseHoldButtonSetBaseTexture(houseBtn)
  if nil == houseBtn then
    return
  end
  local houseInfo = houseBtn:FromClient_getStaticStatus()
  local houseKey = houseInfo:getHouseKey()
  local workingcnt = ToClient_getHouseWorkingWorkerList(houseInfo:get())
  local rentHouseWrapper = ToClient_GetRentHouseWrapper(houseKey)
  local houselocationType = houseInfo:getHouseLocationType()
  local stringName = controlNameList[-1]
  local isShowConstructionAni = false
  if true == ToClient_IsMyHouse(houseKey) then
    if ToClient_GetProgressRateChangeHouseUseType(houseKey) < 100 then
      stringName = controlNameList._changeUseType
      isShowConstructionAni = true
    elseif workingcnt >= 1 then
      stringName = controlNameList._crafting
      isShowConstructionAni = true
    else
      if nil == rentHouseWrapper then
        return
      end
      local useType = rentHouseWrapper:getHouseUseType()
      if false == ToClient_IsMyLiveHouse(houseKey) and 0 == useType then
        useType = -1
      end
      stringName = controlNameList[useType]
      if nil == stringName then
        stringName = controlNameList[0]
      end
    end
  elseif false == houseInfo:isPurchasable(CppEnums.eHouseUseType.Depot) then
    stringName = controlNameList[-1]
  else
    stringName = controlNameList._noPurchasable
  end
  local constructionAni = houseBtn:FromClient_getConstructionAni()
  local guageBG = houseBtn:FromClient_getConstructionGuageBG()
  local guage = houseBtn:FromClient_getConstructionGauge()
  local remainTime = houseBtn:FromClient_getRemainTime()
  if nil ~= constructionAni then
    constructionAni:SetShow(isShowConstructionAni)
    guageBG:SetShow(isShowConstructionAni)
    guage:SetShow(isShowConstructionAni)
    remainTime:SetShow(isShowConstructionAni)
  end
  if HGLT.eHouseGroupLocationType_onlyOne == houselocationType then
  elseif HGLT.eHouseGroupLocationType_bottom == houselocationType then
    stringName = stringName .. "_3F"
  elseif HGLT.eHouseGroupLocationType_center == houselocationType then
    stringName = stringName .. "_2F"
  elseif HGLT.eHouseGroupLocationType_top == houselocationType then
    stringName = stringName .. "_1F"
  end
  houseBtn:EraseAllEffect()
  local posX = houseBtn:GetPosX()
  local posY = houseBtn:GetPosY()
  local scale = houseBtn:GetScale()
  local isShow = houseBtn:GetShow()
  houseBtn:SetScale(1, 1)
  CopyBaseProperty(UI.getChildControl(Panel_HouseIcon, stringName), houseBtn)
  if false == ToClient_IsMyHouse(houseKey) and true == houseInfo:isPurchasable(CppEnums.eHouseUseType.Depot) then
    houseBtn:SetVertexAniRun("Ani_Color_New", true)
  end
  houseBtn:SetPosX(posX)
  houseBtn:SetPosY(posY)
  houseBtn:SetScale(scale.x, scale.y)
  houseBtn:setRenderTexture(houseBtn:getBaseTexture())
  houseBtn:SetShow(isShow)
  PaGlobal_TutorialManager:handleHouseHoldButtonSetBaseTexture(houseBtn)
end
function FromClient_LClickedWorldMapHouse(houseBtn)
  if true == _ContentsGroup_GrowStep and false == ToClient_IsGrowStepOpen(__eGrowStep_buyHouse) then
    return
  end
  houseInfo = houseBtn:FromClient_getStaticStatus()
  if nil == houseInfo then
    return
  end
  clear_HouseSelectedAni_byHouse()
  houseKey = houseInfo:getHouseKey()
  local IsUsable = ToClient_IsUsable(houseKey)
  local _panel_houseControl = Panel_HouseControl
  if true == _ContentsGroup_ForXBoxFinalCert then
    _panel_houseControl = Panel_Worldmap_HouseCraft
  end
  if false == _panel_houseControl:GetShow() and false == Panel_House_SellBuy_Condition:GetShow() then
    clear_HouseSelectedAni_bySellBuy()
    if true == Panel_RentHouse_WorkManager:GetShow() then
      if true == Panel_Select_Inherit:GetShow() then
        WorldMapPopupManager:pop()
      end
      WorldMapPopupManager:pop()
      if false == _panel_houseControl:GetShow() then
        WorldMapPopupManager:increaseLayer()
        WorldMapPopupManager:push(_panel_houseControl, true)
      end
    elseif true == Panel_Building_WorkManager:GetShow() or true == Panel_LargeCraft_WorkManager:GetShow() or true == Panel_Plant_WorkManager:GetShow() then
      WorldMapPopupManager:pop()
      if false == _panel_houseControl:GetShow() then
        WorldMapPopupManager:increaseLayer()
        WorldMapPopupManager:push(_panel_houseControl, true)
      end
    else
      WorldMapPopupManager:increaseLayer()
      WorldMapPopupManager:push(_panel_houseControl, true)
    end
  elseif true == Panel_House_SellBuy_Condition:GetShow() then
    WorldMapPopupManager:pop()
    if false == _panel_houseControl:GetShow() then
      WorldMapPopupManager:increaseLayer()
      WorldMapPopupManager:push(_panel_houseControl, true)
    end
  end
  show_HouseSelectedAni_byHouse()
  if true == _ContentsGroup_ForXBoxFinalCert then
    PaGlobalFunc_WorldMapHouseCraft_Open(houseInfo)
  else
    FGlobal_UpdateHouseControl(houseInfo)
    FGlobal_Reset_HousePanelPos()
  end
  PaGlobal_TutorialManager:handleLClickedWorldMapHouse(houseBtn)
end
function show_HouseSelectedAni_byHouse()
  local _HouseBtn = ToClient_findHouseButtonByKey(houseKey)
  if _HouseBtn ~= nil then
    local _selectedAni = _HouseBtn:FromClient_getSelectedAni()
    _selectedAni:SetShow(true)
    _selectedAni:SetHorizonCenter()
    _selectedAni:SetVerticalMiddle()
    _HouseBtn:SetVertexAniRun("Ani_Color_New", true)
  end
end
function clear_HouseSelectedAni_byHouse()
  if nil == houseKey then
    return
  end
  local _HouseBtn = ToClient_findHouseButtonByKey(houseKey)
  if _HouseBtn ~= nil then
    local _selectedAni = _HouseBtn:FromClient_getSelectedAni()
    _selectedAni:SetShow(false)
    _HouseBtn:ResetVertexAni()
    if false == ToClient_IsMyHouse(houseKey) and true == ToClient_GetHouseInfoStaticStatusWrapper(houseKey):isPurchasable(CppEnums.eHouseUseType.Depot) then
      _HouseBtn:SetVertexAniRun("Ani_Color_New", true)
    end
  end
end
function FromClient_RClickedWorldMapHouse(houseBtn)
  local houseInfo = houseBtn:FromClient_getStaticStatus()
  if nil == houseInfo then
    return
  end
  FromClient_RClickWorldmapPanel(houseInfo:getPosition(), false, true)
end
function FGlobal_SelectedHouseInfo(_houseKey)
  local houseInfoSSW = ToClient_findHouseButtonByKey(_houseKey):FromClient_getStaticStatus()
  return houseInfoSSW
end
function FromClient_AppliedChangeUseType_Ack(houseInfoSSWrapper)
  local _houseKey = houseInfoSSWrapper:getHouseKey()
  local houseName = houseInfoSSWrapper:getName()
  local rentHouse = ToClient_GetRentHouseWrapper(_houseKey)
  local currentUseType = rentHouse:getType()
  local realIndex = houseInfoSSWrapper:getIndexByReceipeKey(currentUseType)
  local houseInfoCraftWrapper = houseInfoSSWrapper:getHouseCraftWrapperByIndex(realIndex)
  local useType_Name = houseInfoCraftWrapper:getReciepeName()
  local currentHouseLevel = rentHouse:getLevel()
  if currentHouseLevel > 1 then
    Proc_ShowMessage_Ack(PAGetStringParam3(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_ONCHANGE_END_1", "house_name", tostring(houseName), "typeName", useType_Name, "typeLevel", currentHouseLevel))
  elseif currentHouseLevel == 1 then
    Proc_ShowMessage_Ack(PAGetStringParam2(Defines.StringSheet_GAME, "LUA_HOUSECONTROL_ONCHANGE_END_2", "house_name", tostring(houseName), "typeName", useType_Name))
  end
end
function FGlobal_FilterClear()
  temp_houseEffectArray = Array.new()
end
function FGlobal_FilterEffectClear()
  for idx = 1, temp_houseEffectArray:length() do
    temp_houseEffectArray[idx]:EraseAllEffect()
  end
  FGlobal_FilterClear()
end
local houseEffectArray_Key = 0
function FromClient_HouseFilterOn(house_btn)
  local btn = house_btn
  btn:AddEffect("UI_ArrowMark_Diagonal01", true, 70, 80)
  temp_houseEffectArray:push_back(btn)
end
function FromClient_HouseFilterOnByHouse(house_btn)
  local btn = house_btn
  btn:AddEffect("UI_ArrowMark_Diagonal01", true, 70, 80)
  temp_houseEffectArray:push_back(btn)
end
registerEvent("FromClient_SetHouseTexture", "FGlobal_HouseHoldButtonSetBaseTexture")
registerEvent("FromClient_AppliedChangeUseType", "FromClient_AppliedChangeUseType_Ack")
if false == _ContentsGroup_RenewUI_WorldMap then
  registerEvent("FromClient_RClickedWorldMapHouse", "FromClient_RClickedWorldMapHouse")
  registerEvent("FromClient_LClickedWorldMapHouse", "FromClient_LClickedWorldMapHouse")
  registerEvent("FromClient_HouseFilterOn", "FromClient_HouseFilterOn")
  registerEvent("FromClient_HouseFilterOnByHouse", "FromClient_HouseFilterOnByHouse")
end

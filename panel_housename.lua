local UI_color = Defines.Color
Panel_HouseName:SetShow(false)
Panel_HouseName:SetIgnore(true)
Panel_HouseName:RegisterShowEventFunc(true, "Panel_HouseName_ShowAni()")
Panel_HouseName:RegisterShowEventFunc(false, "Panel_HouseName_HideAni()")
local ui = {
  _houseName = UI.getChildControl(Panel_HouseName, "StaticText_HouseName"),
  _hosueIcon = UI.getChildControl(Panel_HouseName, "Static_HouseIcon"),
  _btnInstallationMode = UI.getChildControl(Panel_HouseName, "Button_Install"),
  _btnNoticeLighting = UI.getChildControl(Panel_HouseName, "StaticText_NoticeLighting"),
  _btnInstallGift = UI.getChildControl(Panel_HouseName, "Button_InstallGift"),
  _btnShowRank = UI.getChildControl(Panel_HouseName, "Button_ShowRank"),
  _btnScreenShot = UI.getChildControl(Panel_HouseName, "Button_Capture"),
  _btnSetUnderWear = UI.getChildControl(Panel_HouseName, "Button_SetUnderwear"),
  _btnToggleHideMaid = UI.getChildControl(Panel_HouseName, "Button_ToggleHideMaid"),
  _btnToggleHidePet = UI.getChildControl(Panel_HouseName, "Button_ToggleHidePet"),
  _btnFurnitureWarehouse = UI.getChildControl(Panel_HouseName, "Button_FurnitureWarehouse")
}
ui._btnSetUnderWear:addInputEvent("Mouse_LUp", "HandleClicked_SetShowUnderWearToggle()")
ui._btnSetUnderWear:addInputEvent("Mouse_On", "HouseName_ButtonTooltip( true, " .. 0 .. " )")
ui._btnSetUnderWear:addInputEvent("Mouse_Out", "HouseName_ButtonTooltip( false )")
ui._btnToggleHideMaid:addInputEvent("Mouse_LUp", "HandleClicked_ToggleHideMaidToggle()")
ui._btnToggleHideMaid:addInputEvent("Mouse_On", "HouseName_ButtonTooltip( true, " .. 5 .. " )")
ui._btnToggleHideMaid:addInputEvent("Mouse_Out", "HouseName_ButtonTooltip( false )")
ui._btnToggleHidePet:addInputEvent("Mouse_LUp", "HandleClicked_ToggleHidePet()")
ui._btnToggleHidePet:addInputEvent("Mouse_On", "HouseName_ButtonTooltip( true, " .. 4 .. " )")
ui._btnToggleHidePet:addInputEvent("Mouse_Out", "HouseName_ButtonTooltip( false )")
ui._btnInstallationMode:addInputEvent("Mouse_LUp", "HouseName_Click_InstallationMode()")
ui._btnInstallationMode:addInputEvent("Mouse_On", "HouseName_ButtonTooltip( true, " .. 1 .. " )")
ui._btnInstallationMode:addInputEvent("Mouse_Out", "HouseName_ButtonTooltip( false )")
ui._btnInstallationMode:SetShow(false)
ui._btnInstallGift:addInputEvent("Mouse_LUp", "HouseName_Click_InstallationMode()")
ui._btnInstallGift:addInputEvent("Mouse_On", "HouseName_ButtonTooltip( true, " .. 3 .. " )")
ui._btnInstallGift:addInputEvent("Mouse_Out", "HouseName_ButtonTooltip( false )")
ui._btnInstallGift:SetShow(false)
ui._btnShowRank:addInputEvent("Mouse_LUp", "Housename_Click_ShowRank()")
ui._btnShowRank:addInputEvent("Mouse_On", "HouseName_ButtonTooltip( true, " .. 2 .. " )")
ui._btnShowRank:addInputEvent("Mouse_Out", "HouseName_ButtonTooltip( false )")
ui._btnShowRank:SetShow(false)
ui._btnFurnitureWarehouse:addInputEvent("Mouse_LUp", "HouseName_Click_FurnitureWarehouse()")
ui._btnFurnitureWarehouse:addInputEvent("Mouse_On", "HouseName_ButtonTooltip( true, " .. 6 .. " )")
ui._btnFurnitureWarehouse:addInputEvent("Mouse_Out", "HouseName_ButtonTooltip( false )")
ui._btnFurnitureWarehouse:SetShow(false)
ui._btnSetUnderWear:setTooltipEventRegistFunc("HouseName_ButtonTooltip( true, " .. 0 .. " )")
ui._btnInstallationMode:setTooltipEventRegistFunc("HouseName_ButtonTooltip( true, " .. 1 .. " )")
ui._btnInstallGift:setTooltipEventRegistFunc("HouseName_ButtonTooltip( true, " .. 3 .. " )")
ui._btnShowRank:setTooltipEventRegistFunc("HouseName_ButtonTooltip( true, " .. 2 .. " )")
ui._btnScreenShot:addInputEvent("Mouse_LUp", "")
ui._btnScreenShot:SetShow(false)
local _isMyHouse = false
local updateTime = 0
local isAlertHouseLighting = false
local prevPoint = 0
function PaGlobal_GetHouseNamePoint()
  return prevPoint
end
function HouseName_ButtonTooltip(isShow, buttonNo)
  local control, name, desc
  if 0 == buttonNo then
    control = ui._btnSetUnderWear
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSINGNAME_TOOLTIP_TITLE_UNDERWEAR")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSINGNAME_TOOLTIP_DESC_UNDERWEAR")
  elseif 1 == buttonNo then
    control = ui._btnInstallationMode
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSINGNAME_TOOLTIP_TITLE_INSTALLATIONMODE")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSINGNAME_TOOLTIP_DESC_INSTALLATIONMODE")
  elseif 2 == buttonNo then
    control = ui._btnShowRank
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSINGNAME_TOOLTIP_TITLE_SHOWRANK")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSINGNAME_TOOLTIP_DESC_SHOWRANK")
  elseif 3 == buttonNo then
    control = ui._btnInstallGift
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSINGNAME_TOOLTIP_TITLE_INSTALLGIFT")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSINGNAME_TOOLTIP_DESC_INSTALLGIFT")
  elseif 4 == buttonNo then
    control = ui._btnToggleHidePet
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSENAME_PET_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSENAME_PET_TOOLTIP_DESC")
  elseif 5 == buttonNo then
    control = ui._btnToggleHideMaid
    name = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSENAME_MAID_TOOLTIP_NAME")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSENAME_MAID_TOOLTIP_DESC")
  elseif 6 == buttonNo then
    return
  end
  if true == isShow then
    registTooltipControl(control, Panel_Tooltip_SimpleText)
    TooltipSimple_Show(control, name, desc)
  else
    TooltipSimple_Hide()
  end
end
function HouseName_Click_InstallationMode()
  if getInputMode() == CppEnums.EProcessorInputMode.eProcessorInputMode_ChattingInputMode then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_NOT_ENTER_HOUSINGMODE_CHATMODE"))
    return
  end
  HouseName_ButtonTooltip(false)
  FGlobal_House_InstallationMode_Open()
  local isShow = housing_getIsHideMaidActors()
end
function Housename_Click_ShowRank()
  toClient_RequestHouseRankerList()
end
function HouseName_Click_FurnitureWarehouse()
  if false == Panel_Window_Warehouse:GetShow() then
    ToClient_RequestFurnitureWarehouseInfo()
  else
    Warehouse_Close()
  end
end
function HandleClicked_LetsWorkerParty()
  local currentWayPointKey = getCurrentWaypointKey()
  local plantKey = ToClient_convertWaypointKeyToPlantKey(currentWayPointKey)
  local workerCount = ToClient_getPlantWaitWorkerListCount(plantKey, 0)
  if workerCount > 0 then
    local houseWrapper = housing_getHouseholdActor_CurrentPosition()
    if nil ~= houseWrapper then
      local characterKeyRaw = houseWrapper:getStaticStatusWrapper():getCharacterKey()
      local housePlantKey = PlantKey()
      housePlantKey:setHouseKeyRaw(characterKeyRaw)
      ToClient_requestStartHousePartyAll(housePlantKey)
    end
  end
end
function HandleClicked_SetShowUnderWearToggle()
  if not IsSelfPlayerWaitAction() or IsSelfPlayerBattleWaitAction() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CURRENTACTION_NOT_UNDERWEAR"))
    if ui._btnSetUnderWear:IsCheck() then
      ui._btnSetUnderWear:SetCheck(false)
    elseif false == ToClient_isAdultUser() then
      ui._btnSetUnderWear:SetCheck(false)
    else
      ui._btnSetUnderWear:SetCheck(true)
    end
    return
  end
  local selfPlayer = getSelfPlayer()
  if nil == selfPlayer then
    return
  end
  if selfPlayer:get():getUnderwearModeInhouse() then
    selfPlayer:get():setUnderwearModeInhouse(false)
    Toclient_setShowAvatarEquip()
  else
    selfPlayer:get():setUnderwearModeInhouse(true)
  end
end
function HandleClicked_ToggleHideMaidToggle()
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  local isHide = housing_getIsHideMaidActors()
  if nil ~= houseWrapper then
    if true == isHide then
      housing_setHideMaidInHouse(false)
    elseif false == isHide then
      housing_setHideMaidInHouse(true)
    end
  end
end
function HandleClicked_ToggleHidePet()
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  local isHide = housing_getIsHidePetActors()
  if nil ~= houseWrapper then
    if true == isHide then
      housing_setHidePetInHouse(false)
    elseif false == isHide then
      housing_setHidePetInHouse(true)
    end
  end
end
function FromClient_ChangeUnderwearModeInHouse(isUnderwearModeInHouse)
  if false == ToClient_isAdultUser() then
    ui._btnSetUnderWear:SetCheck(false)
  else
    ui._btnSetUnderWear:SetCheck(isUnderwearModeInHouse)
  end
end
function Panel_HouseName_ShowAni()
  UIAni.AlphaAnimation(1, Panel_HouseName, 0, 1)
end
function Panel_HouseName_HideAni()
  local aniInfo = UIAni.AlphaAnimation(0, Panel_HouseName, 0, 0.35)
  aniInfo:SetHideAtEnd(true)
end
function Panel_HouseName_Resize()
  Panel_HouseName:SetPosX(getScreenSizeX() / 2 - Panel_HouseName:GetSizeX() / 2)
end
function EventHousingShowVisitHouse(isShow, houseName, userNickname, point, isMine)
  _PA_LOG("\236\167\128\235\175\188\237\152\129", "EventHousingShowVisitHouse : " .. tostring(point))
  prevPoint = point
  local isShowUnderwear = getSelfPlayer():get():getUnderwearModeInhouse()
  if false == ToClient_isAdultUser() then
    ui._btnSetUnderWear:SetCheck(false)
    ui._btnSetUnderWear:SetShow(false)
    ui._btnSetUnderWear:SetIgnore(true)
  else
    ui._btnSetUnderWear:SetCheck(isShowUnderwear)
  end
  local isPet = housing_getIsHidePetActors()
  local isMaid = housing_getIsHideMaidActors()
  ui._btnToggleHidePet:SetCheck(isPet)
  ui._btnToggleHideMaid:SetCheck(isMaid)
  local houseWrapper = housing_getHouseholdActor_CurrentPosition()
  if nil == houseWrapper then
    Panel_HouseName:SetShow(false, false)
    FGlobal_AlertHouseLightingReset()
    ui._btnNoticeLighting:SetShow(false)
    return
  end
  _isMyHouse = isMine
  local isInnRoom = houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isInnRoom()
  local isFixedHouse = houseWrapper:getStaticStatusWrapper():getObjectStaticStatus():isFixedHouse()
  if isFixedHouse then
    ui._btnShowRank:SetShow(false)
    ui._btnInstallationMode:SetShow(false)
    ui._btnInstallGift:SetShow(false)
    ui._btnFurnitureWarehouse:SetShow(false)
    return
  elseif isInnRoom then
    ui._btnShowRank:SetShow(false)
    if isMine then
      ui._btnInstallationMode:SetShow(true)
      ui._btnInstallGift:SetShow(false)
      if true == _ContentsGroup_isFurnitureWarehouse then
        ui._btnFurnitureWarehouse:SetShow(true)
      else
        ui._btnFurnitureWarehouse:SetShow(false)
      end
    else
      ui._btnInstallationMode:SetShow(false)
      ui._btnFurnitureWarehouse:SetShow(false)
      if FGlobal_IsCommercialService() then
        ui._btnInstallGift:SetShow(true)
      else
        ui._btnInstallGift:SetShow(false)
      end
    end
  else
    ui._btnShowRank:SetShow(false)
    ui._btnInstallationMode:SetShow(false)
    ui._btnInstallGift:SetShow(false)
    ui._btnFurnitureWarehouse:SetShow(false)
  end
  local desc = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSING_HOUSENAME_LIVING", "user_nickname", userNickname) .. "( " .. houseName .. " ) " .. tostring(point)
  ui._houseName:SetText(desc)
  if Panel_Housing:IsShow() then
    return
  end
  if Panel_House_InstallationMode:GetShow() then
    return
  end
  if Panel_Interaction_HouseRank:GetShow() then
    Panel_Interaction_HouseRanke_Close()
  end
  if isGameTypeKR2() then
    ui._btnSetUnderWear:SetShow(false)
  end
  Panel_HouseName:SetShow(isShow, true)
end
function EventHousingShowChangeTopRanker(houseName, userNo, userNickname, point)
end
function HouseLightingCheck(deltaTime)
  updateTime = updateTime + deltaTime
  if false == isAlertHouseLighting and 5 == math.ceil(updateTime) then
    local houseWrapper = housing_getHouseholdActor_CurrentPosition()
    local isHaveLightInstallation = houseWrapper:isHaveLightInstallation()
    if true == isHaveLightInstallation then
      ui._btnNoticeLighting:SetShow(false)
    else
      ui._btnNoticeLighting:SetShow(true)
    end
    isAlertHouseLighting = true
  end
end
function FGlobal_AlertHouseLightingReset()
  updateTime = 0
  isAlertHouseLighting = false
end
function Panel_HouseName_CheckHouse(prevRenderModeList, nextRenderModeList)
  if CheckRenderModebyGameMode(nextRenderModeList) == false then
    return
  end
  if Panel_HouseName:GetShow() then
    local houseWrapper = housing_getHouseholdActor_CurrentPosition()
    if nil == houseWrapper then
      Panel_HouseName:SetShow(false, false)
    end
  end
end
function InitializeModeClose_PetMaidInit()
  local isPet = housing_getIsHidePetActors()
  local isMaid = housing_getIsHideMaidActors()
  ui._btnToggleHidePet:SetCheck(isPet)
  ui._btnToggleHideMaid:SetCheck(isMaid)
end
registerEvent("FromClient_RenderModeChangeState", "Panel_HouseName_CheckHouse")
registerEvent("EventHousingShowVisitHouse", "EventHousingShowVisitHouse")
registerEvent("FromClient_ChangeUnderwearModeInHouse", "FromClient_ChangeUnderwearModeInHouse")
registerEvent("EventHousingShowChangeTopRanker", "EventHousingShowChangeTopRanker")
registerEvent("onScreenResize", "Panel_HouseName_Resize")
Panel_HouseName:RegisterUpdateFunc("HouseLightingCheck")

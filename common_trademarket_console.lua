gDialogSceneIndex = {
  [enCommerceType.enCommerceType_Luxury_Miscellaneous] = 8,
  [enCommerceType.enCommerceType_Luxury] = 7,
  [enCommerceType.enCommerceType_Grocery] = 5,
  [enCommerceType.enCommerceType_Cloth] = 10,
  [enCommerceType.enCommerceType_ObjectSaint] = 11,
  [enCommerceType.enCommerceType_MilitarySupplies] = 12,
  [enCommerceType.enCommerceType_Medicine] = 6,
  [enCommerceType.enCommerceType_SeaFood] = 14,
  [enCommerceType.enCommerceType_RawMaterial] = 13,
  [enCommerceType.enCommerceType_Max] = 0
}
global_IsTrading = false
function global_setTrading(istrading)
  global_IsTrading = istrading
end
function PaGlobal_GetIsTrading()
  return global_IsTrading
end
function PaGlobal_TradeMarket_OpenTradeMarket()
  if true == PaGlobal_DialogMain_GetAlreadyClose() then
    return
  end
  if false == PaGlobal_GetIsTrading() then
    local npcKey = dialog_getTalkNpcKey()
    if 0 ~= npcKey then
      openClientChangeScene(npcKey, 1)
    end
    PaGlobal_BiddingGame_ResetSuccess()
    SetUIMode(Defines.UIMode.eUIMode_Trade)
    PaGlobalFunc_MainDialog_CloseMoment()
    global_setTrading(true)
    cutSceneCameraWaveMode(false)
    isNearActorEdgeShow(false)
    PaGlobalFunc_TradeMarketIn_Open()
  end
  FGlobal_RemoteControl_Show(2)
end
function PaGlobal_TradeMarket_CloseTradeMarket()
  if Panel_Win_System:GetShow() then
    Proc_ShowMessage_Ack("\236\149\140\235\166\188\236\176\189\236\157\132 \235\168\188\236\160\128 \235\139\171\236\149\132\236\163\188\236\132\184\236\154\148.")
    return
  end
  PaGlobal_BiddingGame_ResetSuccess()
  Fglobal_TradeGame_Close()
  SetUIMode(Defines.UIMode.eUIMode_NpcDialog)
  PaGlobalFunc_MainDialog_setIgnoreShowDialog(false)
  InventoryWindow_Close()
  Panel_Tooltip_Item_hideTooltip()
  PaGlobalFunc_MainDialog_ReOpen(false)
  PaGlobalFunc_TradeMarketIn_Close()
  PaGlobal_TradeMarketBasket_Close()
  PaGlobal_TradeMarketGoods_Close()
  PaGlobal_TradeMarketGraph_Close()
  cutSceneCameraWaveMode(true)
  isNearActorEdgeShow(true)
  global_setTrading(false)
  local npcKey = dialog_getTalkNpcKey()
  if 0 ~= npcKey then
    closeClientChangeScene(npcKey)
  else
    UI.ASSERT("PaGlobal_TradeMarket_CloseTradeMarket : NPC Key \236\132\164\236\160\149\236\157\180 \235\144\152\236\150\180\236\158\136\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!!")
  end
end
function PaGlobal_TradeMarket_CheckServant()
  local myLandVehicle = getTemporaryInformationWrapper()
  local servantInfoWrapper = myLandVehicle:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle)
  if true == ToClient_IsDevelopment() then
  end
  if nil ~= servantInfoWrapper then
    local myLandVehicleActorKey = servantInfoWrapper:getActorKeyRaw()
    if nil ~= myLandVehicleActorKey then
      local landVehicleActorProxy = getActor(myLandVehicleActorKey)
      local selfProxy = getSelfPlayer()
      if nil ~= landVehicleActorProxy then
        local isAbleDistance = getDistanceFromVehicle()
        if true == ToClient_IsDevelopment() then
        end
        if true == isAbleDistance then
          local vehicleInventory = servantInfoWrapper:getInventory()
          local maxInventorySlot = vehicleInventory:size() - 2
          local freeInventorySlot = maxInventorySlot - vehicleInventory:getFreeCount()
          local myLandVehicleActorKey = myLandVehicle:getUnsealVehicle(false):getActorKeyRaw()
          local servantWrapper = myLandVehicle:getUnsealVehicleByActorKeyRaw(myLandVehicleActorKey)
          local max_weight = servantWrapper:getMaxWeight_s64()
          local total_weight = servantWrapper:getInventoryWeight_s64() + servantWrapper:getEquipWeight_s64() + servantWrapper:getMoneyWeight_s64()
          local vehicleRemainWeightValue = max_weight - total_weight
          return true, maxInventorySlot, freeInventorySlot, vehicleRemainWeightValue
        else
          return false, 0, 0
        end
      else
        return nil, 0, 0
      end
    else
      return nil, 0, 0
    end
  else
    return nil, 0, 0
  end
end
function PaGlobal_TradeMarket_init()
  registerEvent("EventNpcTradeShopUpdate", "PaGlobal_TradeMarket_OpenTradeMarket")
end
registerEvent("FromClient_luaLoadComplete", "PaGlobal_TradeMarket_init")
function closeNpcTrade_Basket()
  PaGlobal_TradeMarket_CloseTradeMarket()
end
function Fglobal_TradeGame_Close()
  PaGlobal_BiddingGame_Close()
end
function InitNpcTradeShopOpen()
  PaGlobal_TradeMarket_OpenTradeMarket()
end
function global_buyListExit()
end
function global_tradeSellListExit()
end
function check_Servant()
  PaGlobal_TradeMarket_CheckServant()
end

local _panel = Panel_Window_MarketPlaceWallet
local MarketWallet = {_moneySlot = 0, _isOpen = false}
function MarketWallet:init()
  self._moneySlot = getMoneySlotNo()
  self:registEvent()
end
function MarketWallet:registEvent()
  registerEvent("FromClient_requestMyWalletList", "FromClient_MarketPlace_RequestMyWalletList")
  registerEvent("FromClient_requestPush", "FromClient_MarketPlace_RequestPush")
  registerEvent("FromClient_requestPop", "FromClient_MarketPlace_RequestPop")
end
function MarketWallet:open()
  PaGlobalFunc_MarketPlace_MyInven_Update()
  ToClient_requestMyWalletList()
  PaGlobalFunc_MarketPlace_MyInven_Open()
  PaGlobalFunc_MarketPlace_WalletInven_Open()
  self._isOpen = true
end
function MarketWallet:close()
  PaGlobalFunc_MarketPlace_MyInven_Close()
  PaGlobalFunc_MarketPlace_WalletInven_Close()
  Panel_Tooltip_Item_hideTooltip()
  self._isOpen = false
end
function PaGlobalFunc_MarketWallet_GetShow()
  return true == PaGlobalFunc_MarketPlace_WalletInven_GetShow() or true == PaGlobalFunc_MarketPlace_MyInven_GetShow()
end
function PaGlobalFunc_MarketWallet_Init()
  local self = MarketWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketWallet")
    return
  end
  self:init()
end
function PaGlobalFunc_MarketWallet_Open()
  local self = MarketWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketWallet")
    return
  end
  ToClient_requestMyWalletList()
  self:open()
end
function PaGlobalFunc_MarketWallet_ForceClose()
  local self = MarketWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketWallet")
    return
  end
  self:close()
end
function PaGlobalFunc_MarketWallet_Close()
  local self = MarketWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketWallet")
    return
  end
  if true == PaGlobalFunc_MarketPlace_IsOpenByMaid() then
    PaGlobalFunc_MarketPlace_CloseFromMaid()
    return
  end
  self:close()
end
function InputMRUp_MarketWallet_RegisterMoney()
  local self = MarketWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketWallet")
    return
  end
  local money = Defines.s64_const.s64_0
  if false == PaGlobalFunc_MarketPlace_GetWareHouseCheck() then
    local moneyItemWrapper = getInventoryItemByType(CppEnums.ItemWhereType.eInventory, self._moneySlot)
    if nil ~= moneyItemWrapper then
      money = moneyItemWrapper:get():getCount_s64()
    end
  elseif true == PaGlobalFunc_MarketPlace_IsOpenByMaid() then
    money = PaGlobalFunc_MarketPlace_GetWareHouseMoneyFromMaid()
  else
    money = warehouse_moneyFromNpcShop_s64()
  end
  Panel_NumberPad_Show(true, money, self._moneySlot, InputMRUp_MarketWallet_Register)
end
function InputMRUp_MarketWallet_WithdrawMoney()
  local self = MarketWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketWallet")
    return
  end
  local itemMysilverInfo = getWorldMarketSilverInfo()
  local itemCount = itemMysilverInfo:getItemCount()
  local itemEnchantKey = itemMysilverInfo:getEnchantKey()
  local function applyWithdraw(selectedButtonIndex)
    Panel_NumberPad_Show(true, itemCount, itemEnchantKey, InputMRUp_MarketWallet_Withdraw, false, nil, false, selectedButtonIndex)
  end
  MessageBoxCheck.showMessageBox({
    title = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_CONSIGN_BTN_GETMONEY"),
    content = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MARKET_PLACE_MOVE_SILVER_TARGET"),
    functionApply = applyWithdraw,
    functionCancel = MessageBox_Empty_function,
    buttonStrings = {
      PAGetString(Defines.StringSheet_GAME, "LUA_ITEMMARKET_TOOLTIP_INVEN_NAME"),
      PAGetString(Defines.StringSheet_GAME, "DIALOG_BUTTON_WAREHOUSE")
    },
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  })
end
function InputMRUp_MarketWallet_MoveInvenToWallet(slotNo)
  local self = MarketWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketWallet")
    return
  end
  local itemCount = Defines.s64_const.s64_0
  local itemWrapper = getInventoryItemByType(PaGlobalFunc_MarketPlace_GetMyInvenTab(), slotNo)
  if nil == itemWrapper then
    return
  end
  local function excute()
    local isStackable = itemWrapper:getStaticStatus():isStackable()
    if false == isStackable then
      InputMRUp_MarketWallet_Register(1, slotNo)
      return
    end
    itemCount = itemWrapper:get():getCount_s64()
    if slotNo ~= self._moneySlot and true == PaGlobalFunc_MarketPlace_IsOpenByMaid() then
      local weight = itemWrapper:getStaticStatus():getWorldMarketVolume()
      if toInt64(0, 0) ~= weight then
        local maxCountByWeight = toInt64(0, __eTWorldTradeMarketMaxVolumeByMaid) / weight
        if maxCountByWeight < itemCount then
          itemCount = maxCountByWeight
        end
      end
    end
    Panel_NumberPad_Show(true, itemCount, slotNo, InputMRUp_MarketWallet_Register)
  end
  if true == self:warringCheck(itemWrapper) then
    local messageBoxTitle = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS")
    local messageBoxMemo = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WARRING_REGISTITEM")
    local messageBoxData = {
      title = messageBoxTitle,
      content = messageBoxMemo,
      functionYes = excute,
      functionNo = MessageBox_Empty_function,
      priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageBoxData, "middle")
  else
    excute()
  end
end
function MarketWallet:warringCheck(itemWrapper)
  local itemSSW = itemWrapper:getStaticStatus()
  local dyeAble = itemSSW:isDyeable()
  if true == dyeAble then
    local dyeingPartCount = itemWrapper:getDyeingPartCount()
    for dyeingPart_Index = 0, dyeingPartCount - 1 do
      local bEmpty = itemWrapper:isEmptyDyeingPartColorAt(dyeingPart_Index)
      if not itemWrapper:isAllreadyDyeingSlot(dyeingPart_Index) then
        bEmpty = true
      end
      if false == bEmpty then
        return true
      end
    end
  end
  return false
end
function InputMRUp_MarketWallet_MoveWalletToInven(slotIdx)
  local self = MarketWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketWallet")
    return
  end
  local itemMyWalletInfo = getWorldMarketMyWalletListByIdx(slotIdx)
  local itemCount = 0
  local itemEnchantKey = itemMyWalletInfo:getEnchantKey()
  local isSealed = itemMyWalletInfo:isSealed()
  local itemSSW = itemMyWalletInfo:getItemEnchantStaticStatusWrapper()
  if nil == itemSSW then
    return
  end
  local isStackable = itemSSW:isStackable()
  if false == isStackable then
    InputMRUp_MarketWallet_Withdraw(1, itemEnchantKey, isSealed)
    return
  end
  itemCount = itemMyWalletInfo:getItemCount()
  if slotIdx ~= self._moneySlot and true == PaGlobalFunc_MarketPlace_IsOpenByMaid() then
    local weight = itemSSW:getWorldMarketVolume()
    if toInt64(0, 0) ~= weight then
      local maxCountByWeight = toInt64(0, __eTWorldTradeMarketMaxVolumeByMaid) / weight
      if itemCount > maxCountByWeight then
        itemCount = maxCountByWeight
      end
    end
  end
  Panel_NumberPad_Show(true, itemCount, itemEnchantKey, InputMRUp_MarketWallet_Withdraw, isSealed)
end
function InputMRUp_MarketWallet_Register(inputNumber, slotNo)
  local self = MarketWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketWallet")
    return
  end
  local fromWhereType = CppEnums.ItemWhereType.eInventory
  if slotNo ~= self._moneySlot then
    fromWhereType = PaGlobalFunc_MarketPlace_GetMyInvenTab()
  end
  if true == PaGlobalFunc_MarketPlace_GetWareHouseCheck() and slotNo == self._moneySlot then
    fromWhereType = CppEnums.ItemWhereType.eWarehouse
  end
  requestMoveItemInventoryToWallet(fromWhereType, slotNo, inputNumber, PaGlobalFunc_MarketPlace_IsOpenByMaid())
  PaGlobalFunc_FloatingTooltip_Close()
end
function InputMRUp_MarketWallet_Withdraw(inputNumber, itemEnchantKey, isSealed, toWhere)
  local self = MarketWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketWallet")
    return
  end
  if 1 == toWhere then
    requestMoveItemWalletToInventory(itemEnchantKey, inputNumber, isSealed, CppEnums.ItemWhereType.eInventory, PaGlobalFunc_MarketPlace_IsOpenByMaid())
  elseif 2 == toWhere then
    requestMoveItemWalletToInventory(itemEnchantKey, inputNumber, isSealed, CppEnums.ItemWhereType.eWarehouse, PaGlobalFunc_MarketPlace_IsOpenByMaid())
  else
    requestMoveItemWalletToInventory(itemEnchantKey, inputNumber, isSealed, CppEnums.ItemWhereType.eInventory, PaGlobalFunc_MarketPlace_IsOpenByMaid())
  end
  PaGlobalFunc_FloatingTooltip_Close()
end
function FromClient_MarketPlace_RequestMyWalletList()
  PaGlobalFunc_MarketPlace_UpdateWalletInfo()
  PaGlobalFunc_MarketPlace_UpdateWalletList()
  local self = MarketWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketWallet")
    return
  end
  PaGlobalFunc_MarketPlace_WalletInven_Update()
end
function FromClient_MarketPlace_RequestPush()
  PaGlobalFunc_MarketPlace_UpdateWalletInfo()
  local self = MarketWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketWallet")
    return
  end
  if true == self._isOpen and false == PaGlobalFunc_MarketPlace_WalletInven_GetShow() then
    PaGlobalFunc_MarketPlace_WalletInven_Open()
  end
  PaGlobalFunc_MarketPlace_WalletInven_Update()
  PaGlobalFunc_MarketPlace_MyInven_Update()
  local msg = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_REGISTITEM")
  Proc_ShowMessage_Ack(msg)
end
function FromClient_MarketPlace_RequestPop()
  PaGlobalFunc_MarketPlace_UpdateWalletInfo()
  local self = MarketWallet
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketWallet")
    return
  end
  if true == self._isOpen and false == PaGlobalFunc_MarketPlace_MyInven_GetShow() then
    PaGlobalFunc_MarketPlace_MyInven_Open()
  end
  PaGlobalFunc_MarketPlace_WalletInven_Update()
  PaGlobalFunc_MarketPlace_MyInven_Update()
  local msg = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WITHDRAWITEM")
  Proc_ShowMessage_Ack(msg)
end
function PaGlobalFunc_MarketPlace_GetWareHouseMoneyFromMaid()
  local regionInfo = getRegionInfoByPosition(getSelfPlayer():get():getPosition())
  if nil == regionInfo then
    return
  end
  local myAffiliatedTownRegionKey = regionInfo:getAffiliatedTownRegionKey()
  local regionInfoWrapper = getRegionInfoWrapper(myAffiliatedTownRegionKey)
  if ToClient_IsAccessibleRegionKey(regionInfo:getAffiliatedTownRegionKey()) == false then
    local plantWayKey = ToClient_GetOtherRegionKey_NeerByTownRegionKey()
    local newRegionInfo = ToClient_getRegionInfoWrapperByWaypoint(plantWayKey)
    if newRegionInfo == nil then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CANTFIND_WAREHOUSE_INTERRITORY"))
      return
    end
    myAffiliatedTownRegionKey = newRegionInfo:getRegionKey()
    if 0 == myAffiliatedTownRegionKey then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_CANTFIND_WAREHOUSE_INTERRITORY"))
      return
    end
  end
  return warehouse_moneyFromRegionKey_s64(myAffiliatedTownRegionKey)
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_MarketWallet_Init")

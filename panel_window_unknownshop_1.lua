function PaGlobal_UnknownShop:initialize()
  if true == PaGlobal_UnknownShop._initialize then
    return
  end
  Panel_UnknownShop:ignorePadSnapMoveToOtherPanel()
  local centerBG = UI.getChildControl(Panel_UnknownShop, "Static_CenterBg")
  PaGlobal_UnknownShop._ui.stc_slotBG = UI.getChildControl(centerBG, "Static_Slot")
  PaGlobal_UnknownShop._ui.txt_itemName = UI.getChildControl(centerBG, "StaticText_ItemName")
  PaGlobal_UnknownShop._ui.txt_moneyValue = UI.getChildControl(centerBG, "StaticText_Money")
  PaGlobal_UnknownShop._ui.txt_reserveTime = UI.getChildControl(centerBG, "StaticText_ReservTime")
  PaGlobal_UnknownShop._ui.stc_showAni = UI.getChildControl(centerBG, "Static_SequenceShowAni")
  PaGlobal_UnknownShop._ui.stc_KeyguideBG = UI.getChildControl(Panel_UnknownShop, "Static_BottomBg")
  PaGlobal_UnknownShop._ui.stc_keyGuideDetail = UI.getChildControl(PaGlobal_UnknownShop._ui.stc_KeyguideBG, "StaticText_ViewDetail")
  PaGlobal_UnknownShop._ui.stc_keyGuideReselect = UI.getChildControl(PaGlobal_UnknownShop._ui.stc_KeyguideBG, "StaticText_ViewAnotherItem")
  PaGlobal_UnknownShop._ui.stc_keyGuideReserve = UI.getChildControl(PaGlobal_UnknownShop._ui.stc_KeyguideBG, "StaticText_Reserve")
  PaGlobal_UnknownShop._ui.stc_keyGuidePurchase = UI.getChildControl(PaGlobal_UnknownShop._ui.stc_KeyguideBG, "StaticText_Purchase")
  PaGlobal_UnknownShop._ui.stc_keyGuideClose = UI.getChildControl(PaGlobal_UnknownShop._ui.stc_KeyguideBG, "StaticText_Close")
  PaGlobal_UnknownShop._keyGuideAlign = {
    PaGlobal_UnknownShop._ui.stc_keyGuideDetail,
    PaGlobal_UnknownShop._ui.stc_keyGuideReselect,
    PaGlobal_UnknownShop._ui.stc_keyGuideReserve,
    PaGlobal_UnknownShop._ui.stc_keyGuidePurchase,
    PaGlobal_UnknownShop._ui.stc_keyGuideClose
  }
  PaGlobal_UnknownShop:registEventHandler()
  PaGlobal_UnknownShop:validate()
  PaGlobal_UnknownShop._initialize = true
end
function PaGlobal_UnknownShop:registEventHandler()
  if nil == Panel_UnknownShop then
    return
  end
  Panel_UnknownShop:registerPadEvent(__eConsoleUIPadEvent_Up_A, "HandleEventAUp_UnknownShop_BuyItem()")
  Panel_UnknownShop:registerPadEvent(__eConsoleUIPadEvent_Up_Y, "HandleEventYUp_UnknownShop_ReselectItem()")
  if true == PaGlobal_UnknownShop._isReserveContentOpen then
    registerEvent("FromClient_UpdateRandomShopKeepTime", "FromClient_UpdateRandomShopKeepTime")
  end
  registerEvent("FromClient_NotifyRandomShop", "FromClient_UnknownShop_NotifyMessage")
  registerEvent("FromClient_EventRandomShopShow", "FromClient_UnknownShop_Open")
end
function PaGlobal_UnknownShop:prepareOpen(slotNo, priceRate)
  if nil == Panel_UnknownShop then
    return
  end
  if false == PaGlobalFunc_MainDialog_GetShow() then
    PaGlobal_UnknownShop:prepareClose()
    return
  end
  PaGlobal_UnknownShop._shopSlotNo = slotNo
  PaGlobal_UnknownShop._priceRate = priceRate
  PaGlobal_UnknownShop:initUnknownShopItem(slotNo, priceRate)
  PaGlobal_UnknownShop:checkReserveCondition()
  PaGlobal_UnknownShop:checkReselectCondition()
  PaGlobalFunc_ConsoleKeyGuide_SetAlign(PaGlobal_UnknownShop._keyGuideAlign, PaGlobal_UnknownShop._ui.stc_KeyguideBG, CONSOLEKEYGUID_ALIGN_TYPE.eALIGN_TYPE_RIGHT)
  PaGlobal_UnknownShop:open()
end
function PaGlobal_UnknownShop:open()
  if nil == Panel_UnknownShop then
    return
  end
  Panel_UnknownShop:SetShow(true)
end
function PaGlobal_UnknownShop:prepareClose()
  if nil == Panel_UnknownShop then
    return
  end
  PaGlobal_UnknownShop._shopTypeNo = nil
  PaGlobal_UnknownShop._shopSlotNo = nil
  PaGlobal_UnknownShop._shopItemPrice = nil
  PaGlobal_UnknownShop._priceRate = nil
  PaGlobalFunc_TooltipInfo_Close()
  PaGlobal_UnknownShop:close()
end
function PaGlobal_UnknownShop:close()
  if nil == Panel_UnknownShop then
    return
  end
  Panel_UnknownShop:SetShow(false)
end
function PaGlobal_UnknownShop:validate()
  if nil == Panel_UnknownShop then
    return
  end
  PaGlobal_UnknownShop._ui.stc_slotBG:isValidate()
  PaGlobal_UnknownShop._ui.txt_itemName:isValidate()
  PaGlobal_UnknownShop._ui.txt_moneyValue:isValidate()
  PaGlobal_UnknownShop._ui.txt_reserveTime:isValidate()
  PaGlobal_UnknownShop._ui.stc_showAni:isValidate()
  PaGlobal_UnknownShop._ui.stc_KeyguideBG:isValidate()
  PaGlobal_UnknownShop._ui.stc_keyGuideDetail:isValidate()
  PaGlobal_UnknownShop._ui.stc_keyGuideReselect:isValidate()
  PaGlobal_UnknownShop._ui.stc_keyGuideReserve:isValidate()
  PaGlobal_UnknownShop._ui.stc_keyGuidePurchase:isValidate()
  PaGlobal_UnknownShop._ui.stc_keyGuideClose:isValidate()
end
function PaGlobal_UnknownShop_BuyItem()
  local moneyWhereType = MessageBoxCheck.isCheck()
  if CppEnums.ItemWhereType.eWarehouse == moneyWhereType then
    local wareHouseMoney = warehouse_moneyFromNpcShop_s64()
    if wareHouseMoney < toInt64(0, PaGlobal_UnknownShop._shopItemPrice) then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_RANDOMITEM_WAREHOUSEMONEY"))
      return
    end
  elseif getSelfPlayer():get():getInventory():getMoney_s64() < toInt64(0, PaGlobal_UnknownShop._shopItemPrice) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "Lua_TradeMarket_Not_Enough_Money"))
    return
  end
  npcShop_doBuyInRandomShop(PaGlobal_UnknownShop._shopSlotNo, 1, moneyWhereType, 0, PaGlobal_UnknownShop._priceRate)
  PaGlobal_UnknownShop:prepareClose()
end
function PaGlobal_UnknownShop_UpdateShopList()
  local playerWP = getSelfPlayer():getWp()
  local needWP
  if 12 == PaGlobal_UnknownShop._shopTypeNo then
    needWP = ToClient_getRandomShopConsumWp()
  elseif 13 == PaGlobal_UnknownShop._shopTypeNo then
    needWP = 10
  end
  if playerWP < needWP then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_UNKNOWITEMSELECT_WP_SHORTAGE_ACK"))
  else
    npcShop_requestList(CppEnums.ContentsType.Contents_Shop, true)
    PaGlobal_UnknownShop:checkReselectCondition()
  end
end
function PaGlobal_UnknownShop_ReserveAni(isShow)
  if 44672 == dialog_getTalkNpcKey() then
    isShow = false
  end
  PaGlobal_UnknownShop._ui.stc_showAni:SetShow(isShow)
  PaGlobal_UnknownShop._ui.stc_showAni:setUpdateTextureAni(isShow)
  PaGlobal_UnknownShop._ui.txt_reserveTime:SetShow(isShow)
  if false == isShow then
    PaGlobal_UnknownShop._ui.txt_reserveTime:SetText("")
  else
    ToClient_UpdateRandomShopKeepTime()
  end
end
function PaGlobal_UnknownShop:initUnknownShopItem(slotNo, priceRate)
  local colorTable = {
    [0] = Defines.Color.C_FFEEEEEE,
    [1] = Defines.Color.C_FF8DB245,
    [2] = Defines.Color.C_FF309BF5,
    [3] = Defines.Color.C_FFF0D147,
    [4] = Defines.Color.C_FFFF6244
  }
  local shopItemCount = npcShop_getBuyCount()
  for ii = 0, shopItemCount - 1 do
    local itemwrapper = npcShop_getItemBuy(ii)
    local shopItem = itemwrapper:get()
    if slotNo == shopItem.shopSlotNo then
      PaGlobal_UnknownShop._shopSlotNo = slotNo
      itemSSW = itemwrapper:getStaticStatus()
      sellPrice_64 = itemSSW:get()._sellPriceToNpc_s64
      sellPrice_32 = Int64toInt32(sellPrice_64)
      if nil ~= itemSSW then
        local itemIconPath = itemSSW:getIconPath()
        PaGlobal_UnknownShop._ui.stc_slotBG:ChangeTextureInfoName("Icon/" .. itemIconPath)
        local price32 = Int64toInt32(shopItem.price_s64)
        price32 = price32 * priceRate / 1000000
        PaGlobal_UnknownShop._shopItemPrice = price32
        local nameColorGrade = itemSSW:getGradeType()
        local fontColor = colorTable[0]
        if nil ~= colorTable[nameColorGrade] then
          fontColor = colorTable[nameColorGrade]
        end
        PaGlobal_UnknownShop._ui.txt_itemName:SetFontColor(fontColor)
        PaGlobal_UnknownShop._ui.txt_itemName:SetText(itemSSW:getName())
        PaGlobal_UnknownShop._ui.txt_moneyValue:SetText(makeDotMoney(price32))
        PaGlobal_UnknownShop._ui.txt_moneyValue:SetSize(PaGlobal_UnknownShop._ui.txt_moneyValue:GetTextSizeX(), PaGlobal_UnknownShop._ui.txt_moneyValue:GetSizeY())
        PaGlobal_UnknownShop._ui.txt_moneyValue:ComputePos()
        PaGlobal_UnknownShop._ui.txt_reserveTime:SetShow(false)
        PaGlobal_UnknownShop._ui.stc_showAni:SetShow(false)
        Panel_UnknownShop:registerPadEvent(__eConsoleUIPadEvent_Up_X, "HandleEventXUp_UnknownShop_ToggleItemTooltip( " .. ii .. " )")
      end
    end
  end
end
function PaGlobal_UnknownShop:checkReserveCondition()
  if 12 == PaGlobal_UnknownShop._shopTypeNo and 44672 ~= dialog_getTalkNpcKey() then
    if true == PaGlobal_UnknownShop._isReserveContentOpen then
      PaGlobal_UnknownShop._ui.stc_keyGuideReserve:SetShow(true)
      Panel_UnknownShop:registerPadEvent(__eConsoleUIPadEvent_LT, "HandleEventLT_UnknownShop_ReserveItem()")
    else
      PaGlobal_UnknownShop._ui.stc_keyGuideReserve:SetShow(false)
      Panel_UnknownShop:registerPadEvent(__eConsoleUIPadEvent_LT, "")
    end
  else
    PaGlobal_UnknownShop._ui.stc_keyGuideReserve:SetShow(false)
    PaGlobal_UnknownShop._ui.stc_keyGuideReserve:SetShow(false)
    Panel_UnknownShop:registerPadEvent(__eConsoleUIPadEvent_LT, "")
  end
  if true == ToClient_IsRandomShopKeepItem() and 12 == PaGlobal_UnknownShop._shopTypeNo then
    PaGlobal_UnknownShop_ReserveAni(true)
  else
    PaGlobal_UnknownShop_ReserveAni(false)
  end
end
function PaGlobal_UnknownShop:checkReselectCondition()
  local needWP
  if 12 == PaGlobal_UnknownShop._shopTypeNo then
    needWP = ToClient_getRandomShopConsumWp()
  elseif 13 == PaGlobal_UnknownShop._shopTypeNo then
    needWP = 10
  end
  if needWP > getSelfPlayer():getWp() then
    PaGlobal_UnknownShop._ui.stc_keyGuideReselect:SetShow(false)
  elseif true == ToClient_isReSelectRandomShopItem() then
    PaGlobal_UnknownShop._ui.stc_keyGuideReselect:SetShow(true)
  else
    PaGlobal_UnknownShop._ui.stc_keyGuideReselect:SetShow(false)
  end
  if 12 == shopTypeNum and true == ToClient_IsRandomShopKeepItem() and 44672 == dialog_getTalkNpcKey() then
    PaGlobal_UnknownShop._ui.stc_keyGuideReselect:SetShow(false)
    PaGlobal_UnknownShop._ui.stc_keyGuidePurchase:SetShow(false)
  else
    PaGlobal_UnknownShop._ui.stc_keyGuidePurchase:SetShow(true)
  end
end

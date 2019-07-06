function PaGlobal_Barter_Open(actorKey, regionKey)
  PaGlobal_Barter._actorKey = actorKey
  PaGlobal_Barter._regionKey = regionKey
  PaGlobal_Barter:prepareOpen()
end
function PaGlobal_Barter_Close()
  PaGlobal_Barter:prepareClose()
end
function HandleEventLUp_Barter_SelectType(eSelectType)
  PaGlobal_Barter._selectType = eSelectType
end
function HandleEvnetLUp_Barter_SelectExchangeCount()
  local barterWrapper = ToClient_barterWrapper(PaGlobal_Barter._regionKey)
  if nil ~= barterWrapper then
    local itemMaxCount = math.floor(Int64toInt32(PaGlobal_Barter._myItemCount / barterWrapper:getFromItemCount()))
    local currentCount = barterWrapper:getExchangeMaxCount() - barterWrapper:getExchangeCurrentCount()
    local totalMaxCount = math.min(itemMaxCount, currentCount)
    Panel_NumberPad_Show(true, totalMaxCount, nil, NumberPadInput_Barter_SetExchangeCount)
  end
end
function NumberPadInput_Barter_SetExchangeCount(inputCount)
  HandleEventLUp_Barter_RequestDoBarter(false, false, inputCount)
end
function HandleEventLUp_Barter_RequestDoBarter(isSpecial, isOnce, count)
  local itemEnchantKey, tooltipType
  local itemWhereType = PaGlobal_Barter._itemWhereType
  if nil == itemWhereType then
    return
  end
  if PaGlobal_Barter._eSelectType.special == PaGlobal_Barter._selectType then
    tooltipType = PaGlobal_Barter._eTooltipType.mySpecial
  else
    tooltipType = PaGlobal_Barter._eTooltipType.myNormal
  end
  itemEnchantKey = PaGlobal_Barter._cacheEnchantKey[tooltipType]
  if __eTInventorySlotNoUndefined == ToClient_InventoryGetSlotNoByType(itemWhereType, itemEnchantKey) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_BARTER_MESSAGE_INVENTORY"))
    return
  end
  local rv
  if false == isSpecial and false == isOnce then
    rv = ToClient_requestDoBarter(PaGlobal_Barter._actorKey, itemWhereType, itemEnchantKey, count)
  elseif true == isSpecial then
    rv = ToClient_requestDoSpecialBarter(PaGlobal_Barter._actorKey, itemWhereType, itemEnchantKey)
  else
    rv = ToClient_requestDoBarter(PaGlobal_Barter._actorKey, itemWhereType, itemEnchantKey, 1)
  end
  if rv ~= 0 then
  end
end
function HandleEventLUp_Bater_RequestSkip()
  local MessageBox_SkipFunc = function()
    ToClient_giveUpSpecailBarter(PaGlobal_Barter._actorKey)
  end
  local msgTitle = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_WINDOW_BARTER_SPECIALTITLE")
  local msgDesc = "\237\138\185\235\179\132 \235\172\188\235\172\188 \234\181\144\237\153\152\236\157\132 \237\143\172\234\184\176\237\149\152\236\139\156\234\178\160\236\138\181\235\139\136\234\185\140?\n(\237\143\172\234\184\176 \237\149\160 \234\178\189\236\154\176 \235\144\152\235\143\140\235\166\180 \236\136\152 \236\151\134\236\138\181\235\139\136\235\139\164.)"
  local messageBoxData = {
    title = msgTitle,
    content = msgDesc,
    functionYes = MessageBox_SkipFunc,
    functionNo = MessageBox_Empty_function,
    exitButton = true,
    priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageBoxData)
end
function HandleEventOn_Barter_ItemTooltipShow(eTooltipType)
  local itemSSW = getItemEnchantStaticStatus(PaGlobal_Barter._cacheEnchantKey[eTooltipType])
  if nil ~= itemSSW then
    Panel_Tooltip_Item_Show(itemSSW, Panel_Window_Barter, true)
  end
end
function HandleEventOn_Barter_ItemTooltipHide()
  Panel_Tooltip_Item_hideTooltip()
end
function FromClient_Barter_SuccessDoBarter(regionKey, isSpecial)
  Proc_ShowMessage_Ack("\235\172\188\235\172\188 \234\181\144\237\153\152\236\157\180 \236\153\132\235\163\140\235\144\152\236\151\136\236\138\181\235\139\136\235\139\164.")
  PaGlobal_Barter:updateItemInfo()
end

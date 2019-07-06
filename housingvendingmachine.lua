Panel_Housing_VendingMachineList:setGlassBackground(true)
Panel_Housing_VendingMachineList:ActiveMouseEventEffect(true)
local IM = CppEnums.EProcessorInputMode
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_PP = CppEnums.PAUIMB_PRIORITY
local VCK = CppEnums.VirtualKeyCode
local VendingMachineManager = {
  _list = {},
  _buttonStartStop = UI.getChildControl(Panel_Housing_VendingMachineList, "Button_Start"),
  _buttonClose = UI.getChildControl(Panel_Housing_VendingMachineList, "Button_Win_Close"),
  _buttonQuestion = UI.getChildControl(Panel_Housing_VendingMachineList, "Button_Question"),
  _updateIcon = UI.getChildControl(Panel_Housing_VendingMachineList, "Static_UpdateIcon"),
  _ownerBG = UI.getChildControl(Panel_Housing_VendingMachineList, "Static_OwnerBG"),
  _guestBG = UI.getChildControl(Panel_Housing_VendingMachineList, "Static_GuestBG"),
  _textBalance = UI.getChildControl(Panel_Housing_VendingMachineList, "StaticText_Balance"),
  _textBalanceValue = UI.getChildControl(Panel_Housing_VendingMachineList, "StaticText_BalanceValue"),
  _chkDeposit = UI.getChildControl(Panel_Housing_VendingMachineList, "CheckButton_Deposit"),
  _chkWithdraw = UI.getChildControl(Panel_Housing_VendingMachineList, "CheckButton_Withdraw"),
  _editGold = UI.getChildControl(Panel_Housing_VendingMachineList, "Edit_Gold"),
  _buttonPerform = UI.getChildControl(Panel_Housing_VendingMachineList, "Button_Deposit"),
  _isOwner = false,
  _clickIconNoReset = false,
  _currentHoldingMoney = 0,
  _checkFlag = 0,
  _currentIndex = 0,
  _currentItemCount = 0
}
function VendingMachineManager:initialize()
  local copyStaticBack = UI.getChildControl(Panel_Housing_VendingMachineList, "Static_BackGround")
  local copyButtonBuy = UI.getChildControl(Panel_Housing_VendingMachineList, "Button_Buy")
  local copyButtonSell = UI.getChildControl(Panel_Housing_VendingMachineList, "Button_Sell")
  local copyTextBuyPrice = UI.getChildControl(Panel_Housing_VendingMachineList, "Text_BuyPrice")
  local copyTextSellPrice = UI.getChildControl(Panel_Housing_VendingMachineList, "Text_SellPrice")
  local copyTextItemCount = UI.getChildControl(Panel_Housing_VendingMachineList, "Text_ItemCount")
  local copyTextMaxCount = UI.getChildControl(Panel_Housing_VendingMachineList, "Text_MaxCount")
  local copyStaticItemIcon = UI.getChildControl(Panel_Housing_VendingMachineList, "Static_Itemicon")
  local copyStaticItemName = UI.getChildControl(Panel_Housing_VendingMachineList, "StaticText_ItemName")
  local copyStaticBuyPrice = UI.getChildControl(Panel_Housing_VendingMachineList, "StaticText_BuyPrice")
  local copyStaticSellPrice = UI.getChildControl(Panel_Housing_VendingMachineList, "StaticText_SellPrice")
  local copyStaticMaxCount = UI.getChildControl(Panel_Housing_VendingMachineList, "StaticText_MaxCount")
  local copyEditBuyPrice = UI.getChildControl(Panel_Housing_VendingMachineList, "Edit_BuyPrice")
  local copyEditSellPrice = UI.getChildControl(Panel_Housing_VendingMachineList, "Edit_SellPrice")
  local copyEditMaxCount = UI.getChildControl(Panel_Housing_VendingMachineList, "Edit_MaxCount")
  local copyButtonDeleteItem = UI.getChildControl(Panel_Housing_VendingMachineList, "Button_DeleteItem")
  function createVendingMechineList(pIndex)
    local rtMachine = {}
    rtMachine._staticBack = UI.createControl(UCT.PA_UI_CONTROL_STATIC, Panel_Housing_VendingMachineList, "Static_BackGround_" .. pIndex)
    rtMachine._buttonBuy = UI.createControl(UCT.PA_UI_CONTROL_BUTTON, rtMachine._staticBack, "Button_Buy_" .. pIndex)
    rtMachine._buttonSell = UI.createControl(UCT.PA_UI_CONTROL_BUTTON, rtMachine._staticBack, "Button_Sell_" .. pIndex)
    rtMachine._buttonOut = UI.createControl(UCT.PA_UI_CONTROL_BUTTON, rtMachine._staticBack, "Button_Out_" .. pIndex)
    rtMachine._buttonIn = UI.createControl(UCT.PA_UI_CONTROL_BUTTON, rtMachine._staticBack, "Button_In_" .. pIndex)
    rtMachine._textBuyPrice = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, rtMachine._staticBack, "Text_BuyPrice_" .. pIndex)
    rtMachine._textSellPrice = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, rtMachine._staticBack, "Text_SellPrice_" .. pIndex)
    rtMachine._textItemCount = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, rtMachine._staticBack, "Text_ItemCount_" .. pIndex)
    rtMachine._textMaxCount = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, rtMachine._staticBack, "Text_MaxCount_" .. pIndex)
    rtMachine._staticItemIcon = UI.createControl(UCT.PA_UI_CONTROL_STATIC, rtMachine._staticBack, "Static_ItemIcon_" .. pIndex)
    rtMachine._staticItemName = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, rtMachine._staticBack, "StaticText_ItemName_" .. pIndex)
    rtMachine._staticBuyPrice = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, rtMachine._staticBack, "StaticText_BuyPrice_" .. pIndex)
    rtMachine._staticSellPrice = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, rtMachine._staticBack, "StaticText_SellPrice_" .. pIndex)
    rtMachine._staticMaxCount = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, rtMachine._staticBack, "StaticText_MaxCount_" .. pIndex)
    rtMachine._editBuyPrice = UI.createControl(UCT.PA_UI_CONTROL_EDIT, rtMachine._staticBack, "Edit_BuyPrice_" .. pIndex)
    rtMachine._editSellPrice = UI.createControl(UCT.PA_UI_CONTROL_EDIT, rtMachine._staticBack, "Edit_SellPrice_" .. pIndex)
    rtMachine._editMaxCount = UI.createControl(UCT.PA_UI_CONTROL_EDIT, rtMachine._staticBack, "Edit_MaxCount_" .. pIndex)
    rtMachine._buttonDeleteItem = UI.createControl(UCT.PA_UI_CONTROL_BUTTON, rtMachine._staticBack, "Button_DeleteItem_" .. pIndex)
    CopyBaseProperty(copyStaticBack, rtMachine._staticBack)
    CopyBaseProperty(copyButtonBuy, rtMachine._buttonBuy)
    CopyBaseProperty(copyButtonSell, rtMachine._buttonSell)
    CopyBaseProperty(copyButtonBuy, rtMachine._buttonOut)
    CopyBaseProperty(copyButtonSell, rtMachine._buttonIn)
    CopyBaseProperty(copyTextBuyPrice, rtMachine._textBuyPrice)
    CopyBaseProperty(copyTextSellPrice, rtMachine._textSellPrice)
    CopyBaseProperty(copyTextItemCount, rtMachine._textItemCount)
    CopyBaseProperty(copyTextMaxCount, rtMachine._textMaxCount)
    CopyBaseProperty(copyStaticItemIcon, rtMachine._staticItemIcon)
    CopyBaseProperty(copyStaticItemName, rtMachine._staticItemName)
    CopyBaseProperty(copyStaticBuyPrice, rtMachine._staticBuyPrice)
    CopyBaseProperty(copyStaticSellPrice, rtMachine._staticSellPrice)
    CopyBaseProperty(copyStaticMaxCount, rtMachine._staticMaxCount)
    CopyBaseProperty(copyEditBuyPrice, rtMachine._editBuyPrice)
    CopyBaseProperty(copyEditSellPrice, rtMachine._editSellPrice)
    CopyBaseProperty(copyEditMaxCount, rtMachine._editMaxCount)
    CopyBaseProperty(copyButtonDeleteItem, rtMachine._buttonDeleteItem)
    rtMachine._checkSlotIn = 0
    rtMachine._editBuyPrice:SetNumberMode(true)
    rtMachine._editBuyPrice:SetMaxInput(9)
    rtMachine._editSellPrice:SetNumberMode(true)
    rtMachine._editSellPrice:SetMaxInput(9)
    rtMachine._editMaxCount:SetNumberMode(true)
    rtMachine._editMaxCount:SetMaxInput(4)
    rtMachine._buttonOut:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_BUTTONOUT"))
    rtMachine._buttonIn:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_BUTTONIN"))
    local _vendingMachineSlotConfig = {
      createIcon = true,
      createBorder = true,
      createCash = true
    }
    local slot = {}
    SlotItem.new(slot, "ItemIcon_" .. pIndex, pIndex, rtMachine._staticItemIcon, _vendingMachineSlotConfig)
    slot:createChild()
    rtMachine._itemStatic = nil
    rtMachine._itemIcon = slot
    rtMachine._itemIcon.icon:SetPosX(8)
    rtMachine._itemIcon.icon:SetPosY(8)
    rtMachine._itemIcon.icon:addInputEvent("Mouse_On", "handleMouseOnVendingMachineIconTooltip(" .. pIndex .. ")")
    rtMachine._itemIcon.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
    rtMachine._buttonDeleteItem:addInputEvent("Mouse_LUp", "handleClickedVendingMachineIconReset(" .. pIndex .. ")")
    rtMachine._buttonBuy:addInputEvent("Mouse_LUp", "handleClickedVendingMachineBuy(" .. pIndex .. ")")
    rtMachine._buttonSell:addInputEvent("Mouse_LUp", "handleClickedVendingMachineSell(" .. pIndex .. ")")
    rtMachine._buttonOut:addInputEvent("Mouse_LUp", "handleClickedVendingMachineItemOut(" .. pIndex .. ")")
    rtMachine._buttonIn:addInputEvent("Mouse_LUp", "handleClickedVendingMachineItemIn(" .. pIndex .. ")")
    rtMachine._editBuyPrice:addInputEvent("Mouse_LUp", "handleClickedVendingMachineEditBuy(" .. pIndex .. ")")
    rtMachine._editSellPrice:addInputEvent("Mouse_LUp", "handleClickedVendingMachineEditSell(" .. pIndex .. ")")
    rtMachine._editMaxCount:addInputEvent("Mouse_LUp", "handleClickedVendingMachineEditCount(" .. pIndex .. ")")
    function rtMachine:SetPos(x, y)
      rtMachine._staticBack:SetPosX(x)
      rtMachine._staticBack:SetPosY(y)
    end
    function rtMachine:SetShow(isOwner, isShow)
      local businessIsActive = ToClient_RequestBusinessIsActive()
      if false == isOwner then
        rtMachine._staticBack:SetShow(businessIsActive)
      else
        rtMachine._staticBack:SetShow(true)
      end
      rtMachine._editBuyPrice:SetShow(isOwner and not businessIsActive and isShow)
      rtMachine._editSellPrice:SetShow(isOwner and not businessIsActive and isShow)
      rtMachine._editMaxCount:SetShow(isOwner and not businessIsActive and isShow)
      rtMachine._staticBuyPrice:SetShow(isShow)
      rtMachine._staticSellPrice:SetShow(isShow)
      rtMachine._staticMaxCount:SetShow(isShow)
      rtMachine._textBuyPrice:SetShow(isShow)
      rtMachine._textSellPrice:SetShow(isShow)
      rtMachine._textMaxCount:SetShow(isShow)
      rtMachine._buttonDeleteItem:SetShow(false)
    end
    function rtMachine:SetData(vendingData)
      VendingMachineManager._editGold:SetEditText("")
      VendingMachineManager._chkDeposit:SetCheck(false)
      VendingMachineManager._chkWithdraw:SetCheck(true)
      if vendingData:isEmpty() then
        if 1 ~= rtMachine._checkSlotIn then
          rtMachine._staticItemName:SetText("")
          rtMachine._itemIcon:clearItem()
          rtMachine:SetShow(VendingMachineManager._isOwner, false)
        end
        rtMachine._textBuyPrice:SetText("")
        rtMachine._textSellPrice:SetText("")
        rtMachine._textItemCount:SetText("")
        rtMachine._textMaxCount:SetText("")
        rtMachine._buttonBuy:SetShow(false)
        rtMachine._buttonSell:SetShow(false)
        rtMachine._buttonOut:SetShow(false)
        rtMachine._buttonIn:SetShow(false)
      else
        rtMachine._checkSlotIn = 3
        rtMachine:SetShow(VendingMachineManager._isOwner, true)
        rtMachine._buttonIn:SetShow(VendingMachineManager._isOwner)
        rtMachine._buttonSell:SetShow(not VendingMachineManager._isOwner)
        if Int64toInt32(vendingData._itemCount) <= 0 then
          rtMachine._buttonOut:SetShow(false)
          rtMachine._buttonBuy:SetShow(false)
        else
          rtMachine._buttonOut:SetShow(VendingMachineManager._isOwner)
          rtMachine._buttonBuy:SetShow(not VendingMachineManager._isOwner)
        end
        rtMachine._itemIcon:setItemByStaticStatus(vendingData:getItemEnchantStaticStatus(), toInt64(0, 1))
        rtMachine._staticItemName:SetText(vendingData:getItemEnchantStaticStatus():getName())
        if true == ToClient_RequestBusinessIsActive() then
          rtMachine._textBuyPrice:SetText(tostring(Int64toInt32(vendingData._buyFromUserPrice)))
          rtMachine._textSellPrice:SetText(tostring(Int64toInt32(vendingData._sellToUserPrice)))
          rtMachine._textMaxCount:SetText(tostring(Int64toInt32(vendingData._maxStackCount)) .. PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_MAXCOUNT"))
        else
          rtMachine._textBuyPrice:SetText("")
          rtMachine._textSellPrice:SetText("")
          rtMachine._textMaxCount:SetText("")
          rtMachine._editBuyPrice:SetEditText(Int64toInt32(vendingData._buyFromUserPrice), true)
          rtMachine._editSellPrice:SetEditText(Int64toInt32(vendingData._sellToUserPrice), true)
          rtMachine._editMaxCount:SetEditText(Int64toInt32(vendingData._maxStackCount), true)
          if Int64toInt32(vendingData._itemCount) > 0 then
            rtMachine._buttonDeleteItem:SetShow(false)
          else
            rtMachine._buttonDeleteItem:SetShow(VendingMachineManager._isOwner and true)
          end
        end
        rtMachine._textItemCount:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_ITEMCOUNT", "itemcount", Int64toInt32(vendingData._itemCount)))
      end
    end
    return rtMachine
  end
  for index = 0, 3 do
    self._list[index] = createVendingMechineList(index)
    self._list[index]:SetPos(10, 115 * index + 33)
  end
  self._editGold:SetNumberMode(true)
  self._updateIcon:AddEffect("fUI_InnerCircle", true, 0, 0)
  self._editGold:addInputEvent("Mouse_LUp", "handleClickedVendingMachineEditGold()")
  self._buttonStartStop:addInputEvent("Mouse_LUp", "handleClickedVendingMachineStartStop()")
  self._buttonClose:addInputEvent("Mouse_LUp", "handleClickedVendingMachineClose()")
  self._buttonQuestion:addInputEvent("Mouse_LUp", "Panel_WebHelper_ShowToggle( \"HosingVendingMachine\" )")
  self._buttonQuestion:addInputEvent("Mouse_On", "HelpMessageQuestion_Show( \"HosingVendingMachine\", \"true\")")
  self._buttonQuestion:addInputEvent("Mouse_Out", "HelpMessageQuestion_Show( \"HosingVendingMachine\", \"false\")")
  self._chkDeposit:addInputEvent("Mouse_LUp", "handleClickedVendingMachineCheckDeposit()")
  self._chkWithdraw:addInputEvent("Mouse_LUp", "handleClickedVendingMachineCheckWithdraw()")
  self._buttonPerform:addInputEvent("Mouse_LUp", "handleClickedVendingMachinePerform()")
  UI.deleteControl(copyStaticBack)
  UI.deleteControl(copyButtonBuy)
  UI.deleteControl(copyButtonSell)
  UI.deleteControl(copyTextBuyPrice)
  UI.deleteControl(copyTextSellPrice)
  UI.deleteControl(copyTextItemCount)
  UI.deleteControl(copyTextMaxCount)
  UI.deleteControl(copyStaticItemIcon)
  UI.deleteControl(copyStaticItemName)
  UI.deleteControl(copyStaticBuyPrice)
  UI.deleteControl(copyStaticSellPrice)
  UI.deleteControl(copyStaticMaxCount)
  UI.deleteControl(copyEditBuyPrice)
  UI.deleteControl(copyEditSellPrice)
  UI.deleteControl(copyEditMaxCount)
  UI.deleteControl(copyButtonDeleteItem)
  copyStaticBack, copyButtonBuy, copyButtonSell, copyTextBuyPrice, copyTextSellPrice, copyTextItemCount, copyTextMaxCount, copyStaticItemIcon, copyStaticItemName, copyStaticBuyPrice, copyStaticSellPrice, copyStaticMaxCount, copyEditBuyPrice, copyEditSellPrice, copyEditMaxCount, copyButtonDeleteItem = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
end
function handleClickedVendingMachineEditGold()
  VendingMachineManager._editGold:SetEditText("", true)
end
function handleClickedVendingMachineStartStop()
  local checkSlot = false
  if false == ToClient_RequestBusinessIsActive() then
    for index = 0, 3 do
      local maxCount = VendingMachineManager._list[index]._editMaxCount:GetEditNumber()
      local buyPrice = VendingMachineManager._list[index]._editBuyPrice:GetEditNumber()
      local sellPrice = VendingMachineManager._list[index]._editSellPrice:GetEditNumber()
      if 0 < VendingMachineManager._list[index]._checkSlotIn then
        if maxCount <= toInt64(0, 0) or buyPrice <= toInt64(0, 0) or sellPrice <= toInt64(0, 0) then
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_STARTSTOP_MESSAGE_0"))
          return
        end
        if buyPrice >= sellPrice then
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_STARTSTOP_MESSAGE_1"))
          return
        end
      end
      if 1 == VendingMachineManager._list[index]._checkSlotIn then
        VendingMachineManager._list[index]._checkSlotIn = 2
      end
    end
    for index = 0, 3 do
      local maxCount = VendingMachineManager._list[index]._editMaxCount:GetEditNumber()
      local buyPrice = VendingMachineManager._list[index]._editBuyPrice:GetEditNumber()
      local sellPrice = VendingMachineManager._list[index]._editSellPrice:GetEditNumber()
      if 2 == VendingMachineManager._list[index]._checkSlotIn then
        if nil ~= VendingMachineManager._list[index]._itemStatic then
          ToClient_RequestSetVendingMachineData(index, VendingMachineManager._list[index]._itemStatic, buyPrice, sellPrice, maxCount)
          checkSlot = true
        end
      elseif 3 == VendingMachineManager._list[index]._checkSlotIn then
        local vendingData = ToClient_RequestVendingMachineListAt(index)
        if maxCount < vendingData._itemCount then
          Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_STARTSTOP_MESSAGE_2"))
          return
        end
        if false == vendingData:isEmpty() then
          VendingMachineManager._list[index]._itemStatic = vendingData:getItemEnchantStaticStatus():get()
          ToClient_RequestSetVendingMachineData(index, VendingMachineManager._list[index]._itemStatic, buyPrice, sellPrice, maxCount)
          checkSlot = true
        end
      end
      VendingMachineManager._list[index]._checkSlotIn = 0
    end
    if false == checkSlot then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_STARTSTOP_MESSAGE_3"))
      return
    end
  end
  ToClient_RequestBusinessToggleActive()
  ToClient_RequestRecontactInstallation()
end
function handleClickedVendingMachineClose()
  VendingMachineManager:Close()
end
function handleClickedVendingMachineCheckDeposit()
  VendingMachineManager._checkFlag = 0
end
function handleClickedVendingMachineCheckWithdraw()
  VendingMachineManager._checkFlag = 1
end
function handleClickedVendingMachinePerform()
  local gold = VendingMachineManager._editGold:GetEditNumber()
  if gold <= toInt64(0, 0) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_PERFORM_MESSAGE_0"))
    return
  elseif gold > VendingMachineManager._currentHoldingMoney and 1 == VendingMachineManager._checkFlag then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_PERFORM_MESSAGE_1"))
    return
  end
  if 0 == VendingMachineManager._checkFlag then
    local messageboxData = {
      title = "",
      content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_DEPOSIT", "gold", gold),
      functionYes = handleClickedVendingMachineDepositGoldContinue,
      functionCancel = MessageBox_Empty_function,
      priority = UI_PP.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  elseif 1 == VendingMachineManager._checkFlag then
    local messageboxData = {
      title = "",
      content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_WITHDRAW", "gold", gold),
      functionYes = handleClickedVendingMachineWithdrawGoldContinue,
      functionCancel = MessageBox_Empty_function,
      priority = UI_PP.PAUIMB_PRIORITY_LOW
    }
    MessageBox.showMessageBox(messageboxData)
  end
  ClearFocusEdit()
end
function handleClickedVendingMachineDepositGoldContinue()
  local gold = VendingMachineManager._editGold:GetEditNumber()
  ToClient_RequestBusinessDepositMoney(gold)
  ClearFocusEdit()
end
function handleClickedVendingMachineWithdrawGoldContinue()
  local gold = VendingMachineManager._editGold:GetEditNumber()
  ToClient_RequestBusinessWithdrawMoney(gold)
  ClearFocusEdit()
end
function FGlobal_VendingMachineRegisterItemFromInventory(slotNo)
  local slotIndex = -1
  if true == VendingMachineManager._isOwner and false == ToClient_RequestBusinessIsActive() then
    for index = 0, 3 do
      if 0 == VendingMachineManager._list[index]._checkSlotIn then
        slotIndex = index
        break
      end
    end
    if -1 == slotIndex then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_REGISTERITEM_MESSAGE_0"))
      return
    end
    VendingMachineManager._list[slotIndex]._editBuyPrice:SetEditText("", true)
    VendingMachineManager._list[slotIndex]._editSellPrice:SetEditText("", true)
    VendingMachineManager._list[slotIndex]._editMaxCount:SetEditText("", true)
    local itemWrapper = getInventoryItem(slotNo)
    if nil == itemWrapper then
      return
    end
    if not itemWrapper:getStaticStatus():isStackable() or itemWrapper:get():isVested() or false == itemWrapper:getExpirationDate():isIndefinite() or itemWrapper:getStaticStatus():isForJustTrade() then
      Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_REGISTERITEM_MESSAGE_1"))
      return
    end
    VendingMachineManager._list[slotIndex]._itemStatic = itemWrapper:getStaticStatus():get()
    VendingMachineManager._list[slotIndex]._checkSlotIn = 1
    VendingMachineManager._list[slotIndex]._staticItemName:SetText(itemWrapper:getStaticStatus():getName())
    VendingMachineManager._list[slotIndex]._itemIcon:setItemByStaticStatus(itemWrapper:getStaticStatus())
    VendingMachineManager._list[slotIndex]:SetShow(VendingMachineManager._isOwner, true)
    VendingMachineManager._list[slotIndex]._buttonDeleteItem:SetShow(true)
  end
end
function handleClickedVendingMachineIconReset(index)
  VendingMachineManager._clickIconNoReset = true
  local vendingData = ToClient_RequestVendingMachineListAt(index)
  local itemCount = Int64toInt32(vendingData._itemCount)
  if itemCount > 0 and false == vendingData:isEmpty() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_ITEMRESET_MESSAGE"))
    return
  end
  if 0 == itemCount or vendingData:isEmpty() then
    if 1 < VendingMachineManager._list[index]._checkSlotIn then
      ToClient_RequestResetVendingMachineData(index)
    end
    VendingMachineManager._list[index]:SetShow(VendingMachineManager._isOwner, false)
    VendingMachineManager._list[index]._staticItemName:SetText("")
    VendingMachineManager._list[index]._itemIcon:clearItem()
    VendingMachineManager._list[index]._textItemCount:SetText("")
    VendingMachineManager._list[index]._buttonIn:SetShow(false)
    VendingMachineManager._list[index]._checkSlotIn = 0
  end
end
function handleMouseOnVendingMachineIconTooltip(index)
  Panel_Tooltip_Item_Show(ToClient_RequestVendingMachineListAt(index):getItemEnchantStaticStatus(), VendingMachineManager._list[index]._itemIcon.icon, true, false)
end
function handleClickedVendingMachineItemIn(index)
  VendingMachineManager._clickIconNoReset = true
  VendingMachineManager._currentIndex = index
  local vendingData = ToClient_RequestVendingMachineListAt(index)
  if vendingData:getItemEnchantStaticStatus():isStackable() then
    Panel_NumberPad_Show(true, vendingData._maxStackCount, 0, handleClickedNumberPadSell)
  else
    handleClickedNumberPadSell(toUint64(0, 1))
  end
end
function handleClickedVendingMachineItemOut(index)
  VendingMachineManager._clickIconNoReset = true
  VendingMachineManager._currentIndex = index
  local vendingData = ToClient_RequestVendingMachineListAt(index)
  if vendingData:getItemEnchantStaticStatus():isStackable() then
    Panel_NumberPad_Show(true, vendingData._itemCount, 0, handleClickedNumberPadBuy)
  else
    handleClickedNumberPadBuy(toUint64(0, 1))
  end
end
function handleClickedVendingMachineBuy(index)
  VendingMachineManager._currentIndex = index
  local vendingData = ToClient_RequestVendingMachineListAt(index)
  if vendingData:getItemEnchantStaticStatus():isStackable() then
    Panel_NumberPad_Show(true, vendingData._itemCount, 0, handleClickedNumberPadBuy)
  else
    handleClickedNumberPadBuy(toUint64(0, 1))
  end
end
function handleClickedVendingMachineSell(index)
  local vendingData = ToClient_RequestVendingMachineListAt(index)
  if VendingMachineManager._currentHoldingMoney <= 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_SELLFAIL_MESSAGE"))
    return
  elseif VendingMachineManager._currentHoldingMoney < Int64toInt32(vendingData._sellToUserPrice) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_SELLFAIL_MESSAGE"))
    return
  end
  VendingMachineManager._currentIndex = index
  if vendingData:getItemEnchantStaticStatus():isStackable() then
    Panel_NumberPad_Show(true, ToClient_RequestVendingMachineListAt(index)._maxStackCount, 0, handleClickedNumberPadSell)
  else
    handleClickedNumberPadSell(toUint64(0, 1))
  end
end
function handleClickedNumberPadBuy(itemCount)
  local messageboxData = 0
  VendingMachineManager._currentItemCount = itemCount
  if true == VendingMachineManager._isOwner then
    messageboxData = {
      title = "",
      content = PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_ITEMBUY_MESSAGE_0"),
      functionYes = NumberPadBuyContinue,
      functionCancel = MessageBox_Empty_function,
      priority = UI_PP.PAUIMB_PRIORITY_LOW
    }
  else
    messageboxData = {
      title = "",
      content = PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_ITEMBUY_MESSAGE_1"),
      functionYes = NumberPadBuyContinue,
      functionCancel = MessageBox_Empty_function,
      priority = UI_PP.PAUIMB_PRIORITY_LOW
    }
  end
  MessageBox.showMessageBox(messageboxData)
end
function NumberPadBuyContinue()
  ToClient_RequestBuyFromVendingMachine(VendingMachineManager._currentIndex, VendingMachineManager._currentItemCount)
  ToClient_RequestRecontactInstallation()
end
function handleClickedNumberPadSell(itemCount)
  local messageboxData = 0
  VendingMachineManager._currentItemCount = itemCount
  local vendingData = ToClient_RequestVendingMachineListAt(VendingMachineManager._currentIndex)
  if Int64toInt32(vendingData._maxStackCount) < Int64toInt32(vendingData._itemCount + itemCount) then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_CHECKMAXCOUNT"))
    return
  end
  if true == VendingMachineManager._isOwner then
    messageboxData = {
      title = "",
      content = PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_ITEMSELL_MESSAGE_0"),
      functionYes = NumberPadSellContinue,
      functionCancel = MessageBox_Empty_function,
      priority = UI_PP.PAUIMB_PRIORITY_LOW
    }
  else
    messageboxData = {
      title = "",
      content = PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_ITEMSELL_MESSAGE_1"),
      functionYes = NumberPadSellContinue,
      functionCancel = MessageBox_Empty_function,
      priority = UI_PP.PAUIMB_PRIORITY_LOW
    }
  end
  MessageBox.showMessageBox(messageboxData)
end
function NumberPadSellContinue()
  ToClient_RequestSellToVendingMachine(VendingMachineManager._currentIndex, VendingMachineManager._currentItemCount)
  ToClient_RequestRecontactInstallation()
end
function handleClickedVendingMachineEditBuy(index)
  VendingMachineManager._list[index]._editBuyPrice:SetEditText("", true)
end
function handleClickedVendingMachineEditSell(index)
  VendingMachineManager._list[index]._editSellPrice:SetEditText("", true)
end
function handleClickedVendingMachineEditCount(index)
  VendingMachineManager._list[index]._editMaxCount:SetEditText("", true)
end
function VendingMachineManager:SetShow(isOwner)
  self._ownerBG:SetShow(isOwner)
  self._textBalance:SetShow(isOwner)
  self._textBalanceValue:SetShow(isOwner)
  self._chkDeposit:SetShow(isOwner and not ToClient_RequestBusinessIsActive())
  self._chkWithdraw:SetShow(isOwner and not ToClient_RequestBusinessIsActive())
  self._editGold:SetShow(isOwner and not ToClient_RequestBusinessIsActive())
  self._buttonPerform:SetShow(isOwner and not ToClient_RequestBusinessIsActive())
  self._guestBG:SetShow(not isOwner)
  self._updateIcon:SetShow(ToClient_RequestBusinessIsActive())
end
function FGlobal_CheckCurrentVendingMachineUiEdit(targetUI)
  local checkUi = false
  if nil == targetUI then
    return false
  end
  for index = 0, 3 do
    if targetUI:GetKey() == VendingMachineManager._list[index]._editBuyPrice:GetKey() then
      checkUi = true
      break
    elseif targetUI:GetKey() == VendingMachineManager._list[index]._editSellPrice:GetKey() then
      checkUi = true
      break
    elseif targetUI:GetKey() == VendingMachineManager._list[index]._editMaxCount:GetKey() then
      checkUi = true
      break
    end
  end
  if targetUI:GetKey() == VendingMachineManager._editGold:GetKey() then
    checkUi = true
  end
  return checkUi
end
function FGlobal_VendingMachineClearFocusEdit(targetUI)
  for index = 0, 3 do
    local vendingData = ToClient_RequestVendingMachineListAt(index)
    if targetUI:GetKey() == VendingMachineManager._list[index]._editBuyPrice:GetKey() then
      if vendingData:isEmpty() then
        VendingMachineManager._list[index]._editBuyPrice:SetEditText("", true)
        break
      end
      VendingMachineManager._list[index]._editBuyPrice:SetEditText(Int64toInt32(vendingData._buyFromUserPrice), true)
      break
    elseif targetUI:GetKey() == VendingMachineManager._list[index]._editSellPrice:GetKey() then
      if vendingData:isEmpty() then
        VendingMachineManager._list[index]._editSellPrice:SetEditText("", true)
        break
      end
      VendingMachineManager._list[index]._editSellPrice:SetEditText(Int64toInt32(vendingData._sellToUserPrice), true)
      break
    elseif targetUI:GetKey() == VendingMachineManager._list[index]._editMaxCount:GetKey() then
      if vendingData:isEmpty() then
        VendingMachineManager._list[index]._editMaxCount:SetEditText("", true)
        break
      end
      VendingMachineManager._list[index]._editMaxCount:SetEditText(Int64toInt32(vendingData._maxStackCount), true)
      break
    end
  end
  ClearFocusEdit()
end
function VendingMachineManager:UpdateData(isOwner)
  self._isOwner = isOwner
  self:SetShow(isOwner)
  local vendingMachineListCount = ToClient_RequestVendingMachineListCount()
  for index = 0, vendingMachineListCount - 1 do
    local vendingData = ToClient_RequestVendingMachineListAt(index)
    self._list[index]:SetData(vendingData)
  end
  if false == isOwner and false == ToClient_RequestBusinessIsActive() then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_NOTSALE"))
    Panel_Housing_VendingMachineList:SetShow(false, false)
  end
  ToClient_RequestGetHoldingMoney()
  if ToClient_RequestBusinessIsActive() then
    self._buttonStartStop:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_SALESTOP"))
  else
    self._buttonStartStop:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_VENDINGMACHINE_SALESTART"))
  end
  self._buttonStartStop:SetShow(isOwner)
  ClearFocusEdit()
end
function VendingMachineManager:Show()
  if false == Panel_Housing_VendingMachineList:IsShow() then
    FGlobal_SetInventoryDragNoUse(Panel_Housing_VendingMachineList)
    Panel_Housing_VendingMachineList:SetShow(true, false)
  end
end
function VendingMachineManager:Close()
  if Panel_Housing_VendingMachineList:IsShow() then
    Panel_Housing_VendingMachineList:SetShow(false, false)
    ClearFocusEdit()
  end
end
VendingMachineManager:initialize()
registerEvent("FromClient_EventShowVendingMachineList", "FromClient_EventShowVendingMachineList")
registerEvent("FromClient_EventShowHoldingMoneyManager", "FromClient_EventShowVendingMachineHoldingMoneyManager")
registerEvent("FromClient_ReciveDrawForWinner", "FromClient_ReciveDrawForWinner")
registerEvent("FromClient_ReciveRegisterLottery", "FromClient_ReciveRegisterLottery")
function FromClient_EventShowVendingMachineHoldingMoneyManager(holdingMoney)
  VendingMachineManager._currentHoldingMoney = Int64toInt32(holdingMoney)
  VendingMachineManager._textBalanceValue:SetText(tostring(Int64toInt32(holdingMoney)))
end
function FromClient_EventShowVendingMachineList(isOwner)
  if false == VendingMachineManager._clickIconNoReset then
    for index = 0, 3 do
      VendingMachineManager._list[index]._checkSlotIn = 0
    end
  end
  VendingMachineManager._clickIconNoReset = false
  VendingMachineManager._checkFlag = 1
  VendingMachineManager:UpdateData(isOwner)
  VendingMachineManager:Show()
end
function FromClient_ReciveDrawForWinner(characterName)
  local messageboxData = {
    title = "",
    content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSINGVENDINGMACHINE_MSGBOX_WINNER", "characterName", tostring(characterName)),
    functionApply = MessageBox_Empty_function,
    priority = UI_PP.PAUIMB_PRIORITY_LOW
  }
  local messageboxData = {
    title = "",
    content = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_HOUSINGVENDINGMACHINE_WINNER", "characterName", tostring(characterName)),
    functionApply = MessageBox_Empty_function,
    priority = UI_PP.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end
function FromClient_ReciveRegisterLottery()
  local messageboxData = {
    title = "",
    content = PAGetString(Defines.StringSheet_GAME, "LUA_HOUSINGVENDINGMACHINE_LOTTERY"),
    functionApply = MessageBox_Empty_function,
    priority = UI_PP.PAUIMB_PRIORITY_LOW
  }
  MessageBox.showMessageBox(messageboxData)
end

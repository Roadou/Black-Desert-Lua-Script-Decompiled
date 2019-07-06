local _panel = Panel_Window_MarketPlace_WalletInventory
local UI_color = Defines.Color
local MarketPlace_WalletInven = {
  _ui = {
    stc_Title = UI.getChildControl(_panel, "StaticText_Title"),
    stc_TopBg = UI.getChildControl(_panel, "Static_TopItemSortBG"),
    stc_WeightBg = UI.getChildControl(_panel, "Static_Texture_Weight_Background"),
    template_Slot = UI.getChildControl(_panel, "Template_Static_Slot"),
    template_LockSlot = UI.getChildControl(_panel, "Template_Static_LockSlot"),
    scroll_CashInven = UI.getChildControl(_panel, "Scroll_CashInven"),
    btn_Withdraw = UI.getChildControl(_panel, "Button_Withdraw"),
    stc_ScrollArea = UI.getChildControl(_panel, "Scroll_Area"),
    btn_goToMarket = UI.getChildControl(_panel, "Button_GoToMarket"),
    btn_goToWallet = UI.getChildControl(_panel, "Button_GoToWallet"),
    btn_goToWarehouse = UI.getChildControl(_panel, "Button_BacktoWarehouse"),
    txt_Money = UI.getChildControl(_panel, "StaticText_MoneyValue")
  },
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCooltime = true,
    createExpiration = true,
    createExpirationBG = true,
    createExpiration2h = true,
    createClassEquipBG = true,
    createEnduranceIcon = true,
    createCash = true,
    createBagIcon = true,
    createEnduranceIcon = true,
    createCheckBox = true
  },
  _config = {
    slotCount = 64,
    slotCols = 8,
    slotRows = 0,
    slotStartX = 0,
    slotStartY = 0,
    slotGapX = 53,
    slotGapY = 53,
    maxItem = __eTMarketPlaceWalletInventorySlotNoMax
  },
  _slotWalletBgData = {},
  _slotWalletItemData = {},
  _startInvenSlotIndex = 0,
  _isAblePearlProduct = false,
  _moneySlot = 0
}
function PaGlobalFunc_MarketPlace_WalletInven_Init()
  local self = MarketPlace_WalletInven
  self:initData()
  self:initControl()
  self:initEvent()
end
function MarketPlace_WalletInven:initControl()
  self._ui.btn_Close = UI.getChildControl(self._ui.stc_Title, "Button_Win_Close")
  self._ui.btn_Question = UI.getChildControl(self._ui.stc_Title, "Button_Question")
  self._ui.checkBtn_PopUp = UI.getChildControl(self._ui.stc_Title, "CheckButton_PopUp")
  self._ui.btn_List = UI.getChildControl(self._ui.stc_TopBg, "RadioButton_List")
  self._ui.btn_Slot = UI.getChildControl(self._ui.stc_TopBg, "RadioButton_Slot")
  self._ui.txt_Capacity = UI.getChildControl(self._ui.stc_TopBg, "Static_Text_Capacity")
  self._ui.progress_Weight = UI.getChildControl(self._ui.stc_WeightBg, "Progress2_Weight")
  self._ui.progress_Equipment = UI.getChildControl(self._ui.stc_WeightBg, "Progress2_Equipment")
  self._ui.progress_Money = UI.getChildControl(self._ui.stc_WeightBg, "Progress2_Money")
  self._ui.txt_Weight = UI.getChildControl(self._ui.stc_WeightBg, "StaticText_Weight")
  for slotIdx = 0, self._config.slotCount - 1 do
    local slot = {}
    slot.base = UI.createAndCopyBasePropertyControl(_panel, "Template_Static_Slot", _panel, "MarketWallet_Wallet_EmptySlot_" .. slotIdx)
    slot.lock = UI.createAndCopyBasePropertyControl(_panel, "Template_Static_LockSlot", _panel, "MarketWallet_Wallet_LockSlot_" .. slotIdx)
    local row = math.floor(slotIdx / self._config.slotCols)
    local column = slotIdx % self._config.slotCols
    local lockGapX = slot.base:GetSizeX() / 2 - slot.lock:GetSizeX() / 2
    local lockGapY = slot.base:GetSizeY() / 2 - slot.lock:GetSizeY() / 2
    slot.base:SetPosX(self._config.slotStartX + self._config.slotGapX * column)
    slot.base:SetPosY(self._config.slotStartY + self._config.slotGapY * row)
    slot.lock:SetPosXY(slot.base:GetPosX() + lockGapX, slot.base:GetPosY() + lockGapY)
    slot.base:SetShow(true)
    slot.lock:SetShow(false)
    UIScroll.InputEventByControl(slot.base, "PaGlobalFunc_MarketPlace_WalletInven_Scroll")
    self._slotWalletBgData[slotIdx] = slot
  end
  for slotIdx = 0, self._config.slotCount - 1 do
    local slot = {}
    SlotItem.new(slot, "WalletItem_" .. slotIdx, slotIdx, _panel, self._slotConfig)
    slot:createChild()
    local row = math.floor(slotIdx / self._config.slotCols)
    local column = slotIdx % self._config.slotCols
    slot.icon:SetPosX(self._config.slotStartX + self._config.slotGapX * column + 2)
    slot.icon:SetPosY(self._config.slotStartY + self._config.slotGapY * row + 2)
    slot.icon:SetEnableDragAndDrop(false)
    slot.icon:SetAutoDisableTime(0.5)
    UIScroll.InputEventByControl(slot.icon, "PaGlobalFunc_MarketPlace_WalletInven_Scroll")
    self._slotWalletItemData[slotIdx] = slot
  end
end
function MarketPlace_WalletInven:initEvent()
  UIScroll.InputEvent(self._ui.scroll_CashInven, "PaGlobalFunc_MarketPlace_WalletInven_Scroll")
  UIScroll.InputEventByControl(self._ui.stc_ScrollArea, "PaGlobalFunc_MarketPlace_WalletInven_Scroll")
  self._ui.btn_Withdraw:addInputEvent("Mouse_LUp", "InputMRUp_MarketWallet_WithdrawMoney()")
  self._ui.btn_Withdraw:addInputEvent("Mouse_On", "MarketWallet_WithdrawMoney_TooltipShow()")
  self._ui.btn_Withdraw:addInputEvent("Mouse_Out", "MarketWallet_WithdrawMoney_TooltipHide()")
  self._ui.btn_Close:addInputEvent("Mouse_LUp", "PaGlobalFunc_MarketPlace_WalletInven_Close()")
  self._ui.btn_goToMarket:addInputEvent("Mouse_LUp", "PaGlobalFunc_ItemMarket_OpenbyMaid(1)")
  self._ui.btn_goToWallet:addInputEvent("Mouse_LUp", "PaGlobalFunc_ItemMarket_OpenbyMaid(2)")
  self._ui.btn_goToWarehouse:addInputEvent("Mouse_LUp", "Warehouse_OpenPanelFromDialog()")
  self._ui.btn_goToMarket:addInputEvent("Mouse_On", "MarketWallet_ShortCutSetting_TooltipShow(true, 1)")
  self._ui.btn_goToMarket:addInputEvent("Mouse_Out", "MarketWallet_ShortCutSetting_TooltipShow()")
  self._ui.btn_goToWallet:addInputEvent("Mouse_On", "MarketWallet_ShortCutSetting_TooltipShow(true, 2)")
  self._ui.btn_goToWallet:addInputEvent("Mouse_Out", "MarketWallet_ShortCutSetting_TooltipShow()")
  self._ui.btn_goToMarket:setButtonShortcuts("PANEL_MARKETPLACE_SHORTCUT_OPEN")
  self._ui.btn_goToWallet:setButtonShortcuts("PANEL_MARKETPLACE_SHORTCUT_BAGOPEN")
end
function MarketWallet_WithdrawMoney_TooltipShow()
  local uiControl = MarketPlace_WalletInven._ui.btn_Withdraw
  local name = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WITHDRAWMONEY_NAME")
  local desc = PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_WITHDRAWMONEY_DESC")
  TooltipSimple_Show(uiControl, name, desc)
end
function MarketWallet_ShortCutSetting_TooltipShow(isShow, index)
  if nil == isShow then
    TooltipSimple_Hide()
    return
  end
  local self = MarketPlace_WalletInven
  local uiControl, name, desc
  if 1 == index then
    uiControl = self._ui.btn_goToMarket
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MARKETPLACE_GO_BUY")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_MARKETPLACE_WALLETINVENTORY_PURCHASETOOLTIPDESC") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SHORTBUTTON_HOWTOUSE_TOOLTIP_DESC")
    TooltipSimple_Show(uiControl, name, desc)
  elseif 2 == index then
    uiControl = self._ui.btn_goToWallet
    name = PAGetString(Defines.StringSheet_RESOURCE, "PANEL_MARKETPLACE_GO_SELL")
    desc = PAGetString(Defines.StringSheet_GAME, "LUA_WINDOW_MARKETPLACE_WALLETINVENTORY_SELLTOOLTIPDESC") .. "\n" .. PAGetString(Defines.StringSheet_GAME, "LUA_SHORTBUTTON_HOWTOUSE_TOOLTIP_DESC")
    TooltipSimple_Show(uiControl, name, desc)
  end
end
function MarketWallet_WithdrawMoney_TooltipHide()
  TooltipSimple_Hide()
end
function MarketPlace_WalletInven:initData()
  self._isAblePearlProduct = requestCanRegisterPearlItemOnMarket()
  self._moneySlot = getMoneySlotNo()
  self._config.slotRows = self._config.slotCount / self._config.slotCols
  self._maxSlotRow = math.floor((self._config.slotCount - 1) / self._config.slotCols)
  self._config.slotStartX = self._ui.template_Slot:GetPosX()
  self._config.slotStartY = self._ui.template_Slot:GetPosY()
end
function PaGlobalFunc_MarketPlace_WalletInven_Scroll(isUp)
  local self = MarketPlace_WalletInven
  if nil == self then
    _PA_ASSERT(false, "\237\140\168\235\132\144\236\157\180 \236\161\180\236\158\172\237\149\152\236\167\128 \236\149\138\236\138\181\235\139\136\235\139\164!! : MarketWallet")
    return
  end
  if true == PaGlobal_TutorialPhase_IsTutorial() then
    return
  end
  self._startInvenSlotIndex = UIScroll.ScrollEvent(self._ui.scroll_CashInven, isUp, self._config.slotRows, self._config.maxItem, self._startInvenSlotIndex, self._config.slotCols)
  Panel_Tooltip_Item_hideTooltip()
  self:updateWallet()
end
function PaGlobalFunc_MarketPlace_WalletInven_Update()
  local self = MarketPlace_WalletInven
  self:updateWallet()
end
function MarketPlace_WalletInven:updateWallet()
  Panel_Tooltip_Item_hideTooltip()
  local currentWeight = getWorldMarketCurrentWeight()
  local maxWeight = getWorldMarketMaxWeight()
  local silverInfo = getWorldMarketSilverInfo()
  local _const = Defines.s64_const
  local s64_allWeight = toInt64(0, currentWeight)
  local s64_maxWeight = toInt64(0, maxWeight)
  local s64_allWeight_div = s64_allWeight
  local s64_maxWeight_div = s64_maxWeight
  local str_AllWeight = string.format("%.1f", Int64toInt32(s64_allWeight_div) / 10)
  local str_MaxWeight = string.format("%.0f", Int64toInt32(s64_maxWeight_div) / 10)
  self._ui.txt_Money:SetText(makeDotMoney(silverInfo:getItemCount()))
  self._ui.txt_Weight:SetText(str_AllWeight .. " / " .. str_MaxWeight .. " " .. PAGetString(Defines.StringSheet_GAME, "LUA_MARKETPLACE_VOLUME_VT"))
  self._ui.progress_Weight:SetProgressRate(Int64toInt32(str_AllWeight * 100 / str_MaxWeight))
  local slotNoList = Array.new()
  local walletItemCount = getWorldMarketMyWalletListCount()
  slotNoList:fill(0, self._config.maxItem)
  local usedSlotCount = 0
  for slotIdx = 0, self._config.slotCount - 1 do
    local slot = self._slotWalletItemData[slotIdx]
    local slotBg = self._slotWalletBgData[slotIdx]
    local slotNo = slotIdx + self._startInvenSlotIndex
    slot:clearItem()
    slot.slotNo = slotNo
    slot.icon:EraseAllEffect()
    slot.icon:addInputEvent("Mouse_RUp", "")
    slot.icon:addInputEvent("Mouse_On", "")
    slot.icon:addInputEvent("Mouse_Out", "")
    if walletItemCount > slotNo then
      local itemMyWalletInfo = getWorldMarketMyWalletListByIdx(slotNo)
      local itemWrapper = itemMyWalletInfo:getItemEnchantStaticStatusWrapper()
      if nil ~= itemWrapper then
        usedSlotCount = usedSlotCount + 1
        local s64_inventoryItemCount = itemMyWalletInfo:getItemCount()
        local isSealed = itemMyWalletInfo:isSealed()
        slot:setItemByStaticStatus(itemWrapper, s64_inventoryItemCount, -1, false, nil, false, 0, 0, nil, true, isSealed)
        slot.isEmpty = false
        if false == PaGlobal_TutorialPhase_IsTutorial() then
          slot.icon:addInputEvent("Mouse_RUp", "InputMRUp_MarketWallet_MoveWalletToInven(" .. slotNo .. ")")
          slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlace_WalletInven_ShowToolTip(" .. slotNo .. "," .. slotIdx .. ")")
          slot.icon:addInputEvent("Mouse_Out", "Panel_Tooltip_Item_hideTooltip()")
        end
        slot.icon:SetAlpha(1)
      end
    end
    slotBg.lock:SetShow(false)
  end
  self._ui.txt_Capacity:SetText("")
  UIScroll.SetButtonSize(self._ui.scroll_CashInven, self._config.slotCount, self._config.maxItem)
end
function PaGlobalFunc_MarketPlace_WalletInven_ShowToolTip(slotNo, slotIdx)
  local self = MarketPlace_WalletInven
  if nil == slotNo then
    return
  end
  local itemMyWalletInfo = getWorldMarketMyWalletListByIdx(slotNo)
  if nil == itemMyWalletInfo then
    return
  end
  local itemWrapper = itemMyWalletInfo:getItemEnchantStaticStatusWrapper()
  local slot = self._slotWalletItemData[slotIdx]
  if nil == itemWrapper then
    return
  end
  if nil == slot then
    return
  end
  PaGlobalFunc_MarketPlace_ShowToolTip(itemWrapper, slot.icon, false)
end
function PaGlobalFunc_MarketPlace_WalletInven_HideButton(isShow)
  if nil == isShow then
    return
  end
  local self = MarketPlace_WalletInven
  self._ui.btn_goToWarehouse:SetShow(isShow)
end
function PaGlobalFunc_MarketPlace_WalletInven_Open()
  local self = MarketPlace_WalletInven
  self:open()
  self._ui.scroll_CashInven:SetControlPos(0)
  self._startInvenSlotIndex = 0
  if true == PaGlobalFunc_MarketPlace_IsOpenByMaid() or true == PaGlobalFunc_MarketPlace_IsOpenFromDialog() then
    self._ui.btn_goToMarket:SetShow(true)
    self._ui.btn_goToWallet:SetShow(true)
  else
    self._ui.btn_goToMarket:SetShow(false)
    self._ui.btn_goToWallet:SetShow(false)
  end
  local scrSizeX = getScreenSizeX()
  local scrSizeY = getScreenSizeY()
  local panelSizeX = _panel:GetSizeX()
  local panelSizeY = _panel:GetSizeY()
  _panel:SetPosX(scrSizeX / 2 - panelSizeX / 2 + panelSizeX / 2)
  _panel:SetPosY(scrSizeY / 2 - panelSizeY / 2)
  local dialog
  if false == _ContentsGroup_NewUI_Dialog_All then
    dialog = Panel_Npc_Dialog
  else
    dialog = Panel_Npc_Dialog_All
  end
  if nil == dialog then
    return
  elseif true == dialog:GetShow() then
    local isGapY = scrSizeY - panelSizeY > dialog:GetSizeY()
    if true == isGapY then
      _panel:SetPosY(scrSizeY / 2 - panelSizeY / 2 - 140)
    end
  end
  self:updateWallet()
end
function PaGlobalFunc_MarketPlace_WalletInven_Close()
  local self = MarketPlace_WalletInven
  if false == PaGlobalFunc_MarketPlace_WalletInven_GetShow() then
    return
  end
  self:close()
  if false == PaGlobalFunc_MarketPlace_MyInven_GetShow() then
    PaGlobalFunc_MarketWallet_Close()
  end
end
function MarketPlace_WalletInven:open()
  _panel:SetShow(true)
end
function MarketPlace_WalletInven:close()
  _panel:SetShow(false)
end
function PaGlobalFunc_MarketPlace_WalletInven_GetShow()
  return _panel:GetShow()
end
function PaGlobalFunc_MarketPlace_WalletInven_GetPanel()
  return _panel
end

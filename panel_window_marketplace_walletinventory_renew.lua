local mainPanel = Panel_Window_MarketPlace_Main
local manageBg = UI.getChildControl(mainPanel, "Static_ManageMentBg")
local myInvenBg = UI.getChildControl(manageBg, "Static_LeftBg")
local _panel = myInvenBg
local UI_color = Defines.Color
local MarketPlace_WalletInven = {
  _ui = {
    stc_ButtonGroup = UI.getChildControl(_panel, "Static_ButtonGroup"),
    stc_ItemListGroup = UI.getChildControl(_panel, "Static_ItemListGroup"),
    btn_AConsoleUI = UI.getChildControl(_panel, "Button_A_ConsoleUI"),
    txt_Weight = UI.getChildControl(_panel, "StaticText_WeightIcon")
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
  _moneySlot = 0,
  _currnetSlotIdx = 0
}
function PaGlobalFunc_MarketPlace_WalletInven_Init()
  local self = MarketPlace_WalletInven
  self:initControl()
  self:initEvent()
end
function MarketPlace_WalletInven:initControl()
  self._ui.template_Slot = UI.getChildControl(self._ui.stc_ItemListGroup, "Template_Static_Slot")
  self._ui.scroll_ItemSlot = UI.getChildControl(self._ui.stc_ItemListGroup, "Scroll_ItemSlot")
  self._ui.btn_Withdraw = UI.getChildControl(self._ui.stc_ButtonGroup, "Button_Money")
  self._ui.txt_Money = UI.getChildControl(self._ui.btn_Withdraw, "StaticText_MoneyValue")
  self:initData()
  for slotIdx = 0, self._config.slotCount - 1 do
    local slot = {}
    slot.base = UI.createAndCopyBasePropertyControl(self._ui.stc_ItemListGroup, "Template_Static_Slot", self._ui.stc_ItemListGroup, "MarketWallet_Wallet_EmptySlot_" .. slotIdx)
    local row = math.floor(slotIdx / self._config.slotCols)
    local column = slotIdx % self._config.slotCols
    slot.base:SetPosX(self._config.slotStartX + self._config.slotGapX * column)
    slot.base:SetPosY(self._config.slotStartY + self._config.slotGapY * row)
    slot.base:SetShow(true)
    if 0 == row then
      slot.base:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "PaGlobalFunc_MarketPlace_WalletInven_Scroll(true)")
    elseif self._maxSlotRow == row then
      slot.base:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "PaGlobalFunc_MarketPlace_WalletInven_Scroll(false)")
    end
    UIScroll.InputEventByControl(slot.base, "PaGlobalFunc_MarketPlace_WalletInven_Scroll")
    self._slotWalletBgData[slotIdx] = slot
  end
  for slotIdx = 0, self._config.slotCount - 1 do
    local slot = {}
    SlotItem.new(slot, "WalletItem_" .. slotIdx, slotIdx, self._ui.stc_ItemListGroup, self._slotConfig)
    slot:createChild()
    local row = math.floor(slotIdx / self._config.slotCols)
    local column = slotIdx % self._config.slotCols
    slot.icon:SetPosX(self._config.slotStartX + self._config.slotGapX * column + 2)
    slot.icon:SetPosY(self._config.slotStartY + self._config.slotGapY * row + 2)
    slot.icon:SetEnableDragAndDrop(false)
    slot.icon:SetAutoDisableTime(0.5)
    if 0 == row then
      slot.icon:registerPadEvent(__eConsoleUIPadEvent_DpadUp, "")
    elseif self._maxSlotRow == row then
      slot.icon:registerPadEvent(__eConsoleUIPadEvent_DpadDown, "")
    end
    UIScroll.InputEventByControl(slot.icon, "PaGlobalFunc_MarketPlace_WalletInven_Scroll")
    self._slotWalletItemData[slotIdx] = slot
  end
end
function MarketPlace_WalletInven:initEvent()
  self._ui.btn_Withdraw:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlaceConsole_SelectManageWalletBG(false, true)")
  self._ui.btn_Withdraw:addInputEvent("Mouse_LUp", "InputMRUp_MarketWallet_WithdrawMoney()")
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
  local prevSlotIndex = self._startInvenSlotIndex
  self._startInvenSlotIndex = UIScroll.ScrollEvent(self._ui.scroll_ItemSlot, isUp, self._config.slotRows, self._config.maxItem, self._startInvenSlotIndex, self._config.slotCols)
  if prevSlotIndex == 0 and self._startInvenSlotIndex == 0 then
    return
  end
  ToClient_padSnapIgnoreGroupMove()
  Panel_Tooltip_Item_hideTooltip()
  PaGlobalFunc_TooltipInfo_Close()
  self:updateWallet()
  PaGlobalFunc_MarketPlace_WalletInven_ShowToolTip(self._currnetSlotIdx + self._startInvenSlotIndex, self._currnetSlotIdx)
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
  self._ui.txt_Weight:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_MARKETPLACE_VOLUME_VT_PARAM_NONCOLOR", "Weight", str_AllWeight .. " / " .. str_MaxWeight))
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
    slot.icon:addInputEvent("Mouse_LUp", "")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlaceConsole_SelectManageWalletBG(false, false)")
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
        slot.icon:addInputEvent("Mouse_RUp", "PaGlobalFunc_MarketPlace_WalletInven_ViewDetailToolTip(" .. slotNo .. ",true)")
        slot.icon:addInputEvent("Mouse_LUp", "InputMRUp_MarketWallet_MoveWalletToInven(" .. slotNo .. ")")
        slot.icon:SetAlpha(1)
      end
    end
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_MarketPlace_WalletInven_ShowToolTip(" .. slotNo .. "," .. slotIdx .. ")")
    slot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_FloatingTooltip_Close()")
  end
  UIScroll.SetButtonSize(self._ui.scroll_ItemSlot, self._config.slotCount, self._config.maxItem)
end
function PaGlobalFunc_MarketPlace_WalletInven_ViewDetailToolTip(slotNo, isShow)
  local self = MarketPlace_MyInven
  if true == isShow then
    local itemMyWalletInfo = getWorldMarketMyWalletListByIdx(slotNo)
    local itemWrapper = itemMyWalletInfo:getItemEnchantStaticStatusWrapper()
    local enchantKey = itemMyWalletInfo:getEnchantKey()
    if nil ~= itemWrapper then
      PaGlobalFunc_TooltipInfo_OpenByMyWallet(Defines.TooltipDataType.ItemSSWrapper, itemWrapper, Defines.TooltipTargetType.Item, 0, getScreenSizeX(), true, enchantKey)
      PaGlobalFunc_FloatingTooltip_Close()
    end
  else
    PaGlobalFunc_TooltipInfo_Close()
  end
end
function PaGlobalFunc_MarketPlace_WalletInven_ShowToolTip(slotNo, slotIdx)
  PaGlobalFunc_MarketPlaceConsole_SelectManageWalletBG(false, true)
  PaGlobalFunc_FloatingTooltip_Close()
  local self = MarketPlace_WalletInven
  self._currnetSlotIdx = slotIdx
  local itemMyWalletInfo = getWorldMarketMyWalletListByIdx(slotNo)
  if nil == itemMyWalletInfo then
    return
  end
  local itemWrapper = itemMyWalletInfo:getItemEnchantStaticStatusWrapper()
  local slot = self._slotWalletItemData[slotIdx]
  if nil == slot then
    return
  end
  if nil == itemWrapper then
    return
  end
  PaGlobalFunc_FloatingTooltip_Open(Defines.TooltipDataType.ItemSSWrapper, itemWrapper, Defines.TooltipTargetType.Item, slot.icon)
end
function PaGlobal_MarketPlaceConsole_SetWalletKeyGuide(isShow)
  local self = MarketPlace_WalletInven
  self._ui.btn_AConsoleUI:SetShow(isShow)
end
function PaGlobalFunc_MarketPlace_WalletInven_Open()
  local self = MarketPlace_WalletInven
  self:open()
  self._ui.scroll_ItemSlot:SetControlPos(0)
  self._startInvenSlotIndex = 0
  ToClient_requestMyWalletList()
  self:updateWallet()
  PaGlobalFunc_ItemMarket_SearchResultClose()
end
function PaGlobalFunc_MarketPlace_WalletInven_Close()
  local self = MarketPlace_WalletInven
  self:close()
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

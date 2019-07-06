local UI_TM = CppEnums.TextMode
local UI_color = Defines.Color
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
function ItemMarketPreBidManager_ShowAni()
  Panel_ItemMarket_PreBid_Manager:SetAlpha(0)
  UIAni.AlphaAnimation(1, Panel_ItemMarket_PreBid_Manager, 0, 0.3)
end
function ItemMarketPreBidManager_HideAni()
  local ani1 = UIAni.AlphaAnimation(0, Panel_ItemMarket_PreBid_Manager, 0, 0.2)
  ani1:SetHideAtEnd(true)
end
Panel_ItemMarket_PreBid_Manager:RegisterShowEventFunc(true, "ItemMarketPreBidManager_ShowAni()")
Panel_ItemMarket_PreBid_Manager:RegisterShowEventFunc(false, "ItemMarketPreBidManager_HideAni()")
Panel_ItemMarket_PreBid_Manager:SetShow(false, false)
Panel_ItemMarket_PreBid_Manager:ActiveMouseEventEffect(true)
Panel_ItemMarket_PreBid_Manager:setGlassBackground(true)
local ItemMarketPreBid_Manager = {
  ui = {
    btn_Close = UI.getChildControl(Panel_ItemMarket_PreBid_Manager, "Button_Close"),
    bg = UI.getChildControl(Panel_ItemMarket_PreBid_Manager, "Static_BG"),
    scroll = UI.getChildControl(Panel_ItemMarket_PreBid_Manager, "Scroll_ItemMarket_PreBid"),
    notify = UI.getChildControl(Panel_ItemMarket_PreBid_Manager, "StaticText_Notify"),
    notifyBG = UI.getChildControl(Panel_ItemMarket_PreBid_Manager, "Static_NotifyBG"),
    guideMsg = UI.getChildControl(Panel_ItemMarket_PreBid_Manager, "StaticText_UseGuide")
  },
  createUiPool = {},
  createUiSlotCount = 4,
  config = {
    itemEnchantKey = nil,
    isRespone = false,
    scrollStartIdx = 0,
    reservationsCount = 0,
    myTerritoryKeyRaw = 0
  },
  value = {
    invenMoney = toInt64(0, 0),
    wareHouseMoney = toInt64(0, 0),
    minInputMoney = toInt64(0, 0),
    panelDefaultSize = 0,
    notifyDefaultSize = 0
  }
}
ItemMarketPreBid_Manager.ui.scrollBtn = UI.getChildControl(ItemMarketPreBid_Manager.ui.scroll, "Scroll_CtrlButton")
function ItemMarketPreBid_Manager:Init()
  self.ui.notify:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.ui.guideMsg:SetTextMode(UI_TM.eTextMode_AutoWrap)
  self.ui.guideMsg:SetText(PAGetString(Defines.StringSheet_GAME, "GAME_ITEM_MARKET_GUIDEMSG"))
  self.value.notifyDefaultSize = self.ui.notifyBG:GetSizeY()
  self.value.panelDefaultSize = Panel_ItemMarket_PreBid_Manager:GetSizeY()
  for slotIdx = 0, self.createUiSlotCount - 1 do
    local tempSlot = {}
    tempSlot.slotBG = UI.createAndCopyBasePropertyControl(Panel_ItemMarket_PreBid_Manager, "Static_SlotBG", self.ui.bg, "Panel_ItemMarket_PreBid_Manager_ManageList_SlotBG_" .. slotIdx)
    tempSlot.iconBG = UI.createAndCopyBasePropertyControl(Panel_ItemMarket_PreBid_Manager, "Static_Slot_IconBG", tempSlot.slotBG, "Panel_ItemMarket_PreBid_Manager_ManageList_IconBG_" .. slotIdx)
    tempSlot.icon = UI.createAndCopyBasePropertyControl(Panel_ItemMarket_PreBid_Manager, "Static_Slot_Icon", tempSlot.iconBG, "Panel_ItemMarket_PreBid_Manager_ManageList_Icon_" .. slotIdx)
    tempSlot.count = UI.createAndCopyBasePropertyControl(Panel_ItemMarket_PreBid_Manager, "StaticText_Slot_Count", tempSlot.iconBG, "Panel_ItemMarket_PreBid_Manager_ManageList_Count_" .. slotIdx)
    tempSlot.level = UI.createAndCopyBasePropertyControl(Panel_ItemMarket_PreBid_Manager, "StaticText_EnchantLevel", tempSlot.icon, "Panel_ItemMarket_PreBid_Manager_ManageList_Level_" .. slotIdx)
    tempSlot.name = UI.createAndCopyBasePropertyControl(Panel_ItemMarket_PreBid_Manager, "StaticText_Slot_ItemName", tempSlot.slotBG, "Panel_ItemMarket_PreBid_Manager_ManageList_Name_" .. slotIdx)
    tempSlot.reservationPrice = UI.createAndCopyBasePropertyControl(Panel_ItemMarket_PreBid_Manager, "StaticText_Slot_ReservationPrice", tempSlot.slotBG, "Panel_ItemMarket_PreBid_Manager_ManageList_ReservationPrice_" .. slotIdx)
    tempSlot.territory = UI.createAndCopyBasePropertyControl(Panel_ItemMarket_PreBid_Manager, "StaticText_Slot_Territory", tempSlot.slotBG, "Panel_ItemMarket_PreBid_Manager_ManageList_territory_" .. slotIdx)
    tempSlot.cancelBtn = UI.createAndCopyBasePropertyControl(Panel_ItemMarket_PreBid_Manager, "Button_ReservationCancel", tempSlot.slotBG, "Panel_ItemMarket_PreBid_Manager_ManageList_ReservationCancel_" .. slotIdx)
    tempSlot.slotBG:SetShow(false)
    tempSlot.slotBG:SetSpanSize(0, slotIdx + tempSlot.slotBG:GetSizeY() * slotIdx)
    tempSlot.iconBG:SetPosX(5)
    tempSlot.iconBG:SetPosY(12)
    tempSlot.icon:SetPosX(0)
    tempSlot.icon:SetPosY(0)
    tempSlot.name:SetPosX(tempSlot.iconBG:GetPosX() + tempSlot.iconBG:GetSizeX() + 8)
    tempSlot.name:SetPosY(tempSlot.iconBG:GetPosY() - 5)
    tempSlot.reservationPrice:SetPosX(tempSlot.iconBG:GetPosX() + tempSlot.iconBG:GetSizeX() + 8)
    tempSlot.reservationPrice:SetPosY(tempSlot.iconBG:GetPosY() + (tempSlot.name:GetPosY() + tempSlot.name:GetSizeY() - 12))
    tempSlot.territory:SetPosX(tempSlot.iconBG:GetPosX() + tempSlot.iconBG:GetSizeX() + 8)
    tempSlot.territory:SetPosY(tempSlot.iconBG:GetPosY() + (tempSlot.reservationPrice:GetPosY() + tempSlot.reservationPrice:GetSizeY() - 15))
    tempSlot.cancelBtn:SetPosX(tempSlot.slotBG:GetSizeX() - tempSlot.cancelBtn:GetSizeX() - 5)
    tempSlot.cancelBtn:SetPosY(tempSlot.slotBG:GetSizeY() / 2 - tempSlot.cancelBtn:GetSizeY() / 2)
    self.createUiPool[slotIdx] = tempSlot
  end
end
function ItemMarketPreBid_Manager:updateControl()
  Panel_ItemMarket_PreBid_Manager:ComputePos()
  self.ui.btn_Close:ComputePos()
end
function ItemMarketPreBid_Manager:UpdateSlot(dataIdx, uiIdx)
  local tempWrapper = ToClient_GetItemMarketMyReservationByIndex(dataIdx)
  if nil == tempWrapper then
    return
  end
  local itemEnchantKey = tempWrapper:getItemEnchantKey():get()
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemEnchantKey))
  local territoryKey = tempWrapper:getTerritoryKey()
  local reservePrice = tempWrapper:getReservePrice()
  local ranking = tempWrapper:getRanking()
  local leftCount = tempWrapper:getLeftCount()
  local itemName = itemSSW:getName()
  local enchantLevel = itemSSW:get()._key:getEnchantLevel()
  local iconPath = itemSSW:getIconPath()
  local isCash = itemSSW:get():isCash()
  local isRegistHere = self.config.myTerritoryKeyRaw == territoryKey
  local territoryInfoWrapper = getTerritoryInfoWrapper(territoryKey)
  if nil ~= territoryInfoWrapper then
    territoryName = territoryInfoWrapper:getTerritoryName()
  end
  local ui = self.createUiPool[uiIdx]
  ui.slotBG:SetShow(true)
  local nameColorGrade = itemSSW:getGradeType()
  if 0 == nameColorGrade then
    ui.name:SetFontColor(UI_color.C_FFFFFFFF)
  elseif 1 == nameColorGrade then
    ui.name:SetFontColor(4284350320)
  elseif 2 == nameColorGrade then
    ui.name:SetFontColor(4283144191)
  elseif 3 == nameColorGrade then
    ui.name:SetFontColor(4294953010)
  elseif 4 == nameColorGrade then
    ui.name:SetFontColor(4294929408)
  else
    ui.name:SetFontColor(UI_color.C_FFFFFFFF)
  end
  ui.name:SetText(itemName)
  ui.count:SetText(tostring(leftCount))
  if enchantLevel > 0 then
    ui.level:SetShow(true)
  else
    ui.level:SetShow(false)
  end
  if CppEnums.ItemClassifyType.eItemClassify_Accessory == itemSSW:getItemClassify() then
    if 1 == enchantLevel then
      ui.level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_1"))
    elseif 2 == enchantLevel then
      ui.level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_2"))
    elseif 3 == enchantLevel then
      ui.level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_3"))
    elseif 4 == enchantLevel then
      ui.level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_4"))
    elseif 5 == enchantLevel then
      ui.level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_5"))
    end
  elseif enchantLevel > 0 and enchantLevel < 16 then
    ui.level:SetText("+" .. tostring(enchantLevel))
  elseif 16 == enchantLevel then
    ui.level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_1"))
  elseif 17 == enchantLevel then
    ui.level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_2"))
  elseif 18 == enchantLevel then
    ui.level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_3"))
  elseif 19 == enchantLevel then
    ui.level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_4"))
  elseif 20 == enchantLevel then
    ui.level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_5"))
  end
  ui.icon:ChangeTextureInfoName("Icon/" .. iconPath)
  ui.reservationPrice:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_PREBID_RESERVATION_PRICE", "price", makeDotMoney(reservePrice)))
  ui.territory:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_PREBID_RESERVATION_TERRITORY", "territoryName", territoryName))
  ui.cancelBtn:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketPreBid_Manager_ReservationCancel( " .. dataIdx .. " )")
  ui.cancelBtn:SetIgnore(not isRegistHere)
  ui.cancelBtn:SetMonoTone(not isRegistHere)
end
function ItemMarketPreBid_Manager:Update()
  for uiIdx = 0, self.createUiSlotCount - 1 do
    local ui = self.createUiPool[uiIdx]
    ui.slotBG:SetShow(false)
    ui.cancelBtn:addInputEvent("Mouse_LUp", "")
  end
  local territoryName = ""
  local territoryInfoWrapper = getTerritoryInfoWrapper(self.config.myTerritoryKeyRaw)
  if nil ~= territoryInfoWrapper then
    territoryName = territoryInfoWrapper:getTerritoryName()
  end
  self.ui.notify:SetShow(true)
  self.ui.notify:SetText(PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_PREBID_MANAGER_NOTIFY", "territoryName", territoryName))
  local notifyGap = self.ui.notify:GetTextSizeY() - self.value.notifyDefaultSize + 15
  self.ui.notifyBG:SetSize(self.ui.notifyBG:GetSizeX(), self.value.notifyDefaultSize + notifyGap)
  self.ui.notify:SetSize(self.ui.notifyBG:GetSizeX() - 10, self.ui.notifyBG:GetSizeY() - 10)
  Panel_ItemMarket_PreBid_Manager:SetSize(Panel_ItemMarket_PreBid_Manager:GetSizeX(), self.value.panelDefaultSize + notifyGap)
  self.ui.notify:ComputePos()
  self:updateControl()
  self.ui.guideMsg:SetShow(false)
  self.ui.scroll:SetShow(false)
  self.config.reservationsCount = ToClient_GetItemMarketMyReservationsCount()
  if 0 >= self.config.reservationsCount then
    self.ui.guideMsg:SetShow(true)
    return
  end
  local uiIdx = 0
  for itemIdx = self.config.scrollStartIdx, self.config.reservationsCount - 1 do
    if uiIdx > self.createUiSlotCount - 1 then
      break
    end
    local tempWrapper = ToClient_GetItemMarketMyReservationByIndex(itemIdx)
    if nil == tempWrapper then
      ItemMarketPreBid_Manager:Close()
      return
    end
    ItemMarketPreBid_Manager:UpdateSlot(itemIdx, uiIdx)
    uiIdx = uiIdx + 1
  end
  UIScroll.SetButtonSize(self.ui.scroll, self.createUiSlotCount, self.config.reservationsCount)
end
function ItemMarketPreBid_Manager:Open()
  if not self.config.isRespone then
    ToClient_RequestItemMarketReservations()
    return
  else
    self.config.reservationsCount = ToClient_GetItemMarketMyReservationsCount()
    local RegionInfoWrapper = ToClient_getRegionInfoWrapperByPosition(getSelfPlayer():get():getPosition())
    local TerritoryKeyRaw = RegionInfoWrapper:getTerritoryKeyRaw()
    self.config.myTerritoryKeyRaw = TerritoryKeyRaw
    if self.config.reservationsCount > 0 then
    else
      self.config.isRespone = false
    end
    Panel_ItemMarket_PreBid_Manager:SetShow(true, true)
    self.ui.scroll:SetControlTop()
    self:updateControl()
    self:Update()
  end
end
function ItemMarketPreBid_Manager:Close()
  Panel_ItemMarket_PreBid_Manager:SetShow(false, true)
  self.config.isRespone = false
  self.config.scrollStartIdx = 0
  self.config.reservationsCount = 0
end
function HandleClicked_ItemMarketPreBid_Manager_ReservationCancel(dataIdx)
  local tempWrapper = ToClient_GetItemMarketMyReservationByIndex(dataIdx)
  if nil ~= tempWrapper then
    do
      local itemEnchantKeyRaw = tempWrapper:getItemEnchantKey():get()
      if nil ~= itemEnchantKeyRaw then
        local function doCancel()
          ToClient_RequestCancelMyReservationForItemMarket(itemEnchantKeyRaw, dataIdx)
          ItemMarketPreBid_Manager:Update()
        end
        local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemEnchantKeyRaw))
        local itemName = itemSSW:getName()
        local messageBoxMemo = PAGetStringParam1(Defines.StringSheet_GAME, "LUA_ITEMMARKET_PREBID_RESERVATION_CANCEL", "itemName", itemName)
        local messageBoxData = {
          title = PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ALERT_NOTIFICATIONS"),
          content = messageBoxMemo,
          functionYes = doCancel,
          functionNo = MessageBox_Empty_function,
          priority = CppEnums.PAUIMB_PRIORITY.PAUIMB_PRIORITY_LOW
        }
        MessageBox.showMessageBox(messageBoxData)
      end
    end
  end
end
function HandleClicked_ItemMarketPreBid_Manager_Close()
  ItemMarketPreBid_Manager:Close()
end
function HandleClicked_ItemMarketPreBid_Manager_ScrollPress()
  local config = ItemMarketPreBid_Manager.config
  local scrollPos = ItemMarketPreBid_Manager.ui.scroll:GetControlPos()
  local resultCount = ItemMarketPreBid_Manager.config.reservationsCount
  local maxViewCount = ItemMarketPreBid_Manager.createUiSlotCount
  ItemMarketPreBid_Manager.config.scrollStartIdx = math.ceil((resultCount - maxViewCount) * scrollPos)
  ItemMarketPreBid_Manager:Update()
end
function ItemMarketPreBid_Manager_Scroll(isUp)
  local scroll = ItemMarketPreBid_Manager.ui.scroll
  local slotCount = ItemMarketPreBid_Manager.createUiSlotCount
  local resultCount = ItemMarketPreBid_Manager.config.reservationsCount
  local startIdx = ItemMarketPreBid_Manager.config.scrollStartIdx
  startIdx = UIScroll.ScrollEvent(scroll, isUp, slotCount, resultCount, startIdx, 1)
  ItemMarketPreBid_Manager.config.scrollStartIdx = startIdx
  ItemMarketPreBid_Manager:Update()
end
function FGlobal_ItemMarketPreBid_Manager_Open()
  if Panel_Window_ItemMarket:GetShow() then
    FGolbal_ItemMarketNew_Close()
  end
  if Panel_Window_ItemMarket_ItemSet:GetShow() then
    FGlobal_ItemMarketItemSet_Close()
  end
  if Panel_Window_ItemMarket_BuyConfirm:GetShow() then
    FGlobal_ItemMarket_BuyConfirm_Close()
  end
  if Panel_ItemMarket_AlarmList:GetShow() then
    FGlobal_ItemMarketAlarmList_Close()
  end
  if Panel_Window_ItemMarket_RegistItem:GetShow() then
    FGlobal_ItemMarketRegistItem_Close()
  end
  ItemMarketPreBid_Manager:Open()
end
function FGlobal_ItemMarketPreBid_Manager_Close()
  ItemMarketPreBid_Manager:Close()
end
function FGlobal_ItemMarketPreBid_Manager_Update()
  ItemMarketPreBid_Manager:Update()
end
function FromClient_responseMyItemMarketReservationInfo()
  ItemMarketPreBid_Manager.config.isRespone = true
  ItemMarketPreBid_Manager:Open()
end
function ItemMarketPreBid_Manager:registEventHandler()
  self.ui.bg:addInputEvent("Mouse_UpScroll", "ItemMarketPreBid_Manager_Scroll( true )")
  self.ui.bg:addInputEvent("Mouse_DownScroll", "ItemMarketPreBid_Manager_Scroll( false )")
  self.ui.scroll:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketPreBid_Manager_ScrollPress()")
  self.ui.scrollBtn:addInputEvent("Mouse_LPress", "HandleClicked_ItemMarketPreBid_Manager_ScrollPress()")
  self.ui.btn_Close:addInputEvent("Mouse_LUp", "HandleClicked_ItemMarketPreBid_Manager_Close()")
end
function ItemMarketPreBid_Manager:registMessageHandler()
  registerEvent("FromClient_responseMyItemMarketReservationInfo", "FromClient_responseMyItemMarketReservationInfo")
end
ItemMarketPreBid_Manager:Init()
ItemMarketPreBid_Manager:registEventHandler()
ItemMarketPreBid_Manager:registMessageHandler()

Panel_WorkerTrade_DropItem:SetShow(false, false)
Panel_WorkerTrade_DropItem:setGlassBackground(true)
Panel_WorkerTrade_DropItem:SetDragAll(true)
Panel_WorkerTrade_DropItem:RegisterShowEventFunc(true, "Panel_WorkerTrade_DropItem_ShowAni()")
Panel_WorkerTrade_DropItem:RegisterShowEventFunc(false, "Panel_WorkerTrade_DropItem_HideAni()")
local UI_TM = CppEnums.TextMode
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_PSFT = CppEnums.PAUI_SHOW_FADE_TYPE
local UI_color = Defines.Color
local isWorkerTradeContentOpen = ToClient_IsContentsGroupOpen("209")
function Panel_WorkerTrade_DropItem_ShowAni()
  UIAni.fadeInSCR_Down(Panel_WorkerTrade_DropItem)
  local aniInfo1 = Panel_WorkerTrade_DropItem:addScaleAnimation(0, 0.08, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo1:SetStartScale(0.5)
  aniInfo1:SetEndScale(1.1)
  aniInfo1.AxisX = Panel_WorkerTrade_DropItem:GetSizeX() / 2
  aniInfo1.AxisY = Panel_WorkerTrade_DropItem:GetSizeY() / 2
  aniInfo1.ScaleType = 2
  aniInfo1.IsChangeChild = true
  local aniInfo2 = Panel_WorkerTrade_DropItem:addScaleAnimation(0.08, 0.15, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo2:SetStartScale(1.1)
  aniInfo2:SetEndScale(1)
  aniInfo2.AxisX = Panel_WorkerTrade_DropItem:GetSizeX() / 2
  aniInfo2.AxisY = Panel_WorkerTrade_DropItem:GetSizeY() / 2
  aniInfo2.ScaleType = 2
  aniInfo2.IsChangeChild = true
end
function Panel_WorkerTrade_DropItem_HideAni()
  Panel_WorkerTrade_DropItem:SetShowWithFade(UI_PSFT.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_WorkerTrade_DropItem:addColorAnimation(0, 0.25, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local workerTradeDropItem = {
  control = {
    _btnClose = UI.getChildControl(Panel_WorkerTrade_DropItem, "Button_Close"),
    _slot = {
      [0] = UI.getChildControl(Panel_WorkerTrade_DropItem, "Static_Slot0"),
      [1] = UI.getChildControl(Panel_WorkerTrade_DropItem, "Static_Slot1"),
      [2] = UI.getChildControl(Panel_WorkerTrade_DropItem, "Static_Slot2"),
      [3] = UI.getChildControl(Panel_WorkerTrade_DropItem, "Static_Slot3"),
      [4] = UI.getChildControl(Panel_WorkerTrade_DropItem, "Static_Slot4"),
      [5] = UI.getChildControl(Panel_WorkerTrade_DropItem, "Static_Slot5"),
      [6] = UI.getChildControl(Panel_WorkerTrade_DropItem, "Static_Slot6"),
      [7] = UI.getChildControl(Panel_WorkerTrade_DropItem, "Static_Slot7"),
      [8] = UI.getChildControl(Panel_WorkerTrade_DropItem, "Static_Slot8"),
      [9] = UI.getChildControl(Panel_WorkerTrade_DropItem, "Static_Slot9")
    },
    _btnRecieve = UI.getChildControl(Panel_WorkerTrade_DropItem, "Button_ItemRecieve")
  },
  _maxCount = 10,
  _itemSlot = {},
  _config = {createBorder = true, createCount = true}
}
function workerTradeDropItem:Update()
  local tradeCompanyWrapper = ToClient_GetTradeCompanyWrapper()
  local dropItemCount = tradeCompanyWrapper:getObtainItemListSize()
  for index = 0, self._maxCount - 1 do
    self._itemSlot[index]:clearItem()
    self._itemSlot[index].icon:addInputEvent("Mouse_Out", "WorkerTrade_ItemToolTipShow()")
    if index < dropItemCount then
      local itemEnchantKey = tradeCompanyWrapper:getObtainItemEnchantKey(index)
      local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemEnchantKey))
      local haveCount = tradeCompanyWrapper:getObtainItemCount(index)
      self._itemSlot[index]:setItemByStaticStatus(itemSSW, haveCount)
      self._itemSlot[index].icon:addInputEvent("Mouse_On", "WorkerTrade_ItemToolTipShow(" .. index .. ")")
    else
      self._itemSlot[index].icon:addInputEvent("Mouse_On", "WorkerTrade_ItemToolTipShow()")
    end
  end
end
function WorkerTrade_getItemToWarehouse(index)
  ToClient_RequestAcceptObtainElement(index)
end
function WorkerTrade_ItemToolTipShow(index)
  if nil == index then
    Panel_Tooltip_Item_hideTooltip()
    return
  end
  local self = workerTradeDropItem
  local tradeCompanyWrapper = ToClient_GetTradeCompanyWrapper()
  local itemEnchantKey = tradeCompanyWrapper:getObtainItemEnchantKey(index)
  local itemSSW = getItemEnchantStaticStatus(ItemEnchantKey(itemEnchantKey))
  Panel_Tooltip_Item_Show(itemSSW, self._itemSlot[index].icon, true, false)
end
function WorkerTradeDropItem_RecieveAll()
  local tradeCompanyWrapper = ToClient_GetTradeCompanyWrapper()
  local dropItemCount = tradeCompanyWrapper:getObtainItemListSize()
  if dropItemCount > 0 then
    for index = 0, dropItemCount - 1 do
      ToClient_RequestAcceptObtainElement(index)
    end
  end
  workerTradeDropItem:Update()
end
function workerTradeDropItem:Show()
  local tradeCompanyWrapper = ToClient_GetTradeCompanyWrapper()
  local dropItemCount = tradeCompanyWrapper:getObtainItemListSize()
  if dropItemCount <= 0 then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_WORKERTRADEDROPITEM_ALERT"))
    return
  end
  WorldMapPopupManager:increaseLayer(true)
  WorldMapPopupManager:push(Panel_WorkerTrade_DropItem, true)
  self:Update()
end
function workerTradeDropItem:Hide()
  WorldMapPopupManager:pop()
end
function FGlobal_WorkerTradeTreasure_ShowToggle()
  if Panel_WorkerTrade_DropItem:GetShow() then
    workerTradeDropItem:Hide()
  else
    workerTradeDropItem:Show()
  end
end
function workerTradeDropItem:registerEvent()
  self.control._btnClose:addInputEvent("Mouse_LUp", "FGlobal_WorkerTradeTreasure_ShowToggle()")
  self.control._btnRecieve:addInputEvent("Mouse_LUp", "WorkerTradeDropItem_RecieveAll()")
  for index = 0, self._maxCount - 1 do
    local temp = {}
    SlotItem.new(temp, "DropItemSlot_", index, self.control._slot[index], self._config)
    temp:createChild()
    temp.icon:SetPosX(4)
    temp.icon:SetPosY(4)
    self._itemSlot[index] = temp
  end
end
workerTradeDropItem:registerEvent()

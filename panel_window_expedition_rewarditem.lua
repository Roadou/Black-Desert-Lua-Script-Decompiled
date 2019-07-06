local expeditionRewardItemInfo = {
  _ui = {
    _button_close = UI.getChildControl(Panel_Subjugation_Item, "Button_Win_Close"),
    _button_allReceive = UI.getChildControl(Panel_Subjugation_Item, "Button_AllGet"),
    _button_selectReceive = UI.getChildControl(Panel_Subjugation_Item, "Button_Select"),
    _button_cancel = UI.getChildControl(Panel_Subjugation_Item, "Button_Cancel")
  },
  _config = {_rewardItemMaxCount = 55},
  _slotConfig = {
    createIcon = true,
    createBorder = true,
    createEnchant = true,
    createCount = true
  },
  _rewardItemSlot = Array.new(),
  _selectItemEnchantKeyList = Array.new()
}
function expeditionRewardItemInfo:initialize()
  self:createControl()
  self:registEventHandler()
  Panel_Subjugation_Item:SetShow(false)
end
function expeditionRewardItemInfo:createControl()
  local itemBG = UI.getChildControl(Panel_Subjugation_Item, "Static_MiddleBG")
  local baseSlotBg = UI.getChildControl(itemBG, "Static_ItemSlotBG")
  local baseSelectSlotBg = UI.getChildControl(baseSlotBg, "Static_SelectSlot")
  self._rewardItemSlot = Array.new()
  for ii = 0, self._config._rewardItemMaxCount - 1 do
    local slot = {
      background = nil,
      select = nil,
      icon = nil,
      itemEnchantKey = nil
    }
    slot.background = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, itemBG, "RewardItemBG_" .. ii)
    CopyBaseProperty(baseSlotBg, slot.background)
    slot.background:SetPosX(28 + ii % 11 * 55)
    slot.background:SetPosY(22 + math.floor(ii / 11) * 55)
    slot.background:SetShow(true)
    SlotItem.new(slot, "RewardItemIcon_" .. ii, ii, slot.background, self._slotConfig)
    slot:createChild()
    slot.icon:SetPosX(0)
    slot.icon:SetPosY(0)
    slot.icon:SetShow(true)
    slot.icon:addInputEvent("Mouse_LUp", "PaGlobalFunc_Expedition_SelectRewardItem(" .. ii .. ")")
    slot.icon:addInputEvent("Mouse_On", "PaGlobalFunc_Expedition_RewardItemToolTip(" .. ii .. ")")
    slot.icon:addInputEvent("Mouse_Out", "PaGlobalFunc_Expedition_RewardItemToolTipOut()")
    slot.select = UI.createControl(CppEnums.PA_UI_CONTROL_TYPE.PA_UI_CONTROL_STATIC, slot.background, "SelectItemBG_" .. ii)
    CopyBaseProperty(baseSelectSlotBg, slot.select)
    slot.select:SetPosX(0)
    slot.select:SetPosY(0)
    slot.select:SetShow(false)
    slot.select:addInputEvent("Mouse_LUp", "PaGlobalFunc_Expedition_SelectRewardItem(" .. ii .. ")")
    slot.select:addInputEvent("Mouse_On", "PaGlobalFunc_Expedition_RewardItemToolTip(" .. ii .. ")")
    slot.select:addInputEvent("Mouse_Out", "PaGlobalFunc_Expedition_RewardItemToolTipOut()")
    self._rewardItemSlot[ii] = slot
  end
  deleteControl(baseSlotBg)
end
function expeditionRewardItemInfo:registEventHandler()
  self._ui._button_close:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionRewardItemInfo_Close()")
  self._ui._button_cancel:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionRewardItemInfo_Close()")
  self._ui._button_selectReceive:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionRewardItemInfo_ReceiveItem(false)")
  self._ui._button_allReceive:addInputEvent("Mouse_LUp", "PaGlobalFunc_ExpeditionRewardItemInfo_ReceiveItem(true)")
end
function expeditionRewardItemInfo:open()
  self:refreshItemList()
  Panel_Subjugation_Item:SetShow(true)
end
function expeditionRewardItemInfo:close()
  Panel_Subjugation_Item:SetShow(false)
end
function expeditionRewardItemInfo:refreshItemList()
  local itemKeyList = ToClient_ExpeditionRewardItemKeyList()
  if nil == itemKeyList then
    for ii = 0, self._config._rewardItemMaxCount - 1 do
      local rewardSlot = self._rewardItemSlot[ii]
      rewardSlot:clearItem()
      rewardSlot.itemEnchantKey = nil
      rewardSlot.select:SetShow(false)
    end
  else
    for ii = 0, self._config._rewardItemMaxCount - 1 do
      local rewardSlot = self._rewardItemSlot[ii]
      rewardSlot.select:SetShow(false)
      if ii <= #itemKeyList then
        local itemKey = itemKeyList[ii]
        local itemSSW = getItemEnchantStaticStatus(itemKey)
        local itemCount = ToClient_ExpeditionRewardItemCount(itemKey)
        rewardSlot:setItemByStaticStatus(itemSSW, itemCount)
        rewardSlot.itemEnchantKey = itemKey
      else
        rewardSlot:clearItem()
        rewardSlot.itemEnchantKey = nil
      end
    end
  end
end
function PaGlobalFunc_ExpeditionRewardItemInfo_Open()
  local self = expeditionRewardItemInfo
  self:open()
end
function PaGlobalFunc_ExpeditionReportInfo_Open()
  local self = expeditionRewardItemInfo
  self:open()
end
function PaGlobalFunc_ExpeditionRewardItemInfo_Close()
  local self = expeditionRewardItemInfo
  self:close()
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobalFunc_Expedition_SelectRewardItem(slotIndex)
  local self = expeditionRewardItemInfo
  local rewardSlot = self._rewardItemSlot[slotIndex]
  if true == rewardSlot.select:GetShow() then
    rewardSlot.select:SetShow(false)
    self._selectItemEnchantKeyList[slotIndex] = nil
  elseif nil ~= rewardSlot.itemEnchantKey then
    rewardSlot.select:SetShow(true)
    self._selectItemEnchantKeyList[slotIndex] = rewardSlot.itemEnchantKey
  end
end
function PaGlobalFunc_Expedition_RewardItemToolTip(slotIndex)
  local self = expeditionRewardItemInfo
  local rewardSlot = self._rewardItemSlot[slotIndex]
  if nil ~= rewardSlot.itemEnchantKey then
    local itemSSW = getItemEnchantStaticStatus(rewardSlot.itemEnchantKey)
    if nil ~= itemSSW then
      Panel_Tooltip_Item_Show(itemSSW, rewardSlot.icon, true)
    end
  end
end
function PaGlobalFunc_Expedition_RewardItemToolTipOut()
  Panel_Tooltip_Item_hideTooltip()
end
function PaGlobalFunc_ExpeditionRewardItemInfo_ReceiveItem(isAll)
  local self = expeditionRewardItemInfo
  if true == isAll then
    ToClient_ReceiveExpeditionRewardItemAll()
  else
    for ii = 0, self._config._rewardItemMaxCount - 1 do
      local itemEnchantKey = self._selectItemEnchantKeyList[ii]
      if nil ~= itemEnchantKey then
        _PA_LOG("\235\176\149\234\183\156\235\130\152_\237\134\160\235\178\140", "\236\132\160\237\131\157\235\176\155\234\184\176" .. ii .. "/" .. tostring(itemEnchantKey))
        ToClient_ReceiveExpeditionRewardItem(itemEnchantKey)
      end
    end
  end
  for ii = 0, self._config._rewardItemMaxCount - 1 do
    self._selectItemEnchantKeyList[ii] = nil
  end
end
function FromClient_ExpeditionRewardItemInfo_Initialize()
  expeditionRewardItemInfo:initialize()
end
function FromClient_refreshExpeditionItemList(isDelete)
  local self = expeditionRewardItemInfo
  self:refreshItemList()
  if true == isDelete then
    Proc_ShowMessage_Ack(PAGetString(Defines.StringSheet_GAME, "LUA_EXPEDITION_REWARDITEM_GET"))
  end
end
registerEvent("FromClient_luaLoadComplete", "FromClient_ExpeditionRewardItemInfo_Initialize")
registerEvent("FromClient_refreshExpeditionItemList", "FromClient_refreshExpeditionItemList")

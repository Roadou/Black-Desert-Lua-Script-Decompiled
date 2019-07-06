Panel_RemoteEquipment:SetShow(false)
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
local remoteEquip = {
  normalEquipSlotBg = {},
  normalEquipSlot = {},
  cashEquipSlotBg = {},
  cashEquipSlot = {},
  normalEquipCount = 16,
  cashEquipCount = 11,
  config = {
    createBorder = true,
    createIcon = true,
    createRemoteEnchant = true,
    createCash = true,
    createExpirationBG = true,
    createExpiration2h = true
  },
  equipNoMin = CppEnums.EquipSlotNo.rightHand,
  EquipNoMax = CppEnums.EquipSlotNo.equipSlotNoCount,
  attackValue = UI.getChildControl(Panel_RemoteEquipment, "StaticText_AttackValue"),
  deffenceValue = UI.getChildControl(Panel_RemoteEquipment, "StaticText_DefenceValue"),
  awakenValue = UI.getChildControl(Panel_RemoteEquipment, "StaticText_AwakenValue")
}
local remoteEquipSlotId = {
  normal = {
    [1] = 6,
    [2] = 0,
    [3] = 29,
    [4] = 1,
    [5] = 10,
    [6] = 3,
    [7] = 4,
    [8] = 5,
    [9] = 12,
    [10] = 11,
    [11] = 7,
    [12] = 8,
    [13] = 9,
    [14] = 27,
    [15] = 13,
    [16] = 2
  },
  cash = {
    [1] = 17,
    [2] = 14,
    [3] = 15,
    [4] = 16,
    [5] = 18,
    [6] = 20,
    [7] = 19,
    [8] = 30,
    [9] = 21,
    [10] = 22,
    [11] = 23
  }
}
function remoteEquip:Init()
  for index = 1, self.normalEquipCount do
    self.normalEquipSlotBg[index] = UI.getChildControl(Panel_RemoteEquipment, "Static_SlotBG" .. index)
    local slot = {}
    SlotItem.new(slot, "RemoteEquipNormalIcon_" .. index, index, self.normalEquipSlotBg[index], self.config)
    slot.icon:SetSize(self.normalEquipSlotBg[index]:GetSizeX() - 2, self.normalEquipSlotBg[index]:GetSizeY() - 2)
    slot.icon:SetPosX(1)
    slot.icon:SetPosY(1)
    slot:createChild()
    slot.border:SetSize(self.normalEquipSlotBg[index]:GetSizeX(), self.normalEquipSlotBg[index]:GetSizeY())
    slot.expiration2h:SetSize(self.normalEquipSlotBg[index]:GetSizeX(), self.normalEquipSlotBg[index]:GetSizeY())
    slot.expirationBG:SetSize(self.normalEquipSlotBg[index]:GetSizeX(), self.normalEquipSlotBg[index]:GetSizeY())
    slot.remoteEnchantText:SetSize(self.normalEquipSlotBg[index]:GetSizeX() - 2, self.normalEquipSlotBg[index]:GetSizeY() - 2)
    self.normalEquipSlot[index] = slot
  end
  for index = 1, self.cashEquipCount do
    self.cashEquipSlotBg[index] = UI.getChildControl(Panel_RemoteEquipment, "Static_CashSlotBG" .. index)
    local slot = {}
    SlotItem.new(slot, "RemoteEquipNormalIcon_" .. index, index, self.cashEquipSlotBg[index], self.config)
    slot.icon:SetSize(self.cashEquipSlotBg[index]:GetSizeX() - 2, self.cashEquipSlotBg[index]:GetSizeY() - 2)
    slot.icon:SetPosX(1)
    slot.icon:SetPosY(1)
    slot:createChild()
    slot.border:SetSize(self.cashEquipSlotBg[index]:GetSizeX(), self.cashEquipSlotBg[index]:GetSizeY())
    slot.expiration2h:SetSize(self.cashEquipSlotBg[index]:GetSizeX(), self.cashEquipSlotBg[index]:GetSizeY())
    slot.expirationBG:SetSize(self.cashEquipSlotBg[index]:GetSizeX(), self.cashEquipSlotBg[index]:GetSizeY())
    slot.remoteEnchantText:SetSize(self.cashEquipSlotBg[index]:GetSizeX() - 2, self.cashEquipSlotBg[index]:GetSizeY() - 2)
    slot.isCash:SetSize(70, 70)
    slot.isCash:SetPosX(1)
    slot.isCash:SetPosY(1)
    self.cashEquipSlot[index] = slot
  end
end
function remoteEquip:Update()
  for index = 1, #remoteEquipSlotId.normal do
    local itemWrapper = ToClient_getEquipmentItem(remoteEquipSlotId.normal[index])
    if nil ~= itemWrapper then
      local slot = self.normalEquipSlot[index]
      slot:setItem(itemWrapper)
      slot.icon:addInputEvent("Mouse_LUp", "RemoteEquip_Unequip(" .. index .. ", false )")
      slot.icon:addInputEvent("Mouse_RUp", "RemoteEquip_Unequip(" .. index .. ", false )")
    else
      local slot = self.normalEquipSlot[index]
      slot:clearItem()
    end
  end
  for index = 1, #remoteEquipSlotId.cash do
    local itemWrapper = ToClient_getEquipmentItem(remoteEquipSlotId.cash[index])
    if nil ~= itemWrapper then
      local slot = self.cashEquipSlot[index]
      slot:setItem(itemWrapper)
      slot.icon:addInputEvent("Mouse_LUp", "RemoteEquip_Unequip(" .. index .. ", true )")
      slot.icon:addInputEvent("Mouse_RUp", "RemoteEquip_Unequip(" .. index .. ", true )")
    else
      local slot = self.cashEquipSlot[index]
      slot:clearItem()
    end
  end
  RemoteEquip_UpdateStat()
end
function RemoteEquip_Unequip(index, isCash)
  local slotNo
  if isCash then
    slotNo = remoteEquipSlotId.cash[index]
  else
    slotNo = remoteEquipSlotId.normal[index]
  end
  local itemWrapper = ToClient_getEquipmentItem(slotNo)
  if nil ~= itemWrapper then
    equipmentDoUnequip(slotNo)
  end
end
function remoteEquip:Open()
  self:Update()
  Panel_RemoteEquipment:SetShow(true)
  Panel_RemoteEquipment:SetPosX(Panel_RemoteInventory:GetPosX() - Panel_RemoteEquipment:GetSizeX() - 10)
  Panel_RemoteEquipment:SetPosY(getScreenSizeY() / 2 - Panel_RemoteEquipment:GetSizeY() / 2)
end
function remoteEquip:Close()
  Panel_RemoteEquipment:SetShow(false)
end
function FGlobal_RemoteEquip_ShowToggle()
  if Panel_RemoteEquipment:GetShow() then
    remoteEquip:Close()
  else
    remoteEquip:Open()
  end
end
function RemoteEquip_UpdateSlot()
  remoteEquip:Update()
end
function RemoteEquip_UpdateStat()
  local self = remoteEquip
  local attackValue = ToClient_getOffence()
  local deffenceValue = ToClient_getDefence()
  local awakenValue = ToClient_getAwakenOffence()
  self.attackValue:SetText("\234\179\181\234\178\169\235\160\165 : " .. attackValue)
  self.deffenceValue:SetText("\235\176\169\236\150\180\235\160\165 : " .. deffenceValue)
  self.awakenValue:SetText("\234\176\129\236\132\177\235\172\180\234\184\176 \234\179\181\234\178\169\235\160\165 : " .. awakenValue)
  local isSetAwakenWeapon = ToClient_getEquipmentItem(CppEnums.EquipSlotNo.awakenWeapon)
  if nil ~= isSetAwakenWeapon then
    self.awakenValue:SetShow(true)
  else
    self.awakenValue:SetShow(false)
  end
end
remoteEquip:Init()
remoteEquip:Update()
registerEvent("EventEquipmentUpdate", "RemoteEquip_UpdateSlot")

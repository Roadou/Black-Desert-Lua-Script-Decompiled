if nil == UI then
  UI = {}
end
local UCT = CppEnums.PA_UI_CONTROL_TYPE
local UI_color = Defines.Color
UI.itemSlotConfig = {
  borderTexture = {
    [0] = nil,
    [1] = {
      texture = "new_ui_common_forlua/window/skill/skill_ui_00.dds",
      x1 = 172,
      y1 = 44,
      x2 = 214,
      y2 = 86
    },
    [2] = {
      texture = "new_ui_common_forlua/window/skill/skill_ui_00.dds",
      x1 = 172,
      y1 = 1,
      x2 = 214,
      y2 = 43
    },
    [3] = {
      texture = "new_ui_common_forlua/window/skill/skill_ui_00.dds",
      x1 = 129,
      y1 = 1,
      x2 = 171,
      y2 = 43
    },
    [4] = {
      texture = "new_ui_common_forlua/window/skill/skill_ui_00.dds",
      x1 = 129,
      y1 = 44,
      x2 = 171,
      y2 = 86
    }
  },
  borderTextureForRenewUI = {
    [0] = nil,
    [1] = {
      texture = "Renewal/Frame/Console_Frame_00.dds",
      x1 = 167,
      y1 = 108,
      x2 = 187,
      y2 = 128
    },
    [2] = {
      texture = "Renewal/Frame/Console_Frame_00.dds",
      x1 = 188,
      y1 = 108,
      x2 = 208,
      y2 = 128
    },
    [3] = {
      texture = "Renewal/Frame/Console_Frame_00.dds",
      x1 = 209,
      y1 = 108,
      x2 = 229,
      y2 = 128
    },
    [4] = {
      texture = "Renewal/Frame/Console_Frame_00.dds",
      x1 = 230,
      y1 = 108,
      x2 = 250,
      y2 = 128
    }
  },
  borderTextureForAllUI = {
    [0] = {
      texture = "Combine/Frame/Combine_Frame_00.dds",
      x1 = 1,
      y1 = 228,
      x2 = 45,
      y2 = 272
    },
    [1] = {
      texture = "Combine/Frame/Combine_Frame_00.dds",
      x1 = 46,
      y1 = 228,
      x2 = 90,
      y2 = 272
    },
    [2] = {
      texture = "Combine/Frame/Combine_Frame_00.dds",
      x1 = 91,
      y1 = 228,
      x2 = 135,
      y2 = 272
    },
    [3] = {
      texture = "Combine/Frame/Combine_Frame_00.dds",
      x1 = 136,
      y1 = 228,
      x2 = 180,
      y2 = 272
    },
    [4] = {
      texture = "Combine/Frame/Combine_Frame_00.dds",
      x1 = 181,
      y1 = 228,
      x2 = 225,
      y2 = 272
    }
  },
  expirationTexture = {
    [0] = {
      texture = "new_ui_common_forlua/Window/inventory/inventory_01.dds",
      x1 = 45,
      y1 = 1,
      x2 = 58,
      y2 = 14
    },
    [1] = {
      texture = "new_ui_common_forlua/Window/inventory/inventory_01.dds",
      x1 = 45,
      y1 = 15,
      x2 = 58,
      y2 = 28
    },
    [2] = {
      texture = "new_ui_common_forlua/Window/inventory/inventory_01.dds",
      x1 = 45,
      y1 = 29,
      x2 = 58,
      y2 = 42
    }
  },
  checkBtnTexture = {
    [0] = {
      texture = "new_ui_common_forlua/default/default_buttons_02.dds",
      x1 = 103,
      y1 = 162,
      x2 = 130,
      y2 = 189
    },
    {
      texture = "new_ui_common_forlua/default/default_buttons_02.dds",
      x1 = 133,
      y1 = 162,
      x2 = 160,
      y2 = 189
    },
    {
      texture = "new_ui_common_forlua/default/default_buttons_02.dds",
      x1 = 163,
      y1 = 162,
      x2 = 190,
      y2 = 189
    }
  },
  iconSize = 42,
  borderSize = 42,
  borderPos = -1,
  countSpanSizeX = 10,
  countSpanSizeY = 4,
  expirationSize = 15,
  expirationPosX = 1,
  expirationPosY = 30,
  expirationBGSize = 43,
  expiration2hSize = 43,
  isCashSize = 28,
  isCashPosX = 0,
  isCashPosY = 0,
  disableClass = 12,
  checkBtnSize = 19
}
SlotItem = {}
SlotItem.__index = SlotItem
function SlotItem.new(itemSlot, id, slotNo, parent, param)
  if nil == itemSlot then
    itemSlot = {}
  end
  setmetatable(itemSlot, SlotItem)
  itemSlot.slotNo = slotNo
  itemSlot.param = param
  itemSlot.id = id
  local _config = UI.itemSlotConfig
  if nil == itemSlot.icon then
    itemSlot.icon = UI.createControl(UCT.PA_UI_CONTROL_STATIC, parent, "Static_" .. id)
  end
  itemSlot.icon:SetSize(UI.itemSlotConfig.iconSize, UI.itemSlotConfig.iconSize)
  itemSlot.icon:ActiveMouseEventEffect(true)
  itemSlot.icon:SetIgnore(false)
  return itemSlot
end
function SlotItem:createChild()
  local _config = UI.itemSlotConfig
  if true == self.param.createBorder and nil == self.border then
    self.border = UI.createControl(UCT.PA_UI_CONTROL_STATIC, self.icon, "Static_" .. self.id .. "_Border")
    self.border:SetSize(45, 45)
    self.border:SetPosX(_config.borderPos)
    self.border:SetPosY(_config.borderPos)
    self.border:SetIgnore(true)
  end
  if true == self.param.createExpiration2h and nil == self.Expiration2h then
    local expire2h = UI.getChildControl(PaGlobal_GetPanelWindowInventory(), "Static_Expire_2h")
    self.expiration2h = UI.createControl(UCT.PA_UI_CONTROL_STATIC, self.icon, "Static_" .. self.id .. "Expiration2h")
    CopyBaseProperty(expire2h, self.expiration2h)
    self.expiration2h:SetSize(_config.expiration2hSize, _config.expiration2hSize)
    self.expiration2h:SetPosX(_config.borderPos)
    self.expiration2h:SetPosY(_config.borderPos)
    self.expiration2h:SetIgnore(true)
  end
  if true == self.param.createExpirationBG and nil == self.ExpirationBG then
    self.expirationBG = UI.createControl(UCT.PA_UI_CONTROL_STATIC, self.icon, "Static_" .. self.id .. "ExpirationBG")
    self.expirationBG:SetSize(_config.expirationBGSize, _config.expirationBGSize)
    self.expirationBG:SetPosX(_config.borderPos)
    self.expirationBG:SetPosY(_config.borderPos)
    self.expirationBG:SetIgnore(true)
  end
  if true == self.param.createEnchant and nil == self.enchantText then
    self.enchantText = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self.icon, "StaticText_" .. self.id .. "_Enchant")
    local enchantNumber = UI.getChildControl(PaGlobal_GetPanelWindowInventory(), "Static_Text_Slot_Enchant_value")
    CopyBaseProperty(enchantNumber, self.enchantText)
    self.enchantText:SetSize(self.icon:GetSizeX(), self.icon:GetSizeY())
    self.enchantText:SetPosX(0)
    self.enchantText:SetPosY(0)
    self.enchantText:SetTextHorizonCenter()
    self.enchantText:SetTextVerticalCenter()
    self.enchantText:SetIgnore(true)
  end
  if true == self.param.createRemoteEnchant and nil == self.remoteEnchantText then
    self.remoteEnchantText = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self.icon, "StaticText_" .. self.id .. "_RemoteEnchant")
    local remoteEnchantNumber = UI.getChildControl(Panel_RemoteInventory, "StaticText_RemoteSlot_Enchantvalue")
    CopyBaseProperty(remoteEnchantNumber, self.remoteEnchantText)
    self.remoteEnchantText:SetPosX(0)
    self.remoteEnchantText:SetPosY(0)
    self.remoteEnchantText:SetTextHorizonCenter()
    self.remoteEnchantText:SetTextVerticalCenter()
    self.remoteEnchantText:SetIgnore(true)
  end
  if true == self.param.createCooltime and nil == self.cooltime then
    self.cooltime = UI.createCustomControl("StaticCooltime", self.icon, "StaticCooltime_" .. self.id)
    self.cooltime:SetSize(self.icon:GetSizeX(), self.icon:GetSizeY())
    self.cooltime:SetIgnore(true)
    self.cooltime:SetShow(false)
  end
  if true == self.param.createCount and nil == self.count then
    self.count = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self.icon, "StaticText_" .. self.id .. "_Count")
    local stackCount = UI.getChildControl(PaGlobal_GetPanelWindowInventory(), "Static_Text_Slot_StackCount_value")
    CopyBaseProperty(stackCount, self.count)
    self.count:SetSize(self.icon:GetSizeX() - 3, self.icon:GetSizeY() / 2)
    self.count:SetTextHorizonRight()
    self.count:SetTextVerticalBottom()
    self.count:SetIgnore(true)
  end
  if true == self.param.createMailCount and nil == self.mailCount then
    self.mailCount = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self.icon, "StaticText_" .. self.id .. "_MailCount")
    local mailStackCount = UI.getChildControl(PaGlobal_GetPanelWindowInventory(), "Static_Text_Slot_MailStackCount_value")
    CopyBaseProperty(mailStackCount, self.mailCount)
    self.mailCount:SetSize(self.icon:GetSizeX() - 3, self.icon:GetSizeY() / 2)
    self.mailCount:SetTextHorizonRight()
    self.mailCount:SetTextVerticalBottom()
    self.mailCount:SetIgnore(true)
  end
  if true == self.param.createExpiration and nil == self.expiration then
    self.expiration = UI.createControl(UCT.PA_UI_CONTROL_STATIC, self.icon, "Static_" .. self.id .. "_expiration")
    self.expiration:SetSize(_config.expirationSize, _config.expirationSize)
    self.expiration:SetPosX(_config.expirationPosX)
    self.expiration:SetPosY(_config.expirationPosY)
    self.expiration:SetIgnore(true)
  end
  if true == self.param.createCash and nil == self.isCash then
    self.isCash = UI.createControl(UCT.PA_UI_CONTROL_STATIC, self.icon, "Static_" .. self.id .. "_isCash")
    self.isCash:SetSize(_config.isCashSize, _config.isCashSize)
    self.isCash:SetPosX(_config.isCashPosX)
    self.isCash:SetPosY(_config.isCashPosY)
    self.isCash:SetIgnore(true)
  end
  if true == self.param.createClassEquipBG and nil == self.classEquipBG then
    self.classEquipBG = UI.createControl(UCT.PA_UI_CONTROL_STATIC, self.icon, "Static_classEquipBG_" .. self.id)
    self.classEquipBG:SetSize(_config.disableClass, _config.disableClass)
    self.classEquipBG:SetPosX(_config.iconSize - _config.disableClass)
    self.classEquipBG:SetPosY(_config.iconSize - _config.disableClass)
    self.classEquipBG:SetIgnore(true)
  end
  if true == self.param.createEnduranceIcon and nil == self.enduranceIcon then
    self.enduranceIcon = UI.createControl(UCT.PA_UI_CONTROL_STATIC, self.icon, "Static_" .. self.id .. "_enduranceIcon")
    self.enduranceIcon:SetSize(_config.iconSize + 1, _config.iconSize + 1)
    self.enduranceIcon:SetPosX(0)
    self.enduranceIcon:SetPosY(0)
    self.enduranceIcon:SetIgnore(true)
  end
  if true == self.param.createCooltimeText and nil == self.cooltimeText then
    self.cooltimeText = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, self.icon, "StaticText_" .. self.id .. "_Cooltime")
    self.cooltimeText:SetSize(_config.iconSize, _config.iconSize)
    self.cooltimeText:SetIgnore(true)
    self.cooltimeText:SetShow(false)
    self.cooltimeText:SetPosX(0)
    self.cooltimeText:SetPosY(0)
    self.cooltimeText:SetTextHorizonCenter()
    self.cooltimeText:SetTextVerticalCenter()
  end
  if true == self.param.createCheckBox and nil == self.checkBox then
    self.checkBox = UI.createControl(UCT.PA_UI_CONTROL_CHECKBUTTON, self.icon, "CheckButton_" .. self.id)
    self.checkBox:SetSize(_config.checkBtnSize, _config.checkBtnSize)
    self.checkBox:SetPosX(23)
    self.checkBox:SetPosY(1)
    self.checkBox:SetIgnore(false)
    self.checkBox:SetShow(false)
  end
  if true == self.param.createItemLock and nil == self.itemLock then
    self.itemLock = UI.createControl(UCT.PA_UI_CONTROL_STATIC, self.icon, "Static_" .. self.id .. "_ItemLock")
    self.itemLock:SetSize(18, 19)
    self.itemLock:SetIgnore(true)
    self.itemLock:SetShow(false)
    self.itemLock:SetHorizonRight()
  end
  if true == self.param.createBagIcon and nil == self.bagIcon then
    self.bagIcon = UI.createControl(UCT.PA_UI_CONTROL_STATIC, self.icon, "Static_" .. self.id .. "_BagIcon")
    self.bagIcon:SetSize(25, 25)
    self.bagIcon:SetIgnore(true)
    self.bagIcon:SetShow(false)
    self.bagIcon:SetPosX(1)
    self.bagIcon:SetPosY(1)
  end
  if true == self.param.createQuickslotBagIcon and nil == self.quickslotBagIcon then
    self.quickslotBagIcon = UI.createControl(UCT.PA_UI_CONTROL_STATIC, self.icon, "Static_" .. self.id .. "_QuickSlotBagIcon")
    self.quickslotBagIcon:SetSize(25, 25)
    self.quickslotBagIcon:SetIgnore(true)
    self.quickslotBagIcon:SetShow(false)
    self.quickslotBagIcon:SetPosX(1)
    self.quickslotBagIcon:SetPosY(1)
  end
  if true == self.param.createSoulComplete and nil == self.soulComplete then
    self.soulComplete = UI.createControl(UCT.PA_UI_CONTROL_STATIC, self.icon, "Static_" .. self.id .. "_soulComplete")
    self.soulComplete:SetSize(15, 15)
    self.soulComplete:SetIgnore(true)
    self.soulComplete:SetShow(false)
    self.soulComplete:SetPosX(27)
    self.soulComplete:SetPosY(1)
  end
end
function SlotItem.reInclude(itemSlot, id, slotNo, parent, param)
  if nil == itemSlot then
    itemSlot = {}
  end
  setmetatable(itemSlot, SlotItem)
  itemSlot.slotNo = slotNo
  itemSlot.param = param
  itemSlot.id = id
  local _config = UI.itemSlotConfig
  if nil == itemSlot.icon then
    itemSlot.icon = UI.getChildControl(parent, "Static_" .. id)
  end
  if true == itemSlot.param.createBorder and nil == itemSlot.border then
    itemSlot.border = UI.getChildControl(itemSlot.icon, "Static_" .. itemSlot.id .. "_Border")
  end
  if true == itemSlot.param.createExpiration2h and nil == itemSlot.Expiration2h then
    local expire2h = UI.getChildControl(PaGlobal_GetPanelWindowInventory(), "Static_Expire_2h")
    itemSlot.expiration2h = UI.getChildControl(itemSlot.icon, "Static_" .. itemSlot.id .. "Expiration2h")
  end
  if true == itemSlot.param.createExpirationBG and nil == itemSlot.ExpirationBG then
    itemSlot.expirationBG = UI.getChildControl(itemSlot.icon, "Static_" .. itemSlot.id .. "ExpirationBG")
  end
  if true == itemSlot.param.createCount and nil == itemSlot.count then
    itemSlot.count = UI.getChildControl(itemSlot.icon, "StaticText_" .. itemSlot.id .. "_Count")
  end
  if true == itemSlot.param.createMailCount and nil == itemSlot.mailCount then
    itemSlot.mailCount = UI.getChildControl(itemSlot.icon, "StaticText_" .. itemSlot.id .. "_MailCount")
  end
  if true == itemSlot.param.createEnchant and nil == itemSlot.enchantText then
    itemSlot.enchantText = UI.getChildControl(itemSlot.icon, "StaticText_" .. itemSlot.id .. "_Enchant")
  end
  if true == itemSlot.param.createRemoteEnchant and nil == itemSlot.remoteEnchantText then
    itemSlot.remoteEnchantText = UI.getChildControl(itemSlot.icon, "StaticText_" .. itemSlot.id .. "_RemoteEnchant")
  end
  if true == itemSlot.param.createCooltime and nil == itemSlot.cooltime then
    itemSlot.cooltime = UI.getChildControl("StaticCooltime", itemSlot.icon, "StaticCooltime_" .. itemSlot.id)
  end
  if true == itemSlot.param.createExpiration and nil == itemSlot.expiration then
    itemSlot.expiration = UI.getChildControl(itemSlot.icon, "Static_" .. itemSlot.id .. "_expiration")
  end
  if true == itemSlot.param.createCash and nil == itemSlot.isCash then
    itemSlot.isCash = UI.getChildControl(itemSlot.icon, "Static_" .. itemSlot.id .. "_isCash")
  end
  if true == itemSlot.param.createClassEquipBG and nil == itemSlot.classEquipBG then
    itemSlot.classEquipBG = UI.getChildControl(itemSlot.icon, "Static_classEquipBG_" .. itemSlot.id)
  end
  if true == itemSlot.param.createEnduranceIcon and nil == itemSlot.enduranceIcon then
    itemSlot.enduranceIcon = UI.getChildControl(itemSlot.icon, "Static_" .. itemSlot.id .. "_enduranceIcon")
  end
  if true == itemSlot.param.createCooltimeText and nil == itemSlot.cooltimeText then
    itemSlot.cooltimeText = UI.getChildControl(itemSlot.icon, "StaticText_" .. itemSlot.id .. "_Cooltime")
  end
  if true == itemSlot.param.createCheckBox and nil == itemSlot.checkBox then
    itemSlot.checkBox = UI.getChildControl(itemSlot.icon, "CheckButton_" .. itemSlot.id)
  end
  if true == itemSlot.param.createItemLock and nil == itemSlot.itemLock then
    itemSlot.itemLock = UI.getChildControl(itemSlot.icon, "Static_" .. itemSlot.id .. "_ItemLock")
  end
  if true == itemSlot.param.createSoulComplete and nil == itemSlot.soulComplete then
    itemSlot.soulComplete = UI.getChildControl(itemSlot.icon, "Static_" .. itemSlot.id .. "_soulComplete")
  end
  return itemSlot
end
function SlotItem:destroyChild()
  self.icon:ReleaseTexture()
  if nil ~= self.border then
    UI.deleteControl(self.border)
    self.border = nil
  end
  if nil ~= self.count then
    UI.deleteControl(self.count)
    self.count = nil
  end
  if nil ~= self.mailCount then
    UI.deleteControl(self.mailCount)
    self.mailCount = nil
  end
  if nil ~= self.enchantText then
    UI.deleteControl(self.enchantText)
    self.enchantText = nil
  end
  if nil ~= self.remoteEnchantText then
    UI.deleteControl(self.remoteEnchantText)
    self.remoteEnchantText = nil
  end
  if nil ~= self.cooltime then
    UI.deleteControl(self.cooltime)
    self.cooltime = nil
  end
  if nil ~= self.expiration then
    UI.deleteControl(self.expiration)
    self.expiration = nil
  end
  if nil ~= self.isCash then
    UI.deleteControl(self.isCash)
    self.isCash = nil
  end
  if nil ~= self.expiration2h then
    UI.deleteControl(self.expiration2h)
    self.expiration2h = nil
  end
  if nil ~= self.expirationBG then
    UI.deleteControl(self.expirationBG)
    self.expirationBG = nil
  end
  if nil ~= self.classEquipBG then
    UI.deleteControl(self.classEquipBG)
    self.classEquipBG = nil
  end
  if nil ~= self.enduranceIcon then
    UI.deleteControl(self.enduranceIcon)
    self.enduranceIcon = nil
  end
  if nil ~= self.cooltimeText then
    UI.deleteControl(self.cooltimeText)
    self.cooltimeText = nil
  end
  if nil ~= self.checkBox then
    UI.deleteControl(self.checkBox)
    self.checkBox = nil
  end
  if nil ~= self.itemLock then
    UI.deleteControl(self.itemLock)
    self.itemLock = nil
  end
  if nil ~= self.bagIcon then
    UI.deleteControl(self.bagIcon)
    self.bagIcon = nil
  end
  if nil ~= self.quickslotBagIcon then
    UI.deleteControl(self.quickslotBagIcon)
    self.quickslotBagIcon = nil
  end
  if nil ~= self.soulComplete then
    UI.deleteControl(self.soulComplete)
    self.soulComplete = nil
  end
end
function SlotItem:setItem(itemWrapper, slotNo, equipment, warehouse)
  local itemExpiration = itemWrapper:getExpirationDate()
  local expirationIndex = -1
  if nil ~= itemExpiration and false == itemExpiration:isIndefinite() then
    local s64_Time = itemExpiration:get_s64()
    local s64_remainTime = getLeftSecond_s64(itemExpiration)
    local remainTimePercent = Int64toInt32(s64_remainTime) / (itemWrapper:getStaticStatus():get()._expirationPeriod * 60) * 100
    if Defines.s64_const.s64_0 == s64_remainTime then
      expirationIndex = 2
    elseif remainTimePercent <= 30 then
      expirationIndex = 1
    else
      expirationIndex = 0
    end
  end
  local currentEndurance = itemWrapper:get():getEndurance()
  local isBroken = false
  if 0 == currentEndurance then
    isBroken = true
  end
  local isCash = itemWrapper:isCash()
  local isSoulCollecTor = itemWrapper:isSoulCollector()
  local soulCount, soulMax
  if true == isSoulCollecTor and self.soulComplete ~= nil then
    soulCount = itemWrapper:getSoulCollectorCount()
    soulMax = itemWrapper:getSoulCollectorMaxCount()
    if soulCount >= soulMax then
      self.soulComplete:ChangeTextureInfoNameAsync("new_ui_common_forlua/Widget/Dialogue/Dialogue_Etc_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(self.soulComplete, 330, 61, 346, 76)
      self.soulComplete:getBaseTexture():setUV(x1, y1, x2, y2)
      self.soulComplete:setRenderTexture(self.soulComplete:getBaseTexture())
      self.soulComplete:SetShow(true)
    end
  end
  self:setItemByStaticStatus(itemWrapper:getStaticStatus(), itemWrapper:get():getCount_s64(), expirationIndex, isBroken, isCash, isSoulCollecTor, soulCount, soulMax, isWidget)
  local isAble = requestIsRegisterItemForItemMarket(itemWrapper:get():getKey())
  if nil ~= self.isCash and isCash and itemWrapper:isSealed() and not itemWrapper:get():isVested() and isAble and not itemWrapper:getStaticStatus():isStackable() then
    self.isCash:ChangeTextureInfoNameAsync("new_ui_common_forlua/window/ingamecashshop/tax.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self.isCash, 1, 1, 28, 28)
    self.isCash:getBaseTexture():setUV(x1, y1, x2, y2)
    self.isCash:setRenderTexture(self.isCash:getBaseTexture())
  end
  local whereType = Inventory_GetCurrentInventoryType()
  if nil ~= slotNo and nil ~= self.itemLock then
    if true ~= equipment then
      if ToClient_Inventory_CheckItemLock(slotNo, whereType) then
        self.itemLock:ChangeTextureInfoNameAsync("Renewal/PcRemaster/Remaster_Icon_00.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(self.itemLock, 116, 1, 134, 20)
        self.itemLock:getBaseTexture():setUV(x1, y1, x2, y2)
        self.itemLock:setRenderTexture(self.itemLock:getBaseTexture())
        self.itemLock:SetShow(true)
      else
        self.itemLock:SetShow(false)
      end
    elseif ToClient_EquipSlot_CheckItemLock(slotNo, 1) then
      self.itemLock:ChangeTextureInfoNameAsync("Renewal/PcRemaster/Remaster_Icon_00.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(self.itemLock, 116, 1, 134, 20)
      self.itemLock:getBaseTexture():setUV(x1, y1, x2, y2)
      self.itemLock:setRenderTexture(self.itemLock:getBaseTexture())
      self.itemLock:SetShow(true)
    else
      self.itemLock:SetShow(false)
    end
  end
  if nil ~= self.bagIcon then
    self.bagIcon:SetShow(false)
    local itemSSW = itemWrapper:getStaticStatus()
    if CppEnums.ContentsEventType.ContentsType_InventoryBag == itemSSW:get():getContentsEventType() then
      local bagSize = itemSSW:getContentsEventParam2()
      for index = 0, bagSize - 1 do
        local bagItemWrapper
        if warehouse then
          bagItemWrapper = warehouse:getItemInBag(slotNo, index)
        else
          local whereType = CppEnums.ItemWhereType.eInventory
          if itemSSW:get():isCash() then
            whereType = CppEnums.ItemWhereType.eCashInventory
          end
          bagItemWrapper = getInventoryBagItemByType(whereType, slotNo, index)
        end
        if nil ~= bagItemWrapper then
          local iconPath = bagItemWrapper:getStaticStatus():getIconPath()
          self.bagIcon:ChangeTextureInfoNameDefault("icon/" .. iconPath)
          self.bagIcon:SetShow(true)
          break
        end
      end
    end
  end
  if nil ~= self.quickslotBagIcon then
    self.quickslotBagIcon:SetShow(false)
    local itemSSW = itemWrapper:getStaticStatus()
    if CppEnums.ContentsEventType.ContentsType_InventoryBag == itemSSW:get():getContentsEventType() then
      local bagSize = itemSSW:getContentsEventParam2()
      local whereType = CppEnums.ItemWhereType.eInventory
      if itemSSW:get():isCash() then
        whereType = CppEnums.ItemWhereType.eCashInventory
      end
      for index = 0, bagSize - 1 do
        local bagItemWrapper = getInventoryBagItemByType(whereType, slotNo, index)
        if nil ~= bagItemWrapper then
          local iconPath = bagItemWrapper:getStaticStatus():getIconPath()
          self.quickslotBagIcon:ChangeTextureInfoNameDefault("icon/" .. iconPath)
          self.quickslotBagIcon:SetShow(true)
          break
        end
      end
    end
  end
end
function SlotItem:setItemByStaticStatus(itemStaticWrapper, s64_stackCount, expirationIndex, isBroken, isCash, isSoulCollecTor, soulCount, soulMax, isWidget, isWorldMarket, isSealed)
  s64_stackCount = s64_stackCount or toInt64(0, 0)
  if nil ~= self.icon then
    self.icon:ChangeTextureInfoNameDefault("Icon/" .. itemStaticWrapper:getIconPath())
    self.icon:SetAlpha(1)
  end
  if nil ~= self.border then
    local gradeType = itemStaticWrapper:getGradeType()
    local borderTextureData = UI.itemSlotConfig.borderTexture
    if true == _ContentsGroup_RenewUI then
      borderTextureData = UI.itemSlotConfig.borderTextureForRenewUI
      local borderSample = PaGlobalFunc_InventoryInfo_GetSlotBorder()
      if nil ~= borderSample then
        CopyBasePropertyBaseOnly(self.border, borderSample)
        borderSample:SetShow(false)
      end
    end
    if true == _ContentsGroup_NewUI_XXX then
      borderTextureData = UI.itemSlotConfig.borderTextureForAllUI
    end
    if gradeType > 0 and gradeType <= #borderTextureData then
      self.border:ChangeTextureInfoNameAsync(borderTextureData[gradeType].texture)
      local x1, y1, x2, y2 = setTextureUV_Func(self.border, borderTextureData[gradeType].x1, borderTextureData[gradeType].y1, borderTextureData[gradeType].x2, borderTextureData[gradeType].y2)
      self.border:getBaseTexture():setUV(x1, y1, x2, y2)
      self.border:setRenderTexture(self.border:getBaseTexture())
      self.border:SetShow(true)
    else
      self.border:ReleaseTexture()
      self.border:ChangeTextureInfoNameAsync("")
    end
  end
  if nil ~= self.count then
    local itemStatic = itemStaticWrapper:get()
    if itemStatic then
      if itemStatic._isStack or true == isWorldMarket then
        if true == ToClient_isConsole() then
          self.count:SetText(self:getCountStringByCount64(s64_stackCount))
        else
          self.count:SetText(tostring(s64_stackCount))
        end
        self.count:SetShow(true)
      elseif true == isSoulCollecTor and nil ~= isWidget then
        if soulCount == soulMax then
          self.count:SetText("<PAColor0xFFF26A6A>" .. PAGetString(Defines.StringSheet_GAME, "PANEL_QUESTLIST_COMPLETE") .. "<PAOldColor>")
        else
          self.count:SetText(tostring(soulCount) .. "/" .. tostring(soulMax))
        end
        self.count:SetShow(true)
      else
        self.count:SetText("")
      end
    else
      self.count:SetText("")
    end
  end
  if nil ~= self.mailCount then
    local itemStatic = itemStaticWrapper:get()
    if itemStatic and itemStatic._isStack then
      self.mailCount:SetText(makeDotMoney(s64_stackCount))
      self.mailCount:SetShow(true)
    else
      self.mailCount:SetText("")
    end
  end
  if nil ~= self.enchantText then
    local itemStatic = itemStaticWrapper:get()
    if itemStatic:isEquipable() and 0 < itemStatic._key:getEnchantLevel() and itemStatic._key:getEnchantLevel() < 16 then
      self.enchantText:SetText("+" .. tostring(itemStatic._key:getEnchantLevel()))
      self.enchantText:SetShow(true)
    elseif itemStatic:isEquipable() and 16 == itemStatic._key:getEnchantLevel() then
      self.enchantText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_1"))
      self.enchantText:SetShow(true)
    elseif itemStatic:isEquipable() and 17 == itemStatic._key:getEnchantLevel() then
      self.enchantText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_2"))
      self.enchantText:SetShow(true)
    elseif itemStatic:isEquipable() and 18 == itemStatic._key:getEnchantLevel() then
      self.enchantText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_3"))
      self.enchantText:SetShow(true)
    elseif itemStatic:isEquipable() and 19 == itemStatic._key:getEnchantLevel() then
      self.enchantText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_4"))
      self.enchantText:SetShow(true)
    elseif itemStatic:isEquipable() and 20 == itemStatic._key:getEnchantLevel() then
      self.enchantText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_5"))
      self.enchantText:SetShow(true)
    else
      self.enchantText:SetText("")
    end
    if CppEnums.ItemClassifyType.eItemClassify_Accessory == itemStaticWrapper:getItemClassify() then
      if 1 == itemStatic._key:getEnchantLevel() then
        self.enchantText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_1"))
        self.enchantText:SetShow(true)
      elseif 2 == itemStatic._key:getEnchantLevel() then
        self.enchantText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_2"))
        self.enchantText:SetShow(true)
      elseif 3 == itemStatic._key:getEnchantLevel() then
        self.enchantText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_3"))
        self.enchantText:SetShow(true)
      elseif 4 == itemStatic._key:getEnchantLevel() then
        self.enchantText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_4"))
        self.enchantText:SetShow(true)
      elseif 5 == itemStatic._key:getEnchantLevel() then
        self.enchantText:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_5"))
        self.enchantText:SetShow(true)
      end
    end
    if itemStatic:isCash() then
      self.enchantText:SetShow(false)
    end
    local isCash = itemStatic:isCash()
    local balksCount = itemStaticWrapper:getExtractionCount_s64()
    local cronsCount = itemStaticWrapper:getCronCount_s64()
    if false == isCash and nil ~= balksCount and toInt64(0, 0) ~= balksCount and nil ~= cronsCount and toInt64(0, 0) ~= cronsCount then
      self.enchantText:SetShow(false)
    end
  end
  if nil ~= self.remoteEnchantText then
    local itemStatic = itemStaticWrapper:get()
    if itemStatic:isEquipable() and 0 < itemStatic._key:getEnchantLevel() and itemStatic._key:getEnchantLevel() < 16 then
      self.remoteEnchantText:SetText("+" .. tostring(itemStatic._key:getEnchantLevel()))
      self.remoteEnchantText:SetShow(true)
    elseif itemStatic:isEquipable() and 16 == itemStatic._key:getEnchantLevel() then
      self.remoteEnchantText:SetText("I")
      self.remoteEnchantText:SetShow(true)
    elseif itemStatic:isEquipable() and 17 == itemStatic._key:getEnchantLevel() then
      self.remoteEnchantText:SetText("II")
      self.remoteEnchantText:SetShow(true)
    elseif itemStatic:isEquipable() and 18 == itemStatic._key:getEnchantLevel() then
      self.remoteEnchantText:SetText("III")
      self.remoteEnchantText:SetShow(true)
    elseif itemStatic:isEquipable() and 19 == itemStatic._key:getEnchantLevel() then
      self.remoteEnchantText:SetText("IV")
      self.remoteEnchantText:SetShow(true)
    elseif itemStatic:isEquipable() and 20 == itemStatic._key:getEnchantLevel() then
      self.remoteEnchantText:SetText("V")
      self.remoteEnchantText:SetShow(true)
    else
      self.remoteEnchantText:SetText("")
    end
    if CppEnums.ItemClassifyType.eItemClassify_Accessory == itemStaticWrapper:getItemClassify() then
      if 1 == itemStatic._key:getEnchantLevel() then
        self.remoteEnchantText:SetText("I")
        self.remoteEnchantText:SetShow(true)
      elseif 2 == itemStatic._key:getEnchantLevel() then
        self.remoteEnchantText:SetText("II")
        self.remoteEnchantText:SetShow(true)
      elseif 3 == itemStatic._key:getEnchantLevel() then
        self.remoteEnchantText:SetText("III")
        self.remoteEnchantText:SetShow(true)
      elseif 4 == itemStatic._key:getEnchantLevel() then
        self.remoteEnchantText:SetText("IV")
        self.remoteEnchantText:SetShow(true)
      elseif 5 == itemStatic._key:getEnchantLevel() then
        self.remoteEnchantText:SetText("V")
        self.remoteEnchantText:SetShow(true)
      end
    end
    if itemStatic:isCash() then
      self.remoteEnchantText:SetShow(false)
    end
  end
  if nil ~= self.expiration then
    if -1 ~= expirationIndex then
      self.expiration:ChangeTextureInfoNameAsync(UI.itemSlotConfig.expirationTexture[expirationIndex].texture)
      local x1, y1, x2, y2 = setTextureUV_Func(self.expiration, UI.itemSlotConfig.expirationTexture[expirationIndex].x1, UI.itemSlotConfig.expirationTexture[expirationIndex].y1, UI.itemSlotConfig.expirationTexture[expirationIndex].x2, UI.itemSlotConfig.expirationTexture[expirationIndex].y2)
      self.expiration:getBaseTexture():setUV(x1, y1, x2, y2)
      self.expiration:setRenderTexture(self.expiration:getBaseTexture())
      self.expiration:SetShow(true)
    else
      self.expiration:SetShow(false)
    end
  end
  if nil ~= self.expiration2h then
    if 1 == expirationIndex then
      local x1, y1, x2, y2 = setTextureUV_Func(self.expiration2h, 1, 91, 44, 134)
      self.expiration2h:getBaseTexture():setUV(x1, y1, x2, y2)
      self.expiration2h:setRenderTexture(self.expiration2h:getBaseTexture())
      self.expiration2h:SetShow(true)
    else
      self.expiration2h:SetShow(false)
    end
  end
  if nil ~= self.isCash then
    if itemStaticWrapper:get():isCash() then
      self.isCash:ChangeTextureInfoNameAsync("new_ui_common_forlua/window/inventory/CashIcon.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(self.isCash, 1, 1, 28, 28)
      self.isCash:getBaseTexture():setUV(x1, y1, x2, y2)
      self.isCash:setRenderTexture(self.isCash:getBaseTexture())
      self.isCash:SetShow(true)
    else
      self.isCash:SetShow(false)
    end
  end
  if true == isSealed and not itemStaticWrapper:isStackable() then
    self.isCash:ChangeTextureInfoNameAsync("new_ui_common_forlua/window/ingamecashshop/tax.dds")
    local x1, y1, x2, y2 = setTextureUV_Func(self.isCash, 1, 1, 28, 28)
    self.isCash:getBaseTexture():setUV(x1, y1, x2, y2)
    self.isCash:setRenderTexture(self.isCash:getBaseTexture())
  end
  if nil ~= self.expirationBG then
    if 2 == expirationIndex then
      self.expirationBG:ChangeTextureInfoNameAsync("new_ui_common_forlua/window/inventory/inventory_01.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(self.expirationBG, 1, 1, 44, 44)
      self.expirationBG:getBaseTexture():setUV(x1, y1, x2, y2)
      self.expirationBG:setRenderTexture(self.expirationBG:getBaseTexture())
      self.expirationBG:SetShow(true)
    else
      self.expirationBG:SetShow(false)
    end
  end
  if nil ~= self.classEquipBG then
    self.classEquipBG:SetShow(false)
    local isUsableClass
    local itemSSW = itemStaticWrapper
    local classType = getSelfPlayer():getClassType()
    if nil ~= itemSSW then
      if itemSSW:get():isWeapon() or itemSSW:get():isSubWeapon() or itemSSW:get():isAwakenWeapon() then
        isUsableClass = itemSSW:get()._usableClassType:isOn(classType)
      else
        isUsableClass = true
      end
    else
      isUsableClass = false
    end
    if true == itemSSW:get():isEquipable() and false == isUsableClass and false == isWorldMarket then
      self.classEquipBG:ChangeTextureInfoNameAsync("new_ui_common_forlua/window/inventory/Disable_Class.dds")
      local x1, y1, x2, y2 = setTextureUV_Func(self.classEquipBG, 1, 1, 12, 12)
      self.classEquipBG:getBaseTexture():setUV(x1, y1, x2, y2)
      self.classEquipBG:setRenderTexture(self.classEquipBG:getBaseTexture())
      self.classEquipBG:SetShow(true)
    end
  end
  local equipSlotNo = itemStaticWrapper:getEquipSlotNo()
  if nil ~= self.enduranceIcon then
    self.enduranceIcon:SetShow(false)
    if true == isBroken then
      if 2 == equipSlotNo then
        self.enduranceIcon:ChangeTextureInfoNameAsync("new_ui_common_forlua/window/inventory/Disable_Repair.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(self.enduranceIcon, 1, 1, 41, 41)
        self.enduranceIcon:getBaseTexture():setUV(x1, y1, x2, y2)
        self.enduranceIcon:setRenderTexture(self.enduranceIcon:getBaseTexture())
        self.enduranceIcon:SetShow(true)
      else
        self.enduranceIcon:ChangeTextureInfoNameAsync("new_ui_common_forlua/window/inventory/Need_Repair.dds")
        local x1, y1, x2, y2 = setTextureUV_Func(self.enduranceIcon, 1, 1, 41, 41)
        self.enduranceIcon:getBaseTexture():setUV(x1, y1, x2, y2)
        self.enduranceIcon:setRenderTexture(self.enduranceIcon:getBaseTexture())
        self.enduranceIcon:SetShow(true)
      end
    end
  end
  if nil ~= self.checkBox then
    self.checkBox:ChangeTextureInfoNameAsync(UI.itemSlotConfig.checkBtnTexture[0].texture)
    local x1, y1, x2, y2 = setTextureUV_Func(self.checkBox, UI.itemSlotConfig.checkBtnTexture[0].x1, UI.itemSlotConfig.checkBtnTexture[0].y1, UI.itemSlotConfig.checkBtnTexture[0].x2, UI.itemSlotConfig.checkBtnTexture[0].y2)
    self.checkBox:getBaseTexture():setUV(x1, y1, x2, y2)
    self.checkBox:setRenderTexture(self.checkBox:getBaseTexture())
    self.checkBox:ChangeOnTextureInfoName(UI.itemSlotConfig.checkBtnTexture[1].texture)
    local x1, y1, x2, y2 = setTextureUV_Func(self.checkBox, UI.itemSlotConfig.checkBtnTexture[1].x1, UI.itemSlotConfig.checkBtnTexture[1].y1, UI.itemSlotConfig.checkBtnTexture[1].x2, UI.itemSlotConfig.checkBtnTexture[1].y2)
    self.checkBox:getOnTexture():setUV(x1, y1, x2, y2)
    self.checkBox:ChangeClickTextureInfoName(UI.itemSlotConfig.checkBtnTexture[2].texture)
    local x1, y1, x2, y2 = setTextureUV_Func(self.checkBox, UI.itemSlotConfig.checkBtnTexture[2].x1, UI.itemSlotConfig.checkBtnTexture[2].y1, UI.itemSlotConfig.checkBtnTexture[2].x2, UI.itemSlotConfig.checkBtnTexture[2].y2)
    self.checkBox:getClickTexture():setUV(x1, y1, x2, y2)
    self.checkBox:SetShow(false)
    self.checkBox:SetCheck(true)
  end
  if nil ~= self.quickslotBagIcon then
    self.quickslotBagIcon:SetShow(false)
    local itemSSW = itemStaticWrapper
    if CppEnums.ContentsEventType.ContentsType_InventoryBag == itemSSW:get():getContentsEventType() then
      local bagSize = itemSSW:getContentsEventParam2()
      local whereType = CppEnums.ItemWhereType.eInventory
      if itemSSW:get():isCash() then
        whereType = CppEnums.ItemWhereType.eCashInventory
      end
      local inventory = getSelfPlayer():get():getInventoryByType(whereType)
      local invenSlotNo = inventory:getSlot(itemSSW:get()._key)
      for index = 0, bagSize - 1 do
        local quickSlotBagItemWrapper = getInventoryBagItemByType(whereType, invenSlotNo, index)
        if nil ~= quickSlotBagItemWrapper then
          local iconPath = quickSlotBagItemWrapper:getStaticStatus():getIconPath()
          self.quickslotBagIcon:ChangeTextureInfoNameDefault("icon/" .. iconPath)
          self.quickslotBagIcon:SetShow(true)
          break
        end
      end
    end
  end
end
function SlotItem:setItemByCashProductStaticStatus(cashProductStaticWrapper, s64_stackCount)
  s64_stackCount = s64_stackCount or toInt64(0, 0)
  if nil ~= self.icon then
    self.icon:ChangeTextureInfoNameDefault("Icon/" .. cashProductStaticWrapper:getIconPath())
    self.icon:SetAlpha(1)
  end
  if nil ~= self.count then
    if s64_stackCount > toInt64(0, 0) then
      self.count:SetText(tostring(s64_stackCount))
      self.count:SetShow(true)
    else
      self.count:SetText("")
    end
  end
  if nil ~= self.mailCount then
    if s64_stackCount > toInt64(0, 0) then
      self.mailCount:SetText(makeDotMoney(s64_stackCount))
      self.mailCount:SetShow(true)
    else
      self.mailCount:SetText("")
    end
  end
end
function SlotItem:getCountStringByCount64(count64)
  local strCount = ""
  if "userdata" == type(count64) then
    if count64 > toInt64(0, 1000000) then
      strCount = tostring(count64 / toInt64(0, 1000000)) .. "." .. tostring(count64 / toInt64(0, 100000) - count64 / toInt64(0, 1000000) * toInt64(0, 10)) .. "M"
    elseif count64 > toInt64(0, 1000) then
      strCount = tostring(count64 / toInt64(0, 1000)) .. "." .. tostring(count64 / toInt64(0, 100) - count64 / toInt64(0, 1000) * toInt64(0, 10)) .. "K"
    else
      strCount = tostring(count64)
    end
  elseif "number" == type(count64) then
    if count64 > 1000000 then
      strCount = tostring(count64 / 1000000) .. "." .. tostring(count64 / 100000 - count64 / 1000000 * 10) .. "M"
    elseif count64 > 1000 then
      strCount = tostring(count64 / 1000) .. "." .. tostring(count64 / 100 - count64 / 1000 * 10) .. "K"
    else
      strCount = tostring(count64)
    end
  end
  return strCount
end
function SlotItem:clearItem()
  if nil ~= self.icon then
    self.icon:ReleaseTexture()
    self.icon:ChangeTextureInfoNameAsync("")
    self.icon:SetAlpha(0)
  end
  if nil ~= self.border then
    self.border:ReleaseTexture()
    self.border:SetShow(false)
  end
  if nil ~= self.count then
    self.count:SetShow(false)
  end
  if nil ~= self.mailCount then
    self.mailCount:SetShow(false)
  end
  if nil ~= self.enchantText then
    self.enchantText:SetShow(false)
  end
  if nil ~= self.remoteEnchantText then
    self.remoteEnchantText:SetShow(false)
  end
  if nil ~= self.cooltime then
    self.cooltime:SetShow(false)
  end
  if nil ~= self.expiration then
    self.expiration:SetShow(false)
  end
  if nil ~= self.isCash then
    self.isCash:SetShow(false)
  end
  if nil ~= self.expiration2h then
    self.expiration2h:SetShow(false)
  end
  if nil ~= self.expirationBG then
    self.expirationBG:SetShow(false)
  end
  if nil ~= self.classEquipBG then
    self.classEquipBG:SetShow(false)
  end
  if nil ~= self.enduranceIcon then
    self.enduranceIcon:SetShow(false)
  end
  if nil ~= self.cooltimeText then
    self.cooltimeText:SetShow(false)
  end
  if nil ~= self.checkBox then
    self.checkBox:SetShow(false)
  end
  if nil ~= self.itemLock then
    self.itemLock:SetShow(false)
  end
  if nil ~= self.soulComplete then
    self.soulComplete:SetShow(false)
  end
  if nil ~= self.bagIcon then
    self.bagIcon:SetShow(false)
  end
  if nil ~= self.quickslotBagIcon then
    self.quickslotBagIcon:SetShow(false)
  end
  if nil ~= self.soulComplete then
    self.soulComplete:SetShow(false)
  end
end
UI.skillSlotConfig = {
  iconSize = 42,
  levelPosX = -15,
  levelPosY = -11,
  learnBtnSpanSize = -2
}
SlotSkill = {}
SlotSkill.__index = SlotSkill
function SlotSkill.new(skillSlot, skillNo, parent, param)
  if nil == skillSlot then
    skillSlot = {}
  end
  setmetatable(skillSlot, SlotSkill)
  if "number" == type(skillNo) then
    skillSlot.skillNo = skillNo
  end
  skillSlot.param = param
  local _config = UI.skillSlotConfig
  if true == param.createIcon and nil == skillSlot.icon then
    skillSlot.icon = UI.createControl(UCT.PA_UI_CONTROL_STATIC, parent, "StaticSkill_" .. skillNo)
    skillSlot.icon:SetSize(_config.iconSize, _config.iconSize)
    skillSlot.icon:ActiveMouseEventEffect(true)
    skillSlot.icon:SetIgnore(false)
  end
  if true == param.createEffect and nil == skillSlot.effect then
    skillSlot.effect = UI.createControl(UCT.PA_UI_CONTROL_STATIC, parent, "StaticSkill_Effect_" .. skillNo)
    CopyBaseProperty(param.template.effect, skillSlot.effect)
    skillSlot.effect:SetIgnore(true)
  end
  if true == param.createFG and nil == skillSlot.iconFG then
    skillSlot.iconFG = UI.createControl(UCT.PA_UI_CONTROL_STATIC, parent, "StaticSkill_Foreground_" .. skillNo)
    CopyBaseProperty(param.template.iconFG, skillSlot.iconFG)
    skillSlot.iconFG:SetIgnore(true)
  end
  if true == param.createFGDisabled and nil == skillSlot.iconFGDisabled then
    skillSlot.iconFGDisabled = UI.createControl(UCT.PA_UI_CONTROL_STATIC, parent, "StaticSkill_Foreground_Disable" .. skillNo)
    CopyBaseProperty(param.template.iconFGDisabled, skillSlot.iconFGDisabled)
    skillSlot.iconFGDisabled:SetIgnore(true)
  end
  if true == param.createFG_Passive and nil == skillSlot.iconFG_Passive then
    skillSlot.iconFG_Passive = UI.createControl(UCT.PA_UI_CONTROL_STATIC, parent, "StaticSkill_Foreground_Passive" .. skillNo)
    CopyBaseProperty(param.template.iconFG_Passive, skillSlot.iconFG_Passive)
    skillSlot.iconFG_Passive:SetIgnore(true)
  end
  if true == param.createMinus and nil == skillSlot.iconMinus then
    skillSlot.iconMinus = UI.createControl(UCT.PA_UI_CONTROL_STATIC, parent, "StaticSkill_Minus" .. skillNo)
    CopyBaseProperty(param.template.iconMinus, skillSlot.iconMinus)
    skillSlot.iconMinus:SetIgnore(true)
    skillSlot.iconMinus:SetShow(false)
  end
  if true == param.createLearnButton and nil == skillSlot.learnButton then
    skillSlot.learnButton = UI.createControl(UCT.PA_UI_CONTROL_BUTTON, parent, "StaticSkill_Learn_" .. skillNo)
    CopyBaseProperty(param.template.learnButton, skillSlot.learnButton)
    skillSlot.learnButton:SetIgnore(false)
    skillSlot.learnButton:SetShow(false)
  end
  if true == param.createMouseOver and nil == skillSlot.mouseOverButton then
    skillSlot.mouseOverButton = UI.createControl(UCT.PA_UI_CONTROL_STATIC, parent, "StaticSkill_OverMouse_" .. skillNo)
    CopyBaseProperty(param.template.mouseOverButton, skillSlot.mouseOverButton)
    skillSlot.mouseOverButton:SetIgnore(false)
    skillSlot.mouseOverButton:SetShow(false)
  end
  if true == param.createReservationButton and nil == skillSlot.reservationButton then
    skillSlot.reservationButton = UI.createControl(UCT.PA_UI_CONTROL_BUTTON, parent, "StaticSkill_Reservation_" .. skillNo)
    CopyBaseProperty(param.template.reservationButton, skillSlot.reservationButton)
    skillSlot.reservationButton:SetIgnore(false)
    skillSlot.reservationButton:SetShow(false)
  end
  if true == param.createCooltime and nil == skillSlot.cooltime then
    skillSlot.cooltime = UI.createCustomControl("StaticCooltime", parent, "StaticCooltime_" .. skillNo)
    skillSlot.cooltime:SetMonoTone(true)
    skillSlot.cooltime:SetSize(_config.iconSize, _config.iconSize)
    skillSlot.cooltime:SetIgnore(true)
    skillSlot.cooltime:SetShow(false)
  end
  if true == param.createTestimonial and nil == skillSlot.testimonial then
    skillSlot.testimonial = UI.createControl(UCT.PA_UI_CONTROL_STATIC, parent, "StaticSkill_testimonial_" .. skillNo)
    CopyBaseProperty(param.template.testimonial, skillSlot.testimonial)
    skillSlot.testimonial:SetIgnore(true)
    skillSlot.testimonial:SetShow(false)
  end
  if true == param.createCooltimeText and nil == skillSlot.cooltimeText then
    skillSlot.cooltimeText = UI.createControl(UCT.PA_UI_CONTROL_STATICTEXT, parent, "StaticText_" .. skillNo .. "_Cooltime")
    skillSlot.cooltimeText:SetSize(_config.iconSize, _config.iconSize)
    skillSlot.cooltimeText:SetIgnore(true)
    skillSlot.cooltimeText:SetShow(false)
    skillSlot.cooltimeText:SetTextHorizonCenter()
    skillSlot.cooltimeText:SetTextVerticalCenter()
  end
  if true == param.createLockIcon and nil == skillSlot.lockIcon then
    skillSlot.lockIcon = UI.createControl(UCT.PA_UI_CONTROL_STATIC, parent, "StaticSkill_LockIcon_" .. skillNo)
    CopyBaseProperty(param.template.lockIcon, skillSlot.lockIcon)
    skillSlot.lockIcon:SetShow(false)
  end
  return skillSlot
end
function SlotSkill:setPos(posX, posY)
  local _config = UI.skillSlotConfig
  local iconSizeX, iconSizeY
  iconSizeX = _config.iconSize
  iconSizeY = _config.iconSize
  if nil ~= self.icon then
    self.icon:SetPosX(posX)
    self.icon:SetPosY(posY)
    iconSizeX = self.icon:GetSizeX()
    iconSizeY = self.icon:GetSizeY()
  end
  if nil ~= self.effect then
    self.effect:SetPosX(posX + (iconSizeX - self.effect:GetSizeX()) / 2)
    self.effect:SetPosY(posY + (iconSizeY - self.effect:GetSizeY()) / 2)
  end
  if nil ~= self.iconFG then
    self.iconFG:SetPosX(posX + (iconSizeX - self.iconFG:GetSizeX()) / 2)
    self.iconFG:SetPosY(posY + (iconSizeY - self.iconFG:GetSizeY()) / 2)
  end
  if nil ~= self.iconFGDisabled then
    self.iconFGDisabled:SetPosX(posX + (iconSizeX - self.iconFGDisabled:GetSizeX()) / 2)
    self.iconFGDisabled:SetPosY(posY + (iconSizeY - self.iconFGDisabled:GetSizeY()) / 2)
  end
  if nil ~= self.iconFG_Passive then
    self.iconFG_Passive:SetPosX(posX + (iconSizeX - self.iconFG_Passive:GetSizeX()) / 2)
    self.iconFG_Passive:SetPosY(posY + (iconSizeY - self.iconFG_Passive:GetSizeY()) / 2)
  end
  if nil ~= self.iconMinus then
    self.iconMinus:SetPosX(posX + (iconSizeX - self.iconMinus:GetSizeX()) / 2)
    self.iconMinus:SetPosY(posY + (iconSizeY - self.iconMinus:GetSizeY()) / 2)
  end
  if nil ~= self.learnButton then
    self.learnButton:SetPosX(posX + iconSizeX - (self.learnButton:GetSizeX() - 4))
    self.learnButton:SetPosY(posY + iconSizeY - (self.learnButton:GetSizeY() - 4))
  end
  if nil ~= self.mouseOverButton then
    self.mouseOverButton:SetPosX(posX + iconSizeX - (self.mouseOverButton:GetSizeX() - 10))
    self.mouseOverButton:SetPosY(posY + iconSizeY - (self.mouseOverButton:GetSizeY() - 10))
  end
  if nil ~= self.reservationButton then
    self.reservationButton:SetPosX(posX + iconSizeX - (self.reservationButton:GetSizeX() + _config.learnBtnSpanSize))
    self.reservationButton:SetPosY(posY + iconSizeY - (self.reservationButton:GetSizeY() + _config.learnBtnSpanSize))
  end
  if nil ~= self.cooltime then
    self.cooltime:SetPosX(posX)
    self.cooltime:SetPosY(posY)
  end
  if nil ~= self.testimonial then
    self.testimonial:SetPosX(posX + (iconSizeX - self.testimonial:GetSizeX()) / 2)
    self.testimonial:SetPosY(posY + (iconSizeY - self.testimonial:GetSizeY()) / 2)
  end
  if nil ~= self.cooltimeText then
    self.cooltimeText:SetPosX(posX)
    self.cooltimeText:SetPosY(posY)
  end
  if nil ~= self.lockIcon then
    self.lockIcon:SetPosX(posX + self.lockIcon:GetSizeX() - 4)
    self.lockIcon:SetPosY(posY - 4)
  end
end
function SlotSkill:destroyChild()
  if nil ~= self.icon then
    UI.deleteControl(self.icon)
    self.icon = nil
  end
  if nil ~= self.effect then
    UI.deleteControl(self.effect)
    self.effect = nil
  end
  if nil ~= self.iconFG then
    UI.deleteControl(self.iconFG)
    self.iconFG = nil
  end
  if nil ~= self.iconFGDisabled then
    UI.deleteControl(self.iconFGDisabled)
    self.iconFGDisabled = nil
  end
  if nil ~= self.iconFG_Passive then
    UI.deleteControl(self.iconFG_Passive)
    self.iconFG_Passive = nil
  end
  if nil ~= self.iconMinus then
    UI.deleteControl(self.iconMinus)
    self.iconMinus = nil
  end
  if nil ~= self.learnButton then
    UI.deleteControl(self.learnButton)
    self.learnButton = nil
  end
  if nil ~= self.mouseOverButton then
    UI.deleteControl(self.mouseOverButton)
    self.mouseOverButton = nil
  end
  if nil ~= self.reservationButton then
    UI.deleteControl(self.reservationButton)
    self.reservationButton = nil
  end
  if nil ~= self.cooltime then
    UI.deleteControl(self.cooltime)
    self.cooltime = nil
  end
  if nil ~= self.testimonial then
    UI.deleteControl(self.testimonial)
    self.testimonial = nil
  end
  if nil ~= self.cooltimeText then
    UI.deleteControl(self.cooltimeText)
    self.cooltimeText = nil
  end
  if nil ~= self.lockIcon then
    UI.deleteControl(self.lockIcon)
    self.lockIcon = nil
  end
end
function SlotSkill:setSkillTypeStatic(skillTypeStaticWrapper, skillNo)
  if nil ~= self.icon then
    self.icon:ChangeTextureInfoName("Icon/" .. skillTypeStaticWrapper:getIconPath())
    self.icon:SetAlpha(1)
  end
  if nil ~= skillNo then
    self.skillNo = skillNo
  end
end
function SlotSkill:setSkill(skillLevelInfo, isLearnMode)
  if self.skillNo ~= skillLevelInfo._skillKey:getSkillNo() then
    local skillTypeStaticWrapper = getSkillTypeStaticStatus(skillLevelInfo._skillKey:getSkillNo())
    self:setSkillTypeStatic(skillTypeStaticWrapper, skillLevelInfo._skillKey:getSkillNo())
  end
  if nil == self.icon or isLearnMode then
  else
  end
  if nil ~= self.iconFG then
    self.iconFG:SetShow(skillLevelInfo._usable)
  end
  if nil ~= self.iconFGDisabled then
    self.iconFGDisabled:SetShow(not skillLevelInfo._usable)
  end
  if nil ~= self.iconFG_Passive then
    self.iconFG_Passive:SetShow(not skillLevelInfo._usable)
  end
  if nil ~= self.reservationButton then
    self.reservationButton:SetShow(isLearnMode and skillLevelInfo._isReservedLearning)
  end
  if nil ~= self.testimonial then
    self.testimonial:SetShow(skillLevelInfo._isTestimonial)
  end
  local resultAble = false
  if nil ~= self.learnButton then
    local skillStatic = getSkillStaticStatus(skillLevelInfo._skillKey:getSkillNo(), 1)
    local enableLearn = true
    if nil ~= skillStatic then
      local needLvLearning = skillStatic:get()._needCharacterLevelForLearning
      if 0 == needLvLearning then
        enableLearn = false
      end
    end
    resultAble = isLearnMode and skillLevelInfo._learnable and enableLearn
    self.learnButton:SetShow(resultAble)
  end
  return resultAble
end
function SlotSkill:clearSkill()
  self.skillNo = nil
  if nil ~= self.icon then
    self.icon:ReleaseTexture()
    self.icon:SetAlpha(0)
  end
  if nil ~= self.effect then
    self.effect:SetShow(false)
  end
  if nil ~= self.iconFG then
    self.iconFG:SetShow(false)
  end
  if nil ~= self.iconFGDisabled then
    self.iconFGDisabled:SetShow(false)
  end
  if nil ~= self.iconFG_Passive then
    self.iconFG_Passive:SetShow(false)
  end
  if nil ~= self.iconMinus then
    self.iconMinus:SetShow(false)
  end
  if nil ~= self.learnButton then
    self.learnButton:SetShow(false)
  end
  if nil ~= self.mouseOverButton then
    self.learnButton:SetShow(false)
  end
  if nil ~= self.reservationButton then
    self.reservationButton:SetShow(false)
  end
  if nil ~= self.cooltime then
    self.cooltime:SetShow(false)
  end
  if nil ~= self.testimonial then
    self.testimonial:SetShow(false)
  end
  if nil ~= self.cooltimeText then
    self.cooltimeText:SetShow(false)
  end
  if nil ~= self.lockIcon then
    self.lockIcon:SetShow(false)
  end
end
function HighEnchantLevel_ReplaceString(enchantLevel)
  if 16 == enchantLevel then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_16")
  elseif 17 == enchantLevel then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_17")
  elseif 18 == enchantLevel then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_18")
  elseif 19 == enchantLevel then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_19")
  elseif 20 == enchantLevel then
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_20")
  else
    return PAGetString(Defines.StringSheet_GAME, "LUA_GLOBAL_UTIL_UI_SLOT_ENCHANTLEVEL_20")
  end
end
function HighRomaEnchantLevel_ReplaceString(enchantLevel)
  if 16 == enchantLevel then
    return PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_1")
  elseif 17 == enchantLevel then
    return PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_2")
  elseif 18 == enchantLevel then
    return PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_3")
  elseif 19 == enchantLevel then
    return PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_4")
  elseif 20 == enchantLevel then
    return PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_ENCHANTLEVEL_5")
  end
  return ""
end

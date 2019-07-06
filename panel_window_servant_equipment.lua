Panel_ServantEquipment:ActiveMouseEventEffect(true)
Panel_ServantEquipment:setGlassBackground(true)
Panel_ServantEquipment:RegisterShowEventFunc(true, "ServantEquipment_ShowAni()")
Panel_ServantEquipment:RegisterShowEventFunc(false, "ServantEquipment_HideAni()")
local UI_color = Defines.Color
local servantEquip = {
  slotConfig = {
    createIcon = false,
    createBorder = true,
    createCount = true,
    createCash = true
  },
  slotNoDef = {
    rightHand = 0,
    leftHand = 1,
    chest = 4,
    pants = 5,
    glove = 6,
    boots = 7,
    helm = 8,
    shoulder = 9,
    necklace = 10,
    ring1 = 11,
    ring2 = 12,
    earing1 = 13,
    earing2 = 14,
    belt = 15,
    lantern = 16,
    avatarChest = 17,
    avatarPants = 18,
    avatarGlove = 19,
    avatarBoots = 20,
    avatarShoulder = 21,
    avatarWeapon = 22,
    avatarSubWeapon = 23
  },
  slotNoId = {
    [0] = "Static_Slot_RightHand",
    [1] = "Static_Slot_LeftHand",
    [4] = "Static_Slot_Chest",
    [5] = "Static_Slot_Pants",
    [6] = "Static_Slot_Glove",
    [7] = "Static_Slot_Boots",
    [8] = "Static_Slot_Helm",
    [9] = "Static_Slot_Shoulder",
    [10] = "Static_Slot_Necklace",
    [11] = "Static_Slot_Ring1",
    [12] = "Static_Slot_Ring2",
    [13] = "Static_Slot_Earing1",
    [14] = "Static_Slot_Earing2",
    [15] = "Static_Slot_Belt",
    [16] = "Static_Slot_Lantern",
    [17] = "Static_Slot_Avatar_Cheat",
    [18] = "Static_Slot_Avatar_Pants",
    [19] = "Static_Slot_Avatar_Gloves",
    [20] = "Static_Slot_Avatar_Boots",
    [21] = "Static_Slot_Avatar_Shoulder",
    [22] = "Static_Slot_Avatar_RightHand",
    [23] = "Static_Slot_Avatar_LeftHand"
  },
  slots = Array.new(),
  staticTitle = UI.getChildControl(Panel_ServantEquipment, "Static_Text_Title"),
  buttonClose = UI.getChildControl(Panel_ServantEquipment, "Button_Close")
}
function servantEquip:initControl()
  UI.ASSERT(nil ~= self.staticTitle and "number" ~= type(self.staticTitle), "Static_Text_Title")
  UI.ASSERT(nil ~= self.buttonClose and "number" ~= type(self.staticCapacity), "Button_Close")
  for _, v in pairs(self.slotNoDef) do
    local slot = {}
    SlotItem.new(slot, "ServantEquipment_" .. v, v, Panel_ServantEquipment, self.slotConfig)
    slot.icon = UI.getChildControl(Panel_ServantEquipment, self.slotNoId[v])
    slot:createChild()
    slot.icon:addInputEvent("Mouse_RUp", "ServantEquipment_RClick(" .. v .. ")")
    slot.icon:addInputEvent("Mouse_LUp", "ServantEquipment_LClick(" .. v .. ")")
    slot.icon:addInputEvent("Mouse_On", "ServantEquipment_MouseOn(" .. v .. ",true)")
    slot.icon:addInputEvent("Mouse_Out", "ServantEquipment_MouseOn(" .. v .. ",false)")
    self.slots[v] = slot
    Panel_Tooltip_Item_SetPosition(v, slot, "ServantEquipment")
  end
end
function servantEquip:registEventHandler()
  self.buttonClose:addInputEvent("Mouse_LUp", "ServantEquipmentWindow_Close()")
end
function servantEquip:registMessageHandler()
  registerEvent("EventServantEquipmentUpdate", "ServantEquipment_updateSlotData")
end
function ServantEquipment_updateSlotData()
  local self = servantEquip
  local temporaryWrapper = getTemporaryInformationWrapper()
  if nil == temporaryWrapper or not temporaryWrapper:isSelfVehicle() then
    return
  end
  for _, v in pairs(self.slotNoDef) do
    local itemWrapper = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle):getEquipItem(v)
    local slot = self.slots[v]
    if nil ~= itemWrapper then
      slot:setItem(itemWrapper)
    else
      slot:clearItem()
    end
  end
end
function ServantEquipment_MouseOn(slotNo, isOn)
  Panel_Tooltip_Item_Show_GeneralNormal(slotNo, "servant_inventory", isOn, false)
end
function ServantEquipment_RClick(slotNo)
  local temporaryWrapper = getTemporaryInformationWrapper()
  if nil == temporaryWrapper or not temporaryWrapper:isSelfVehicle() then
    return
  end
  local servantInfo = temporaryWrapper:getUnsealVehicle(CppEnums.ServantType.Type_Vehicle):getEquipItem(slotNo)
  if nil == servantInfo then
    return
  end
  servant_doUnequip(servantInfo:getActorKeyRaw(), slotNo)
end
function ServantEquipment_LClick(slotNo)
  if DragManager.dragStartPanel == Panel_Window_Inventory then
    local dragSlotNo = DragManager.dragSlotInfo
    local itemWrapper = getInventoryItem(dragSlotNo)
    if nil ~= itemWrapper then
      local itemStatic = itemWrapper:getStaticStatus()
      if itemStatic:isEquipable() then
        Inventory_SlotRClick(DragManager.dragSlotInfo)
        DragManager.clearInfo()
      end
    end
  end
end
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
function ServantEquipment_ShowToggle()
  local isShow = Panel_ServantEquipment:GetShow()
  if isShow == true then
    Panel_ServantEquipment:SetShow(false, true)
  else
    Panel_ServantEquipment:SetShow(true, true)
  end
end
function ServantEquipmentWindow_Close()
end
function ServantEquipment_ShowAni()
  UIAni.fadeInSCR_Left(Panel_ServantEquipment)
end
function ServantEquipment_HideAni()
  Panel_ServantEquipment:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_ServantEquipment:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
  local aniInfo2 = Panel_ServantEquipment:addScaleAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo2:SetStartScale(1)
  aniInfo2:SetEndScale(0.97)
  aniInfo2.AxisX = 200
  aniInfo2.AxisY = 295
  aniInfo2.IsChangeChild = true
  aniInfo2:SetDisableWhileAni(true)
end
servantEquip:initControl()
servantEquip:registEventHandler()
servantEquip:registMessageHandler()

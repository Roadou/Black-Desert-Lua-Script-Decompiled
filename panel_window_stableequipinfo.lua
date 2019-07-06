Panel_Window_StableEquipInfo:SetShow(false, false)
Panel_Window_StableEquipInfo:setMaskingChild(true)
Panel_Window_StableEquipInfo:ActiveMouseEventEffect(true)
Panel_Window_StableEquipInfo:SetDragEnable(true)
UI.getChildControl(Panel_Window_StableEquipInfo, "Stable_Info_Equipment"):setGlassBackground(true)
local UI_ANI_ADV = CppEnums.PAUI_ANIM_ADVANCE_TYPE
local UI_color = Defines.Color
function StableEquipInfoWindow_Show()
  Panel_Window_StableEquipInfo:SetShow(true, false)
  UIAni.fadeInSCR_Right(Panel_Window_StableEquipInfo)
  local aniInfo3 = Panel_Window_StableEquipInfo:addColorAnimation(0, 0.2, UI_ANI_ADV.PAUI_ANIM_ADVANCE_COS_HALF_PI)
  aniInfo3:SetStartColor(UI_color.C_00FFFFFF)
  aniInfo3:SetEndColor(UI_color.C_FFFFFFFF)
  aniInfo3.IsChangeChild = false
end
function StableEquipInfoWindow_Hide()
  Panel_Window_StableEquipInfo:SetShowWithFade(CppEnums.PAUI_SHOW_FADE_TYPE.PAUI_ANI_TYPE_FADE_OUT)
  local aniInfo1 = Panel_Window_StableEquipInfo:addColorAnimation(0, 0.22, UI_ANI_ADV.PAUI_ANIM_ADVANCE_SIN_HALF_PI)
  aniInfo1:SetStartColor(UI_color.C_FFFFFFFF)
  aniInfo1:SetEndColor(UI_color.C_00FFFFFF)
  aniInfo1:SetStartIntensity(3)
  aniInfo1:SetEndIntensity(1)
  aniInfo1.IsChangeChild = true
  aniInfo1:SetHideAtEnd(true)
  aniInfo1:SetDisableWhileAni(true)
end
local stableEquipInfo = {
  slotConfig = {
    createIcon = false,
    createBorder = true,
    createCount = true,
    createEnchant = true,
    createCash = true
  },
  slotNoDef = {
    chest = 3,
    rightHand = 4,
    boots = 5,
    helm = 6,
    armor = 7,
    belt = 12
  },
  slotNoId = {
    [3] = "equipIcon_upperArmor",
    [4] = "equipIcon_weapon",
    [5] = "equipIcon_foot",
    [6] = "equipIcon_helm",
    [7] = "equipIcon_upperArmor2",
    [12] = "equipIcon_stirrups"
  },
  _staticBG = UI.getChildControl(Panel_Window_StableEquipInfo, "Static_EquipBG"),
  _staticEnchantLevel = UI.getChildControl(Panel_Window_StableEquipInfo, "Static_Text_Slot_Enchant_value"),
  _slot = Array.new(),
  _currentSlotNo = 0
}
function stableEquipInfo:init()
  for _, value in pairs(self.slotNoDef) do
    local slot = {}
    slot.icon = UI.getChildControl(Panel_Window_StableEquipInfo, self.slotNoId[value])
    SlotItem.new(slot, "StableEquipment_" .. value, value, Panel_Window_StableEquipInfo, self.slotConfig)
    slot:createChild()
    slot.icon:SetShow(true)
    CopyBaseProperty(self._staticEnchantLevel, slot.enchantText)
    slot.enchantText:SetSize(slot.icon:GetSizeX(), slot.icon:GetSizeY())
    slot.enchantText:SetPosX(0)
    slot.enchantText:SetPosY(0)
    slot.enchantText:SetTextHorizonCenter()
    slot.enchantText:SetTextVerticalCenter()
    slot.icon:addInputEvent("Mouse_On", "StableEquipInfo_MouseOn(" .. value .. ",true)")
    slot.icon:addInputEvent("Mouse_Out", "StableEquipInfo_MouseOn(" .. value .. ",false)")
    Panel_Tooltip_Item_SetPosition(value, slot, "StableEquipment")
    self._slot[value] = slot
  end
end
function stableEquipInfo:update()
  local self = stableEquipInfo
  local servantInfo = stable_getServant(StableList_SelectSlotNo())
  if nil == servantInfo then
    return
  end
  for _, v in pairs(self.slotNoDef) do
    local itemWrapper = servantInfo:getEquipItem(v)
    local slot = self._slot[v]
    if nil ~= itemWrapper then
      slot:setItem(itemWrapper)
    else
      slot:clearItem()
    end
  end
end
function stableEquipInfo:registEventHandler()
end
function stableEquipInfo:registMessageHandler()
  registerEvent("onScreenResize", "StableEquipInfo_Resize")
end
function StableEquipInfo_Resize()
  Panel_Window_StableEquipInfo:SetSpanSize(28, 360)
  Panel_Window_StableEquipInfo:ComputePos()
end
function StableEquipInfo_MouseOn(slotNo, isOn)
  Panel_Tooltip_Item_Show_GeneralNormal(slotNo, "StableEquipment", isOn)
end
function StableEquipInfo_Open()
  local self = stableEquipInfo
  self:update()
  Panel_Window_StableEquipInfo:SetShow(true)
  if Panel_Window_StableEquipInfo:GetShow() then
    return
  end
end
function StableEquipInfo_Close()
  if not Panel_Window_StableEquipInfo:GetShow() then
    return
  end
  Panel_Window_StableEquipInfo:SetShow(false)
end
stableEquipInfo:init()
stableEquipInfo:registEventHandler()
stableEquipInfo:registMessageHandler()
StableEquipInfo_Resize()

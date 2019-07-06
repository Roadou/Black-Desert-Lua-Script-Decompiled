local _panel = Instance_Widget_EquipmentList
local EquipSlotNoEnum = CppEnums.EquipSlotNoClient
local EquipmentList = {
  _ui = {
    stc_equipment = UI.getChildControl(_panel, "Static_Equipment"),
    stc_status = UI.getChildControl(_panel, "Static_Status"),
    stc_mainWeapon = nil,
    stc_earring = nil,
    stc_ring = nil,
    stc_necklace = nil,
    stc_armor = nil,
    stc_hand = nil,
    stc_head = nil,
    stc_subWeapon = nil,
    stc_foot = nil,
    stc_belt = nil,
    txt_AP = nil,
    txt_DP = nil
  },
  itemSlot = {
    [1] = EquipSlotNoEnum.eEquipSlotNoRightHand,
    [2] = EquipSlotNoEnum.eEquipSlotNoLeftHand,
    [3] = EquipSlotNoEnum.eEquipSlotNoChest,
    [4] = EquipSlotNoEnum.eEquipSlotNoGlove,
    [5] = EquipSlotNoEnum.eEquipSlotNoBoots,
    [6] = EquipSlotNoEnum.eEquipSlotNoHelm,
    [7] = EquipSlotNoEnum.eEquipSlotNoNecklace,
    [8] = EquipSlotNoEnum.eEquipSlotNoRing1,
    [9] = EquipSlotNoEnum.eEquipSlotNoRing2,
    [10] = EquipSlotNoEnum.eEquipSlotNoEaring1,
    [11] = EquipSlotNoEnum.eEquipSlotNoEaring2,
    [12] = EquipSlotNoEnum.eEquipSlotNoBelt
  },
  _beforeEquipmentCheck = {},
  _beforeAP = 0,
  _beforeDP = 0,
  updateTime = 0
}
function EquipmentList:open()
  _panel:SetShow(true)
end
function PaGlobalFunc_EquipmentList_Open()
  local self = EquipmentList
  self:open()
end
function EquipmentList:close()
  _panel:SetShow(false)
end
function PaGlobalFunc_EquipmentList_Close()
  local self = EquipmentList
  self:close()
end
function PaGlobalFunc_EquipmentList_UpdatePerFrame(deltaTime)
  local self = EquipmentList
  self.updateTime = self.updateTime + deltaTime
  if self.updateTime > 7 then
    self._ui.stc_equipment:SetShow(false)
    _panel:ClearUpdateLuaFunc()
    return
  end
end
function EquipmentList:initialize()
  self._ui.stc_mainWeapon = UI.getChildControl(self._ui.stc_equipment, "Static_MainWeapon")
  self._ui.stc_earring1 = UI.getChildControl(self._ui.stc_equipment, "Static_Earring1")
  self._ui.stc_earring2 = UI.getChildControl(self._ui.stc_equipment, "Static_Earring2")
  self._ui.stc_ring1 = UI.getChildControl(self._ui.stc_equipment, "Static_Ring1")
  self._ui.stc_ring2 = UI.getChildControl(self._ui.stc_equipment, "Static_Ring2")
  self._ui.stc_necklace = UI.getChildControl(self._ui.stc_equipment, "Static_Necklace")
  self._ui.stc_armor = UI.getChildControl(self._ui.stc_equipment, "Static_Armor")
  self._ui.stc_hand = UI.getChildControl(self._ui.stc_equipment, "Static_Hand")
  self._ui.stc_head = UI.getChildControl(self._ui.stc_equipment, "Static_Head")
  self._ui.stc_subWeapon = UI.getChildControl(self._ui.stc_equipment, "Static_SubWeapon")
  self._ui.stc_foot = UI.getChildControl(self._ui.stc_equipment, "Static_Foot")
  self._ui.stc_belt = UI.getChildControl(self._ui.stc_equipment, "Static_Belt")
  self._ui.txt_AP = UI.getChildControl(self._ui.stc_status, "StaticText_AP")
  self._ui.txt_DP = UI.getChildControl(self._ui.stc_status, "StaticText_DP")
  self:registerEventHandler()
end
function EquipmentList:updatePool()
  local itemGradeColor
  for index = 1, #self.itemSlot do
    local showTarget
    if 1 == index then
      showTarget = self._ui.stc_mainWeapon
    elseif 2 == index then
      showTarget = self._ui.stc_subWeapon
    elseif 3 == index then
      showTarget = self._ui.stc_armor
    elseif 4 == index then
      showTarget = self._ui.stc_hand
    elseif 5 == index then
      showTarget = self._ui.stc_foot
    elseif 6 == index then
      showTarget = self._ui.stc_head
    elseif 7 == index then
      showTarget = self._ui.stc_necklace
    elseif 8 == index then
      showTarget = self._ui.stc_ring1
    elseif 9 == index then
      showTarget = self._ui.stc_ring2
    elseif 10 == index then
      showTarget = self._ui.stc_earring1
    elseif 11 == index then
      showTarget = self._ui.stc_earring2
    elseif 12 == index then
      showTarget = self._ui.stc_belt
    else
      return
    end
    if nil ~= showTarget then
      local itemWrapper = ToClient_getEquipmentItem(self.itemSlot[index])
      if nil == itemWrapper then
        showTarget:SetShow(false)
        showTarget:SetAlpha(1)
      else
        showTarget:SetShow(true)
        local itemSSW = itemWrapper:getStaticStatus()
        local itemGrade = itemSSW:getGradeType()
        itemGradeColor = ConvertFromGradeToColor(itemGrade)
        showTarget:SetColor(itemGradeColor)
        if self._beforeEquipmentCheck[index] == itemWrapper:getStaticStatus():getName() then
        else
          self._beforeEquipmentCheck[index] = itemWrapper:getStaticStatus():getName()
        end
      end
    end
  end
  EquipmentList:APDPShow()
end
function EquipmentList:APDPShow()
  ToClient_updateAttackStat()
  local offenceValue = ToClient_getOffence()
  local defenceValue = ToClient_getDefence()
  if offenceValue > self._beforeAP then
    self._ui.txt_AP:AddEffect("UI_SkillButton01", false, 0, 0)
    self._beforeAP = offenceValue
  end
  if defenceValue > self._beforeDP then
    self._ui.txt_DP:AddEffect("UI_SkillButton01", false, 0, 0)
    self._beforeDP = defenceValue
  end
  local currentPlayerCount = ToClient_BattleRoyaleRemainPlayerCount()
  local blackSpiritLevel = 0
  local plusOffenceValue = 0
  local plusDefenceValue = 0
  if currentPlayerCount >= 1 then
    blackSpiritLevel = ToClient_GetBattleRoyaleGrowthLevel(currentPlayerCount)
    plusOffenceValue = ToClient_GetBattleRoyaleGrowthDD(blackSpiritLevel)
    plusDefenceValue = ToClient_GetBattleRoyaleGrowthPV(blackSpiritLevel)
  end
  if plusOffenceValue > 0 then
    self._ui.txt_AP:SetText(offenceValue .. " <PAColor0xffe7d583>+" .. plusOffenceValue .. "<PAOldColor>")
  else
    self._ui.txt_AP:SetText(offenceValue)
  end
  if plusDefenceValue > 0 then
    self._ui.txt_DP:SetText(defenceValue .. " <PAColor0xffe7d583>+" .. plusDefenceValue .. "<PAOldColor>")
  else
    self._ui.txt_DP:SetText(defenceValue)
  end
end
function EquipmentList_APDPShow()
  EquipmentList:APDPShow()
end
function EquipmentList:registerEventHandler()
  registerEvent("EventEquipmentUpdate", "FromClient_EquipmentList_UpdateEquipmentList")
  registerEvent("FromClient_ChangeBattleRoyalePlayerCount", "EquipmentList_APDPShow")
end
function FromClient_EquipmentList_UpdateEquipmentList()
  local self = EquipmentList
  if not self._ui.stc_equipment:GetShow() then
    self._ui.stc_equipment:SetShow(true)
  end
  self:updatePool()
  self.updateTime = 0
  _panel:RegisterUpdateFunc("PaGlobalFunc_EquipmentList_UpdatePerFrame")
end
function PaGlobalFunc_EquipmentList_LuaLoadComplete()
  local self = EquipmentList
  self:initialize()
end
registerEvent("FromClient_luaLoadComplete", "PaGlobalFunc_EquipmentList_LuaLoadComplete")

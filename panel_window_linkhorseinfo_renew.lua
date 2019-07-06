local Panel_Window_LinkHorseInfo_info = {
  _ui = {
    list2_SkillList = nil,
    static_EquipBg = nil,
    equipSlot = {},
    equipOverfitSlot = {}
  },
  _equipTotalSlot = {},
  _equipSlotNo = {
    [1] = 3,
    [2] = 4,
    [3] = 5,
    [4] = 6,
    [5] = 12
  },
  _equipOverfitSlotNo = {
    [1] = 14,
    [2] = 15,
    [3] = 16,
    [4] = 17
  },
  _config = {
    equipCheckFlag = {
      [3] = 1,
      [4] = 2,
      [5] = 4,
      [6] = 8,
      [14] = 16,
      [15] = 32,
      [16] = 64,
      [17] = 128
    },
    itemSlot = {
      createIcon = true,
      createBorder = true,
      createCount = true,
      createEnchant = true,
      createCash = true,
      createEnduranceIcon = true
    }
  },
  _value = {actorKeyRaw = nil, linkIndex = nil},
  _skillId = {}
}
function Panel_Window_LinkHorseInfo_info:registEventHandler()
  Panel_Window_LinkServantInfo:ignorePadSnapMoveToOtherPanel()
end
function Panel_Window_LinkHorseInfo_info:registerMessageHandler()
end
function Panel_Window_LinkHorseInfo_info:initialize()
  self:childControl()
  self:initValue()
  self:registerMessageHandler()
  self:registEventHandler()
end
function Panel_Window_LinkHorseInfo_info:initValue()
  self._value.actorKeyRaw = nil
  self._value.linkIndex = nil
end
function Panel_Window_LinkHorseInfo_info:resize()
end
function Panel_Window_LinkHorseInfo_info:childControl()
  self._ui.static_EquipBg = UI.getChildControl(Panel_Window_LinkServantInfo, "Static_EquipBg")
  for key, value in pairs(self._equipSlotNo) do
    local slot = {}
    slot.control = UI.getChildControl(self._ui.static_EquipBg, "Static_Equip" .. key)
    slot.check = UI.getChildControl(slot.control, "CheckButton_EquipWear" .. key)
    slot.iconBG = UI.getChildControl(slot.control, "Static_Icon_Slot" .. key)
    SlotItem.new(slot, "ServantInfoEquipment_" .. key, value, slot.control, self._config.itemSlot)
    slot:createChild()
    slot:clearItem()
    slot.control:SetChildOrder(slot.icon:GetKey(), slot.check:GetKey())
    Panel_Tooltip_Item_SetPosition(value, slot, "ServantEquipment")
    self._ui.equipSlot[value] = slot
    self._equipTotalSlot[value] = slot
  end
  for key, value in pairs(self._equipOverfitSlotNo) do
    local slot = {}
    slot.control = UI.getChildControl(self._ui.static_EquipBg, "Static_Outfit" .. key)
    slot.check = UI.getChildControl(slot.control, "CheckButton_OutfitWear" .. key)
    slot.iconBG = UI.getChildControl(slot.control, "Static_Icon_OutfitSlot" .. key)
    SlotItem.new(slot, "ServantInfoOverfit_" .. key, value, slot.control, self._config.itemSlot)
    slot:createChild()
    slot:clearItem()
    slot.control:SetChildOrder(slot.icon:GetKey(), slot.check:GetKey())
    Panel_Tooltip_Item_SetPosition(value, slot, "ServantEquipment")
    self._ui.equipOverfitSlot[value] = slot
    self._equipTotalSlot[value] = slot
  end
  self._ui.list2_SkillList = UI.getChildControl(Panel_Window_LinkServantInfo, "List2_SkillList")
  self._ui.list2_SkillList:registEvent(CppEnums.PAUIList2EventType.luaChangeContent, "PaGlobalFunc_LinkHorseInfo_SkillList")
  self._ui.list2_SkillList:createChildContent(CppEnums.PAUIList2ElementManagerType.list)
end
function Panel_Window_LinkHorseInfo_info:updateEquip()
  local carriageInfo
  local carriageInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == carriageInfo then
    return
  end
  local servantInfo = stable_getServantFromOwnerServant(carriageInfo:getServantNo(), self._value.linkIndex)
  if nil == servantInfo then
    return
  end
  local isVehicleType = servantInfo:getVehicleType()
  if CppEnums.VehicleType.Type_Elephant == isVehicleType then
    for key, value in pairs(self._equipSlotNo) do
      self._ui.equipSlot[value].check:SetShow(false)
    end
    for key, value in pairs(self._equipOverfitSlotNo) do
      self._ui.equipOverfitSlot[value].check:SetShow(false)
    end
  else
    for key, value in pairs(self._equipSlotNo) do
      if nil == self._config.equipCheckFlag[value] then
        self._ui.equipSlot[value].check:SetShow(false)
      else
        self._ui.equipSlot[value].check:SetShow(true)
      end
    end
    for key, value in pairs(self._equipOverfitSlotNo) do
      if nil == self._config.equipCheckFlag[value] then
        self._ui.equipOverfitSlot[value].check:SetShow(false)
      else
        self._ui.equipOverfitSlot[value].check:SetShow(true)
      end
    end
  end
  if nil ~= servantInfo then
    for key, value in pairs(self._equipSlotNo) do
      isCheck = ToClient_IsSetVehicleEquipSlotFlag(servantInfo:getVehicleType(), self._config.equipCheckFlag[value])
      self._ui.equipSlot[value].check:SetCheck(not isCheck)
      if CppEnums.VehicleType.Type_Horse == isVehicleType and 12 == value then
        self._ui.equipSlot[value].check:SetShow(false)
      end
    end
    for key, value in pairs(self._equipOverfitSlotNo) do
      isCheck = ToClient_IsSetVehicleEquipSlotFlag(servantInfo:getVehicleType(), self._config.equipCheckFlag[value])
      self._ui.equipOverfitSlot[value].check:SetCheck(not isCheck)
    end
  end
  for key, value in pairs(self._equipSlotNo) do
    local slot = self._ui.equipSlot[value]
    local itemWrapper = servantInfo:getEquipItem(value)
    if nil ~= itemWrapper then
      slot.iconBG:SetShow(false)
      slot:setItem(itemWrapper)
    else
      slot.iconBG:SetShow(true)
      slot:clearItem()
    end
  end
  for key, value in pairs(self._equipOverfitSlotNo) do
    local slot = self._ui.equipOverfitSlot[value]
    local itemWrapper = servantInfo:getEquipItem(value)
    if nil ~= itemWrapper then
      slot.iconBG:SetShow(false)
      slot:setItem(itemWrapper)
    else
      slot.iconBG:SetShow(true)
      slot:clearItem()
    end
  end
end
function Panel_Window_LinkHorseInfo_info:updateSkill()
  self._ui.list2_SkillList:getElementManager():clearKey()
  for k in pairs(self._skillId) do
    self._skillId[k] = nil
  end
  if nil == self._value.actorKeyRaw then
    return
  end
  local carriageInfo
  local carriageInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == carriageInfo then
    return
  end
  local servantInfo = stable_getServantFromOwnerServant(carriageInfo:getServantNo(), self._value.linkIndex)
  if nil == servantInfo then
    return
  end
  local slotSkillCount = 0
  local skillKey = {}
  local learnSkillCount = vehicleSkillStaticStatus_skillCount()
  for jj = 1, learnSkillCount - 1 do
    local skillWrapper = servantInfo:getSkill(jj)
    if nil ~= skillWrapper then
      self._skillId[slotSkillCount] = jj
      slotSkillCount = slotSkillCount + 1
    end
  end
  if 0 == slotSkillCount then
    self._ui.list2_SkillList:SetShow(false)
    return
  end
  self._ui.list2_SkillList:SetShow(true)
  for index = 0, slotSkillCount - 1 do
    self._ui.list2_SkillList:getElementManager():pushKey(toInt64(0, self._skillId[index]))
    self._ui.list2_SkillList:requestUpdateByKey(toInt64(0, self._skillId[index]))
  end
end
function Panel_Window_LinkHorseInfo_info:changeEquip(slotNo)
  local slot = self._equipTotalSlot[slotNo]
  if nil == self._value.actorKeyRaw then
    return
  end
  local carriageInfo
  local carriageInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == carriageInfo then
    return
  end
  local servantInfo = stable_getServantFromOwnerServant(carriageInfo:getServantNo(), self._value.linkIndex)
  if nil == servantInfo then
    return
  end
  slot.icon:AddEffect("UI_ItemInstall", false, 0, 0)
  slot.icon:AddEffect("fUI_SkillButton01", false, 0, 0)
  local itemWrapper = servantInfo:getEquipItem(slotNo)
  if nil == itemWrapper then
    return
  end
  local defence = itemWrapper:getStaticStatus():getDefence(0)
  if defence > 0 then
  end
end
function Panel_Window_LinkHorseInfo_info:updateContent()
  self:updateEquip()
  self:updateSkill()
end
function Panel_Window_LinkHorseInfo_info:openPos()
  if true == PaGlobalFunc_CarriageInfo_GetShow() then
    local openPosX, openPosY = PaGlobalFunc_CarriageInfo_linkHorsePosXY()
    if nil == openPosX or nil == openPosY then
      return
    end
    Panel_Window_LinkServantInfo:SetPosXY(openPosX, openPosY)
  end
end
function Panel_Window_LinkHorseInfo_info:open()
  Panel_Window_LinkServantInfo:SetShow(true)
end
function Panel_Window_LinkHorseInfo_info:close()
  Panel_Window_LinkServantInfo:SetShow(false)
end
function PaGlobalFunc_LinkHorseInfo_GetShow()
  return Panel_Window_LinkServantInfo:GetShow()
end
function PaGlobalFunc_LinkHorseInfo_Open()
  local self = Panel_Window_LinkHorseInfo_info
  self:open()
end
function PaGlobalFunc_LinkHorseInfo_Close()
  local self = Panel_Window_LinkHorseInfo_info
  self:close()
end
function PaGlobalFunc_LinkHorseInfo_Show(actorKeyRaw, index)
  local self = Panel_Window_LinkHorseInfo_info
  self._value.actorKeyRaw = actorKeyRaw
  self._value.linkIndex = index
  self:updateContent()
  self:openPos()
  self:open()
end
function PaGlobalFunc_LinkHorseInfo_Exit()
  local self = Panel_Window_LinkHorseInfo_info
  self:close()
end
function PaGlobalFunc_LinkHorseInfo_Update()
  local self = Panel_Window_LinkHorseInfo_info
  self:updateContent()
end
function PaGlobalFunc_LinkHorseInfo_UpdateEquipMent()
  local self = Panel_Window_LinkHorseInfo_info
  self:updateEquip()
end
function PaGlobalFunc_LinkHorseInfo_ChangequipMent(slotNo)
  local self = Panel_Window_LinkHorseInfo_info
  self:changeEquip(slotNo)
end
function PaGlobalFunc_LinkHorseInfo_SkillList(list_content, key)
  local self = Panel_Window_LinkHorseInfo_info
  local id = Int64toInt32(key)
  if nil == self._value.actorKeyRaw then
    return
  end
  local carriageInfo = getServantInfoFromActorKey(self._value.actorKeyRaw)
  if nil == carriageInfo then
    return
  end
  local servantInfo = stable_getServantFromOwnerServant(carriageInfo:getServantNo(), self._value.linkIndex)
  if nil == servantInfo then
    return
  end
  local skillWrapper = servantInfo:getSkill(id)
  if nil == skillWrapper then
    return
  end
  local button_SkillBg = UI.getChildControl(list_content, "Button_SkillBg")
  local static_SkillIcon = UI.getChildControl(list_content, "Static_SkillIcon")
  local circularProgress_Train = UI.getChildControl(list_content, "CircularProgress_Train")
  local staticText_Name = UI.getChildControl(list_content, "StaticText_Name")
  local staticText_Command = UI.getChildControl(list_content, "StaticText_Command")
  static_SkillIcon:ChangeTextureInfoName("Icon/" .. skillWrapper:getIconPath())
  staticText_Name:SetText(skillWrapper:getName())
  local expTxt = tonumber(string.format("%.0f", servantInfo:getSkillExp(id) / (skillWrapper:get()._maxExp / 100)))
  if expTxt >= 100 then
    expTxt = 100
  end
  circularProgress_Train:SetProgressRate(expTxt)
  staticText_Command:SetTextMode(CppEnums.TextMode.eTextMode_LimitText)
  staticText_Command:SetText(skillWrapper:getDescription())
end
function FromClient_LinkHorseInfo_Init()
  local self = Panel_Window_LinkHorseInfo_info
  self:initialize()
end
function FromClient_LinkHorseInfo_Resize()
  local self = Panel_Window_LinkHorseInfo_info
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_LinkHorseInfo_Init")

local Panel_Window_WharfInfo_info = {
  _ui = {
    static_TopBg = nil,
    static_Image = nil,
    staticText_Name = nil,
    staticText_Level = nil,
    staticText_Location = nil,
    static_InfoBg = nil,
    staticText_HPVal = nil,
    progress2_HP = nil,
    staticText_WeightVal = nil,
    progress2_Weight = nil,
    staticText_Other = nil,
    staticText_OtherVal = nil,
    progress2_Other = nil,
    staticText_SpeedVal = nil,
    staticText_SusVal = nil,
    staticText_Dead = nil,
    staticText_DeadVal = nil,
    staticText_AccVal = nil,
    staticText_Life = nil,
    staticText_LifeVal = nil,
    staticText_RotateVal = nil,
    staticText_BreakVal = nil,
    staticText_Desc = nil,
    StaticText_DescValue = nil,
    equipSlot = {},
    equipOverfitSlot = {}
  },
  _value = {
    lastEquipIndex = 0,
    currentEquipIndex = 0,
    lastOverfitIndex = 0,
    currentOverfitIndex = 0,
    currnetInfoType = 0,
    selectSceneIndex = -1
  },
  _enum = {eTYPE_SEALED = 0, eTYPE_UNSEALED = 1},
  _equipSlotNo = {
    [1] = 4,
    [2] = 5,
    [3] = 25,
    [4] = 3,
    [5] = 6,
    [6] = 12
  },
  _equipOverfitSlotNo = {
    [1] = 15,
    [2] = 16,
    [3] = 26,
    [4] = 14
  },
  _config = {
    equipCheckFlag = {
      [6] = 8
    },
    itemSlot = {
      createIcon = false,
      createBorder = true,
      createCount = true,
      createEnchant = true,
      createCash = true,
      createEnduranceIcon = true
    }
  }
}
function Panel_Window_WharfInfo_info:registerMessageHandler()
  registerEvent("onScreenResize", "FromClient_WharfInfo_Resize")
end
function Panel_Window_WharfInfo_info:initialize()
  self:childControl()
  self:initValue()
  self:resize()
end
function Panel_Window_WharfInfo_info:initValue()
  self._value.lastEquipIndex = 0
  self._value.currentEquipIndex = 0
  self._value.lastOverfitIndex = 0
  self._value.currentOverfitIndex = 0
  self._value.selectSceneIndex = -1
  self._value.currnetInfoType = self._enum.eTYPE_SEALED
end
function Panel_Window_WharfInfo_info:resize()
  Panel_Window_WharfInfo:ComputePos()
end
function Panel_Window_WharfInfo_info:childControl()
  self._ui.static_TopBg = UI.getChildControl(Panel_Window_WharfInfo, "Static_TopBg")
  self._ui.static_Image = UI.getChildControl(self._ui.static_TopBg, "Static_Image")
  self._ui.staticText_Name = UI.getChildControl(self._ui.static_TopBg, "StaticText_Name")
  self._ui.staticText_Level = UI.getChildControl(self._ui.static_TopBg, "StaticText_Level")
  self._ui.staticText_Location = UI.getChildControl(self._ui.static_TopBg, "StaticText_Location")
  self._ui.static_InfoBg = UI.getChildControl(Panel_Window_WharfInfo, "Static_InfoBg")
  self._ui.staticText_HPVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_HPVal")
  self._ui.progress2_HP = UI.getChildControl(self._ui.static_InfoBg, "Progress2_HP")
  self._ui.staticText_WeightVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_WeightVal")
  self._ui.progress2_Weight = UI.getChildControl(self._ui.static_InfoBg, "Progress2_Weight")
  self._ui.staticText_Other = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Other")
  self._ui.staticText_OtherVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_OtherVal")
  self._ui.progress2_Other = UI.getChildControl(self._ui.static_InfoBg, "Progress2_Other")
  self._ui.staticText_SpeedVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_SpeedVal")
  self._ui.staticText_SusVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_SusVal")
  self._ui.staticText_Dead = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Dead")
  self._ui.staticText_DeadVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_DeadVal")
  self._ui.staticText_AccVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_AccVal")
  self._ui.staticText_Life = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Life")
  self._ui.staticText_LifeVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_LifeVal")
  self._ui.staticText_RotateVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_RotateVal")
  self._ui.staticText_BreakVal = UI.getChildControl(self._ui.static_InfoBg, "StaticText_BreakVal")
  self._ui.staticText_Desc = UI.getChildControl(self._ui.static_InfoBg, "StaticText_Desc")
  self._ui.StaticText_DescValue = UI.getChildControl(self._ui.static_InfoBg, "StaticText_DescValue")
  for key, value in pairs(self._equipSlotNo) do
    local slot = {}
    slot.control = UI.getChildControl(self._ui.static_InfoBg, "Static_Equip" .. key)
    slot.check = UI.getChildControl(slot.control, "CheckButton_EquipWear" .. key)
    slot.iconBG = UI.getChildControl(slot.control, "Static_Icon_Slot" .. key)
    SlotItem.new(slot, "ServantInfoEquipment_" .. key, value, slot.control, self._config.itemSlot)
    slot:createChild()
    slot:clearItem()
    slot.control:SetChildOrder(slot.icon:GetKey(), slot.check:GetKey())
    Panel_Tooltip_Item_SetPosition(value, slot, "ServantEquipment")
    self._ui.equipSlot[value] = slot
  end
  for key, value in pairs(self._equipOverfitSlotNo) do
    local slot = {}
    slot.control = UI.getChildControl(self._ui.static_InfoBg, "Static_Outfit" .. key)
    slot.check = UI.getChildControl(slot.control, "CheckButton_OutfitWear" .. key)
    slot.iconBG = UI.getChildControl(slot.control, "Static_Icon_OutfitSlot" .. key)
    SlotItem.new(slot, "ServantInfoOverfit_" .. key, value, slot.control, self._config.itemSlot)
    slot:createChild()
    slot:clearItem()
    slot.control:SetChildOrder(slot.icon:GetKey(), slot.check:GetKey())
    Panel_Tooltip_Item_SetPosition(value, slot, "ServantEquipment")
    self._ui.equipOverfitSlot[value] = slot
  end
end
function Panel_Window_WharfInfo_info:setContent(unsealType)
  local servantInfo
  if 0 == unsealType then
    servantInfo = stable_getServant(PaGlobalFunc_WharfList_SelectSlotNo())
    PaGlobalFunc_WharfInfo_Menu_Show(Panel_Window_WharfInfo, unsealType, PaGlobalFunc_WharfList_SelectSlotNo())
  elseif 1 == unsealType then
    local temporaryWrapper = getTemporaryInformationWrapper()
    if nil == temporaryWrapper then
      return
    end
    servantInfo = temporaryWrapper:getUnsealVehicle(stable_getServantType())
    PaGlobalFunc_WharfInfo_Menu_Show(Panel_Window_WharfInfo, unsealType)
  else
    if 2 == unsealType then
    else
    end
  end
  if nil == servantInfo then
    return
  end
  self._value.selectSceneIndex = Servant_ScenePushObject(servantInfo, self._value.selectSceneIndex)
  if nil ~= servantInfo:getActionIndex() then
    showSceneCharacter(self._value.selectSceneIndex, false)
    showSceneCharacter(self._value.selectSceneIndex, true, servantInfo:getActionIndex())
  end
  self._ui.staticText_Name:SetTextMode(CppEnums.TextMode.eTextMode_AutoWrap)
  self._ui.staticText_Name:SetText(servantInfo:getName())
  self._ui.staticText_Level:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_COMMON_LV") .. "." .. tostring(servantInfo:getLevel()))
  self._ui.static_Image:SetShow(true)
  self._ui.static_Image:ChangeTextureInfoName(servantInfo:getIconPath1())
  self._ui.staticText_Location:SetText(servantInfo:getRegionName())
  self._ui.staticText_Location:SetPosY(self._ui.staticText_Name:GetPosY() + self._ui.staticText_Name:GetTextSizeY() + 5)
  self._ui.staticText_HPVal:SetText(makeDotMoney(servantInfo:getHp()) .. " / " .. makeDotMoney(servantInfo:getMaxHp()))
  self._ui.progress2_HP:SetProgressRate(servantInfo:getHp() * 100 / servantInfo:getMaxHp())
  local max_weight = Int64toInt32(servantInfo:getMaxWeight_s64() / Defines.s64_const.s64_10000)
  local total_weight = Int64toInt32((servantInfo:getInventoryWeight_s64() + servantInfo:getEquipWeight_s64()) / Defines.s64_const.s64_10000)
  local weightPercent = total_weight / max_weight * 100
  local weightValue = ""
  if max_weight < total_weight then
    weightPercent = 100
    weightValue = "<PAColor0xFFD20000>" .. makeDotMoney(total_weight) .. "<PAOldColor> / " .. makeDotMoney(max_weight)
  else
    weightValue = makeDotMoney(total_weight) .. " / " .. makeDotMoney(max_weight)
  end
  self._ui.staticText_WeightVal:SetText(weightValue)
  self._ui.progress2_Weight:SetProgressRate(weightPercent)
  self._ui.staticText_OtherVal:SetText(makeDotMoney(servantInfo:getMp()) .. " / " .. makeDotMoney(servantInfo:getMaxMp()))
  self._ui.progress2_Other:SetProgressRate(servantInfo:getMp() * 100 / servantInfo:getMaxMp())
  if servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Boat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_Raft or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_FishingBoat or servantInfo:getVehicleType() == CppEnums.VehicleType.Type_SailingBoat then
    self._ui.staticText_Other:SetText(PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_HEART"))
    self._ui.staticText_LifeVal:SetShow(false)
    self._ui.staticText_Life:SetShow(false)
  else
    self._ui.staticText_Other:SetText(PAGetString(Defines.StringSheet_RESOURCE, "PANEL_SERVANT_SHIPINFO_MP"))
    self._ui.staticText_LifeVal:SetShow(true)
    self._ui.staticText_Life:SetShow(true)
    if servantInfo:isPeriodLimit() then
      self._ui.staticText_LifeVal:SetText(convertStringFromDatetime(servantInfo:getExpiredTime()))
    else
      self._ui.staticText_LifeVal:SetText(PAGetString(Defines.StringSheet_RESOURCE, "STABLE_INFO_TEXT_LIFEVALUE"))
    end
  end
  self._ui.staticText_SpeedVal:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_MaxMoveSpeed) / 10000) .. "%")
  self._ui.staticText_AccVal:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_Acceleration) / 10000) .. "%")
  self._ui.staticText_RotateVal:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_CorneringSpeed) / 10000) .. "%")
  self._ui.staticText_BreakVal:SetText(string.format("%.1f", servantInfo:getStat(CppEnums.ServantStatType.Type_BrakeSpeed) / 10000) .. "%")
  self._ui.staticText_SusVal:SetText(servantInfo:getSuspension())
  local descText = ""
  local descValue = ""
  local deadCount = servantInfo:getDeadCount()
  self._ui.staticText_Dead:SetText(PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_DESTROYCOUNT"))
  descText = PAGetString(Defines.StringSheet_GAME, "LUA_STABLEINFO_DESTROYCOUNT")
  if servantInfo:doClearCountByDead() then
    descValue = "<PAColor0xffeeeeee>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RESET_POSSIBLE") .. "<PAOldColor>"
  else
    descValue = "<PAColor0xffeeeeee>" .. PAGetString(Defines.StringSheet_GAME, "LUA_SERVANT_RESET_IMPOSSIBLE") .. "<PAOldColor>"
  end
  self._ui.staticText_DeadVal:SetText(deadCount)
  if "" == descText then
    self._ui.staticText_Desc:SetShow(false)
  else
    self._ui.staticText_Desc:SetShow(true)
    self._ui.staticText_Desc:SetText(descText)
  end
  if "" == descValue then
    self._ui.StaticText_DescValue:SetShow(false)
  else
    self._ui.StaticText_DescValue:SetShow(true)
    self._ui.StaticText_DescValue:SetText(descValue)
  end
end
function Panel_Window_WharfInfo_info:setEquipment()
  local servantWrapper
  if self._value.currnetInfoType == self._enum.eTYPE_SEALED then
    servantWrapper = stable_getServant(PaGlobalFunc_WharfList_SelectSlotNo())
  elseif self._value.currnetInfoType == self._enum.eTYPE_UNSEALED then
    local temporaryWrapper = getTemporaryInformationWrapper()
    if nil == temporaryWrapper then
      return
    end
    servantWrapper = temporaryWrapper:getUnsealVehicle(stable_getServantType())
  end
  local isVehicleType = servantWrapper:getVehicleType()
  local isNotHaveSailer = servantWrapper:getVehicleType() == CppEnums.VehicleType.Type_Boat or servantWrapper:getVehicleType() == CppEnums.VehicleType.Type_Raft or servantWrapper:getVehicleType() == CppEnums.VehicleType.Type_FishingBoat or servantWrapper:getVehicleType() == CppEnums.VehicleType.Type_SailingBoat
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
  if isNotHaveSailer then
    self._ui.equipSlot[12].control:SetShow(false)
    self._ui.equipSlot[3].control:SetShow(false)
    self._ui.equipSlot[6].control:SetShow(true)
  else
    self._ui.equipSlot[12].control:SetShow(true)
    self._ui.equipSlot[3].control:SetShow(true)
    self._ui.equipSlot[6].control:SetShow(false)
  end
  for key, value in pairs(self._equipSlotNo) do
    local slot = self._ui.equipSlot[value]
    local itemWrapper = servantWrapper:getEquipItem(value)
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
    local itemWrapper = servantWrapper:getEquipItem(value)
    if nil ~= itemWrapper then
      slot.iconBG:SetShow(false)
      slot:setItem(itemWrapper)
    else
      slot.iconBG:SetShow(true)
      slot:clearItem()
    end
  end
end
function Panel_Window_WharfInfo_info:open()
  Panel_Window_WharfInfo:SetShow(true)
end
function Panel_Window_WharfInfo_info:close()
  Panel_Window_WharfInfo:SetShow(false)
end
function PaGlobalFunc_WharfInfo_GetShow()
  return Panel_Window_WharfInfo:GetShow()
end
function PaGlobalFunc_WharfInfo_Open()
  local self = Panel_Window_WharfInfo_info
  self:open()
end
function PaGlobalFunc_WharfInfo_Close()
  local self = Panel_Window_WharfInfo_info
  self:close()
end
function PaGlobalFunc_WharfInfo_Show(eType)
  local self = Panel_Window_WharfInfo_info
  if nil == eType then
    eType = self._enum.eTYPE_SEALED
  end
  PaGlobalFunc_WharfInfo_Menu_Close()
  Servant_ScenePopObject(self._value.selectSceneIndex)
  self:initValue()
  self._value.currnetInfoType = eType
  self:setContent(self._value.currnetInfoType)
  self:setEquipment()
  self:open()
end
function PaGlobalFunc_WharfInfo_CloseWith()
  local self = Panel_Window_WharfInfo_info
  self:close()
  Servant_ScenePopObject(self._value.selectSceneIndex)
  PaGlobalFunc_WharfInfo_Menu_Close()
end
function PaGlobalFunc_WharfInfo_Exit()
  PaGlobalFunc_WharfInfo_CloseWith()
  PaGlobalFunc_WharfList_UnClickList()
  PaGlobalFunc_WharfList_Open()
end
function PaGlobalFunc_WharfInfo_Update()
  local self = Panel_Window_WharfInfo_info
  if not PaGlobalFunc_WharfInfo_GetShow() then
    return
  end
  self:setContent(self._value.currnetInfoType)
  self:setEquipment()
end
function PaGlobalFunc_WharfInfo_CharacterSceneResetServantNo(servantNo)
  local self = Panel_Window_WharfInfo_info
  local servantInfo = stable_getServantByServantNo(servantNo)
  if nil == servantInfo then
    return
  end
  self._value.selectSceneIndex = Servant_ScenePushObject(servantInfo, self._value.selectSceneIndex)
  if nil ~= servantInfo:getActionIndex() then
    showSceneCharacter(self._value.selectSceneIndex, false)
    showSceneCharacter(self._value.selectSceneIndex, true, servantInfo:getActionIndex())
  end
end
function FromClient_WharfInfo_Init()
  local self = Panel_Window_WharfInfo_info
  self:initialize()
end
function FromClient_WharfInfo_Resize()
  local self = Panel_Window_WharfInfo_info
  self:resize()
end
registerEvent("FromClient_luaLoadComplete", "FromClient_WharfInfo_Init")
